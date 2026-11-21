// =========================================================================
// GARUDA SEMESTA — L1 4KB INSTRUCTION CACHE MODULE (v12.4.6-R2)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 4 KB L1 Instruction Cache:
// - 32-bit Address, 64-bit Full GARUDA ISA Instruction Word Output
// - Direct-Mapped (128 Lines, 32-Byte Line Size = 4 x 64-bit Words per Line)
// - Zero-lag combinational stall output on miss to freeze PC at exact request address
// =========================================================================

`timescale 1ns / 1ps

module garuda_l1_icache #(
    parameter CACHE_SIZE_BYTES = 4096,
    parameter LINE_SIZE_BYTES  = 32,
    parameter ADDR_WIDTH       = 32,
    parameter DATA_WIDTH       = 64
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // CPU Core Read Interface
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] resp_data,
    output reg                   resp_hit,
    output reg                   resp_valid,
    output wire                  stall,

    // Management Interface
    input  wire                  flush,
    input  wire                  invalidate,

    // Memory Controller / L2 Interface (Explicit Handshake)
    output reg  [ADDR_WIDTH-1:0] mem_req_addr,
    output reg                   mem_req_valid,
    input  wire                  mem_req_ready,
    input  wire [DATA_WIDTH-1:0] mem_resp_data,
    input  wire                  mem_resp_valid,
    input  wire                  mem_resp_error
);

    localparam NUM_LINES      = CACHE_SIZE_BYTES / LINE_SIZE_BYTES; // 128 lines
    localparam OFFSET_BITS     = 5;  // 32-byte line => 5 bits
    localparam INDEX_BITS      = 7;  // 128 lines => 7 bits
    localparam TAG_BITS        = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 20 bits
    localparam WORDS_PER_LINE  = LINE_SIZE_BYTES / (DATA_WIDTH / 8); // 4 words (64-bit each)

    // FSM States
    localparam ST_IDLE       = 2'b00;
    localparam ST_COMPARE    = 2'b01;
    localparam ST_REFILL     = 2'b10;
    localparam ST_RESP       = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] refill_word_cnt;
    reg [ADDR_WIDTH-1:0] latched_req_addr;

    // Cache Storage Arrays
    reg [TAG_BITS-1:0]   tag_array   [0:NUM_LINES-1];
    reg                  valid_array [0:NUM_LINES-1];
    reg [DATA_WIDTH-1:0] data_array  [0:NUM_LINES-1][0:WORDS_PER_LINE-1];

    // Address Breakdown
    wire [TAG_BITS-1:0]    req_tag           = req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0]  req_index         = req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [1:0]             word_offset       = req_addr[OFFSET_BITS-1 : 3];
    wire [INDEX_BITS-1:0]  latched_index     = latched_req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [1:0]             latched_offset    = latched_req_addr[OFFSET_BITS-1 : 3];
    wire [ADDR_WIDTH-1:0]  latched_line_base = {latched_req_addr[ADDR_WIDTH-1:OFFSET_BITS], {OFFSET_BITS{1'b0}}};

    wire tag_match = valid_array[req_index] && (tag_array[req_index] == req_tag);

    // Zero-lag combinational stall to prevent PC increment during miss
    assign stall = (state == ST_IDLE && req_valid && !tag_match) || (state == ST_COMPARE && !tag_match) || (state == ST_REFILL);

    integer i;

    // Sequential State & Multi-Word Line Refill
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            resp_hit <= 1'b0;
            resp_valid <= 1'b0;
            resp_data <= {DATA_WIDTH{1'b0}};
            mem_req_valid <= 1'b0;
            mem_req_addr <= {ADDR_WIDTH{1'b0}};
            latched_req_addr <= {ADDR_WIDTH{1'b0}};
            refill_word_cnt <= 2'b00;

            for (i = 0; i < NUM_LINES; i = i + 1) begin
                valid_array[i] <= 1'b0;
                tag_array[i] <= {TAG_BITS{1'b0}};
            end
        end else begin
            if (flush || invalidate) begin
                for (i = 0; i < NUM_LINES; i = i + 1) begin
                    valid_array[i] <= 1'b0;
                end
            end

            state <= next_state;

            case (state)
                ST_IDLE: begin
                    resp_valid <= 1'b0;
                    refill_word_cnt <= 2'b00;
                    if (req_valid) begin
                        latched_req_addr <= req_addr;
                    end
                end

                ST_COMPARE: begin
                    if (tag_match) begin
                        resp_hit <= 1'b1;
                        resp_valid <= 1'b1;
                        resp_data <= data_array[req_index][word_offset];
                    end else begin
                        resp_hit <= 1'b0;
                        mem_req_valid <= 1'b1;
                        mem_req_addr <= latched_line_base; // Word 0: latched_base + 0
                        refill_word_cnt <= 2'b00;
                    end
                end

                ST_REFILL: begin
                    if (mem_resp_error) begin
                        valid_array[latched_index] <= 1'b0;
                        mem_req_valid <= 1'b0;
                    end else if (mem_resp_valid) begin
                        data_array[latched_index][refill_word_cnt] <= mem_resp_data;
                        if (refill_word_cnt == (WORDS_PER_LINE - 1)) begin
                            tag_array[latched_index] <= latched_req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
                            valid_array[latched_index] <= 1'b1;
                            mem_req_valid <= 1'b0;
                        end else begin
                            refill_word_cnt <= refill_word_cnt + 1'b1;
                            mem_req_addr <= latched_line_base + ((refill_word_cnt + 1'b1) * 8);
                            mem_req_valid <= 1'b1; // Explicitly request next word
                        end
                    end
                end

                ST_RESP: begin
                    resp_hit <= 1'b1;
                    resp_valid <= 1'b1;
                    resp_data <= data_array[latched_index][latched_offset];
                end
            endcase
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                if (req_valid) next_state = ST_COMPARE;
            end
            ST_COMPARE: begin
                if (tag_match) begin
                    next_state = ST_IDLE;
                end else if (mem_req_ready) begin
                    next_state = ST_REFILL;
                end
            end
            ST_REFILL: begin
                if (mem_resp_error) begin
                    next_state = ST_IDLE;
                end else if (mem_resp_valid && (refill_word_cnt == (WORDS_PER_LINE - 1))) begin
                    next_state = ST_RESP;
                end
            end
            ST_RESP: begin
                next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
