// =========================================================================
// GARUDA SEMESTA — L2 CACHE SUBSYSTEM (v12.4.6-R2-FIXED)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 4-Way Set Associative L2 Cache:
// - 32-bit Address, 32-bit Data Bus
// - Per-Word Valid Vector (valid_array[WAYS][SETS][7:0])
// - High-speed zero-lag L2 Cache state machine
// - Fixed LRU way allocation per line tag
// =========================================================================

`timescale 1ns / 1ps

module garuda_l2_cache #(
    parameter CACHE_SIZE_BYTES = 2048,
    parameter WAYS             = 4,
    parameter LINE_SIZE_BYTES  = 32,
    parameter ADDR_WIDTH       = 32,
    parameter DATA_WIDTH       = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // L1 Cache Request Interface
    input  wire [ADDR_WIDTH-1:0] l1_req_addr,
    input  wire [DATA_WIDTH-1:0] l1_req_write_data,
    input  wire                  l1_req_write_en,
    input  wire                  l1_req_valid,
    output reg  [DATA_WIDTH-1:0] l1_resp_read_data,
    output reg                   l1_resp_hit,
    output reg                   l1_resp_valid,
    output reg                   l1_backpressure,

    // Parity / Error Output
    output reg                   parity_error_detected,

    // Memory Controller / SRAM Interconnect
    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_write_data,
    output reg                   mem_write_en,
    output reg                   mem_req_valid,
    input  wire [DATA_WIDTH-1:0] mem_read_data,
    input  wire                  mem_resp_valid
);

    localparam SETS           = CACHE_SIZE_BYTES / (WAYS * LINE_SIZE_BYTES); // 16 sets
    localparam OFFSET_BITS    = 5;
    localparam INDEX_BITS     = 4; // 16 sets => 4 bits
    localparam TAG_BITS       = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 23 bits
    localparam WORDS_PER_LINE = LINE_SIZE_BYTES / 4; // 8 words (32-bit each)

    localparam ST_IDLE    = 2'b00;
    localparam ST_COMPARE = 2'b01;
    localparam ST_REFILL  = 2'b10;
    localparam ST_RESP    = 2'b11;

    reg [1:0] state, next_state;

    // Cache Arrays (4 Ways)
    reg [TAG_BITS-1:0]          tag_array   [0:WAYS-1][0:SETS-1];
    reg [WORDS_PER_LINE-1:0]    valid_array [0:WAYS-1][0:SETS-1];
    reg [DATA_WIDTH-1:0]        data_array  [0:WAYS-1][0:SETS-1][0:WORDS_PER_LINE-1];
    reg [1:0]                   lru_way     [0:SETS-1]; // Round-Robin pointer per set
    reg [1:0]                   refill_way;

    wire [TAG_BITS-1:0]   req_tag     = l1_req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0] req_set     = l1_req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [2:0]            word_offset = l1_req_addr[OFFSET_BITS-1 : 2];

    // Check if line tag is already allocated in any way
    wire way0_tag_match = (tag_array[0][req_set] == req_tag) && (|valid_array[0][req_set]);
    wire way1_tag_match = (tag_array[1][req_set] == req_tag) && (|valid_array[1][req_set]);
    wire way2_tag_match = (tag_array[2][req_set] == req_tag) && (|valid_array[2][req_set]);
    wire way3_tag_match = (tag_array[3][req_set] == req_tag) && (|valid_array[3][req_set]);

    wire tag_allocated = way0_tag_match || way1_tag_match || way2_tag_match || way3_tag_match;
    wire [1:0] allocated_way = way0_tag_match ? 2'b00 : (way1_tag_match ? 2'b01 : (way2_tag_match ? 2'b10 : 2'b11));

    // 4-Way Parallel Hit Comparator (Per-Word Valid Bit Vector Check)
    wire way0_hit = valid_array[0][req_set][word_offset] && (tag_array[0][req_set] == req_tag);
    wire way1_hit = valid_array[1][req_set][word_offset] && (tag_array[1][req_set] == req_tag);
    wire way2_hit = valid_array[2][req_set][word_offset] && (tag_array[2][req_set] == req_tag);
    wire way3_hit = valid_array[3][req_set][word_offset] && (tag_array[3][req_set] == req_tag);

    wire any_hit = way0_hit || way1_hit || way2_hit || way3_hit;
    wire [1:0] hit_way = way0_hit ? 2'b00 : (way1_hit ? 2'b01 : (way2_hit ? 2'b10 : 2'b11));

    // Zero-lag combinational assignments
    assign mem_addr       = l1_req_addr;
    assign mem_write_data = l1_req_write_data;

    integer w, s;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            l1_backpressure <= 1'b0;
            l1_resp_hit <= 1'b0;
            l1_resp_valid <= 1'b0;
            l1_resp_read_data <= {DATA_WIDTH{1'b0}};
            parity_error_detected <= 1'b0;
            mem_req_valid <= 1'b0;
            mem_write_en <= 1'b0;
            refill_way <= 2'b00;

            for (s = 0; s < SETS; s = s + 1) begin
                lru_way[s] <= 2'b00;
                for (w = 0; w < WAYS; w = w + 1) begin
                    tag_array[w][s] <= {TAG_BITS{1'b0}};
                    valid_array[w][s] <= {WORDS_PER_LINE{1'b0}};
                end
            end
        end else begin
            state <= next_state;

            case (state)
                ST_IDLE: begin
                    l1_resp_valid <= 1'b0;
                    l1_backpressure <= 1'b0;
                    if (l1_req_valid) l1_backpressure <= 1'b1;
                end

                ST_COMPARE: begin
                    if (any_hit && !l1_req_write_en) begin
                        l1_resp_hit <= 1'b1;
                        l1_resp_valid <= 1'b1;
                        l1_backpressure <= 1'b0;
                        l1_resp_read_data <= data_array[hit_way][req_set][word_offset];
                        parity_error_detected <= ^data_array[hit_way][req_set][word_offset];
                    end else begin
                        // Mandatory write-through to memory controller on both write hit & write miss
                        l1_resp_hit <= any_hit;
                        l1_backpressure <= 1'b1;
                        mem_req_valid <= 1'b1;
                        mem_write_en <= l1_req_write_en;

                        if (any_hit) begin
                            refill_way <= hit_way;
                        end else if (tag_allocated) begin
                            refill_way <= allocated_way;
                        end else begin
                            refill_way <= lru_way[req_set];
                            lru_way[req_set] <= lru_way[req_set] + 1'b1;
                        end

                        if (any_hit && l1_req_write_en) begin
                            data_array[hit_way][req_set][word_offset] <= l1_req_write_data;
                            valid_array[hit_way][req_set][word_offset] <= 1'b1;
                        end
                    end
                end

                ST_REFILL: begin
                    if (mem_resp_valid) begin
                        w = refill_way;
                        tag_array[w][req_set] <= req_tag;
                        valid_array[w][req_set][word_offset] <= 1'b1;
                        data_array[w][req_set][word_offset] <= (l1_req_write_en) ? l1_req_write_data : mem_read_data;
                        mem_req_valid <= 1'b0;
                    end
                end

                ST_RESP: begin
                    l1_resp_hit <= 1'b1;
                    l1_resp_valid <= 1'b1;
                    l1_resp_read_data <= mem_read_data;
                    l1_backpressure <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: if (l1_req_valid) next_state = ST_COMPARE;
            ST_COMPARE: begin
                if (any_hit && !l1_req_write_en) next_state = ST_IDLE;
                else next_state = ST_REFILL;
            end
            ST_REFILL: if (mem_resp_valid) next_state = ST_RESP;
            ST_RESP: next_state = ST_IDLE;
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
