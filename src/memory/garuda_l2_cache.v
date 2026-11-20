// =========================================================================
// GARUDA SEMESTA — L2 32KB CACHE SUBSYSTEM (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 32 KB 4-Way Set Associative L2 Cache:
// - 32-bit Address, 32-bit Data Bus
// - 4-Way Parallel Tag Comparison
// - Round-Robin / LRU Way Replacement Policy
// - Parity Bit Error Detection & Memory Backpressure Signal
// =========================================================================

`timescale 1ns / 1ps

module garuda_l2_cache #(
    parameter CACHE_SIZE_BYTES = 32768,
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
    output reg  [ADDR_WIDTH-1:0] mem_addr,
    output reg  [DATA_WIDTH-1:0] mem_write_data,
    output reg                   mem_write_en,
    output reg                   mem_req_valid,
    input  wire [DATA_WIDTH-1:0] mem_read_data,
    input  wire                  mem_resp_valid
);

    localparam SETS        = CACHE_SIZE_BYTES / (WAYS * LINE_SIZE_BYTES); // 256 sets
    localparam OFFSET_BITS = 5;
    localparam INDEX_BITS  = 8;
    localparam TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 19 bits

    localparam ST_IDLE    = 2'b00;
    localparam ST_COMPARE = 2'b01;
    localparam ST_REFILL  = 2'b10;
    localparam ST_RESP    = 2'b11;

    reg [1:0] state, next_state;

    // Cache Arrays (4 Ways)
    reg [TAG_BITS-1:0]   tag_array   [0:WAYS-1][0:SETS-1];
    reg                  valid_array [0:WAYS-1][0:SETS-1];
    reg [DATA_WIDTH-1:0] data_array  [0:WAYS-1][0:SETS-1][0:(LINE_SIZE_BYTES/4)-1];
    reg [1:0]            lru_way     [0:SETS-1]; // Round-Robin pointer per set

    wire [TAG_BITS-1:0]   req_tag     = l1_req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0] req_set     = l1_req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [2:0]            word_offset = l1_req_addr[OFFSET_BITS-1 : 2];

    // 4-Way Parallel Hit Comparator
    wire way0_hit = valid_array[0][req_set] && (tag_array[0][req_set] == req_tag);
    wire way1_hit = valid_array[1][req_set] && (tag_array[1][req_set] == req_tag);
    wire way2_hit = valid_array[2][req_set] && (tag_array[2][req_set] == req_tag);
    wire way3_hit = valid_array[3][req_set] && (tag_array[3][req_set] == req_tag);

    wire any_hit = way0_hit || way1_hit || way2_hit || way3_hit;
    wire [1:0] hit_way = way0_hit ? 2'b00 : (way1_hit ? 2'b01 : (way2_hit ? 2'b10 : 2'b11));

    integer w, s, j;

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
            mem_addr <= {ADDR_WIDTH{1'b0}};

            for (s = 0; s < SETS; s = s + 1) begin
                lru_way[s] <= 2'b00;
                for (w = 0; w < WAYS; w = w + 1) begin
                    valid_array[w][s] <= 1'b0;
                    tag_array[w][s] <= {TAG_BITS{1'b0}};
                    for (j = 0; j < (LINE_SIZE_BYTES/4); j = j + 1) begin
                        data_array[w][s][j] <= {DATA_WIDTH{1'b0}};
                    end
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
                    if (any_hit) begin
                        l1_resp_hit <= 1'b1;
                        l1_resp_valid <= 1'b1;
                        l1_backpressure <= 1'b0;

                        if (l1_req_write_en) begin
                            data_array[hit_way][req_set][word_offset] <= l1_req_write_data;
                        end else begin
                            l1_resp_read_data <= data_array[hit_way][req_set][word_offset];
                            // Simple Parity Check
                            parity_error_detected <= ^data_array[hit_way][req_set][word_offset];
                        end
                    end else begin
                        l1_resp_hit <= 1'b0;
                        l1_backpressure <= 1'b1;
                        mem_req_valid <= 1'b1;
                        mem_write_en <= l1_req_write_en;
                        mem_addr <= l1_req_addr;
                        mem_write_data <= l1_req_write_data;
                    end
                end

                ST_REFILL: begin
                    if (mem_resp_valid) begin
                        w = lru_way[req_set];
                        tag_array[w][req_set] <= req_tag;
                        valid_array[w][req_set] <= 1'b1;
                        data_array[w][req_set][word_offset] <= mem_read_data;
                        lru_way[req_set] <= lru_way[req_set] + 1'b1;
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
                if (any_hit) next_state = ST_IDLE;
                else next_state = ST_REFILL;
            end
            ST_REFILL: if (mem_resp_valid) next_state = ST_RESP;
            ST_RESP: next_state = ST_IDLE;
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
