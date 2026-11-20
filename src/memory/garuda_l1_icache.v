// =========================================================================
// GARUDA SEMESTA — L1 4KB INSTRUCTION CACHE MODULE (v12.3.2-R1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 4 KB L1 Instruction Cache:
// - 32-bit Address, 64-bit Full GARUDA ISA Instruction Word Output
// - Direct-Mapped (128 Lines, 32-Byte Line Size)
// - Valid Bit Array, Tag Array, Data SRAM Array
// - Hit/Miss Detection FSM & Refill Controller
// =========================================================================

`timescale 1ns / 1ps

module garuda_l1_icache #(
    parameter CACHE_SIZE_BYTES = 4096,
    parameter LINE_SIZE_BYTES  = 32,
    parameter ADDR_WIDTH       = 32,
    parameter DATA_WIDTH       = 64  // Updated to 64-bit Full GARUDA ISA Instruction Word
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // CPU Core Read Interface
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] resp_data,
    output reg                   resp_hit,
    output reg                   resp_valid,
    output reg                   stall,

    // Management Interface
    input  wire                  flush,
    input  wire                  invalidate,

    // Memory Controller / L2 Interface
    output reg  [ADDR_WIDTH-1:0] mem_req_addr,
    output reg                   mem_req_valid,
    input  wire [DATA_WIDTH-1:0] mem_resp_data,
    input  wire                  mem_resp_valid
);

    localparam NUM_LINES   = CACHE_SIZE_BYTES / LINE_SIZE_BYTES; // 128 lines
    localparam OFFSET_BITS  = 5;  // 32-byte line => 5 bits
    localparam INDEX_BITS   = 7;  // 128 lines => 7 bits
    localparam TAG_BITS     = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 20 bits
    localparam WORDS_PER_LINE = LINE_SIZE_BYTES / (DATA_WIDTH / 8); // 32 / 8 = 4 words (64-bit each)

    // FSM States
    localparam ST_IDLE       = 2'b00;
    localparam ST_COMPARE    = 2'b01;
    localparam ST_REFILL     = 2'b10;
    localparam ST_RESP       = 2'b11;

    reg [1:0] state, next_state;

    // Cache Storage Arrays
    reg [TAG_BITS-1:0]  tag_array   [0:NUM_LINES-1];
    reg                 valid_array [0:NUM_LINES-1];
    reg [DATA_WIDTH-1:0] data_array  [0:NUM_LINES-1][0:WORDS_PER_LINE-1];

    // Address Breakdown
    wire [TAG_BITS-1:0]    req_tag     = req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0]  req_index   = req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [1:0]             word_offset = req_addr[OFFSET_BITS-1 : 3]; // 64-bit word aligned

    wire tag_match = valid_array[req_index] && (tag_array[req_index] == req_tag);

    integer i, j;

    // Sequential State & Cache Updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            stall <= 1'b0;
            resp_hit <= 1'b0;
            resp_valid <= 1'b0;
            resp_data <= {DATA_WIDTH{1'b0}};
            mem_req_valid <= 1'b0;
            mem_req_addr <= {ADDR_WIDTH{1'b0}};
            for (i = 0; i < NUM_LINES; i = i + 1) begin
                valid_array[i] <= 1'b0;
                tag_array[i] <= {TAG_BITS{1'b0}};
                for (j = 0; j < WORDS_PER_LINE; j = j + 1) begin
                    data_array[i][j] <= {DATA_WIDTH{1'b0}};
                end
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
                    stall <= 1'b0;
                    if (req_valid) begin
                        stall <= 1'b1;
                    end
                end

                ST_COMPARE: begin
                    if (tag_match) begin
                        resp_hit <= 1'b1;
                        resp_valid <= 1'b1;
                        resp_data <= data_array[req_index][word_offset];
                        stall <= 1'b0;
                    end else begin
                        resp_hit <= 1'b0;
                        mem_req_valid <= 1'b1;
                        mem_req_addr <= {req_addr[ADDR_WIDTH-1:OFFSET_BITS], {OFFSET_BITS{1'b0}}};
                        stall <= 1'b1;
                    end
                end

                ST_REFILL: begin
                    if (mem_resp_valid) begin
                        tag_array[req_index] <= req_tag;
                        valid_array[req_index] <= 1'b1;
                        data_array[req_index][word_offset] <= mem_resp_data;
                        mem_req_valid <= 1'b0;
                    end
                end

                ST_RESP: begin
                    resp_hit <= 1'b1;
                    resp_valid <= 1'b1;
                    resp_data <= data_array[req_index][word_offset];
                    stall <= 1'b0;
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
                if (tag_match) next_state = ST_IDLE;
                else next_state = ST_REFILL;
            end
            ST_REFILL: begin
                if (mem_resp_valid) next_state = ST_RESP;
            end
            ST_RESP: begin
                next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
