// =========================================================================
// GARUDA SEMESTA — L2 CACHE SUBSYSTEM (v12.8.1-RESPDATA-FIX)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// FIX v12.8.1:
//  - ST_RESP assigns l1_resp_read_data from data_array[way][set][latched_word_offset]
//    instead of last refilled word (mem_read_data), fixing word readout truncation
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

    input  wire [ADDR_WIDTH-1:0] l1_req_addr,
    input  wire [DATA_WIDTH-1:0] l1_req_write_data,
    input  wire                  l1_req_write_en,
    input  wire                  l1_req_valid,
    output reg  [DATA_WIDTH-1:0] l1_resp_read_data,
    output reg                   l1_resp_hit,
    output reg                   l1_resp_valid,
    output reg                   l1_backpressure,

    output reg                   parity_error_detected,

    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_write_data,
    output reg                   mem_write_en,
    output reg                   mem_req_valid,
    input  wire [DATA_WIDTH-1:0] mem_read_data,
    input  wire                  mem_resp_valid,

    // Debug Probe Outputs
    output wire                  dbg_any_hit,
    output wire                  dbg_valid0,
    output wire [DATA_WIDTH-1:0] dbg_data0
);

    localparam SETS           = CACHE_SIZE_BYTES / (WAYS * LINE_SIZE_BYTES); // 16 sets
    localparam OFFSET_BITS    = 5;
    localparam INDEX_BITS     = 4;
    localparam TAG_BITS       = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 23 bits
    localparam WORDS_PER_LINE = LINE_SIZE_BYTES / 4; // 8 words

    localparam ST_IDLE    = 2'b00;
    localparam ST_COMPARE = 2'b01;
    localparam ST_REFILL  = 2'b10;
    localparam ST_RESP    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] refill_word_cnt;
    reg [INDEX_BITS-1:0] latched_set;
    reg [2:0] latched_word_offset;
    reg [TAG_BITS-1:0] latched_tag;
    reg [ADDR_WIDTH-1:0] latched_line_base;

    reg [TAG_BITS-1:0]          tag_array   [0:WAYS-1][0:SETS-1];
    reg [WORDS_PER_LINE-1:0]    valid_array [0:WAYS-1][0:SETS-1];
    reg [DATA_WIDTH-1:0]        data_array  [0:WAYS-1][0:SETS-1][0:WORDS_PER_LINE-1];
    reg [1:0]                   lru_way     [0:SETS-1];

    wire [TAG_BITS-1:0]   req_tag     = l1_req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0] req_set     = l1_req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [2:0]            word_offset = l1_req_addr[OFFSET_BITS-1 : 2];

    wire way0_hit = (valid_array[0][req_set][word_offset] == 1'b1) && (tag_array[0][req_set] == req_tag);
    wire way1_hit = (valid_array[1][req_set][word_offset] == 1'b1) && (tag_array[1][req_set] == req_tag);
    wire way2_hit = (valid_array[2][req_set][word_offset] == 1'b1) && (tag_array[2][req_set] == req_tag);
    wire way3_hit = (valid_array[3][req_set][word_offset] == 1'b1) && (tag_array[3][req_set] == req_tag);

    wire any_hit = way0_hit || way1_hit || way2_hit || way3_hit;
    wire [1:0] hit_way = way0_hit ? 2'b00 : (way1_hit ? 2'b01 : (way2_hit ? 2'b10 : 2'b11));

    // Debug Outputs
    assign dbg_any_hit = any_hit;
    assign dbg_valid0  = valid_array[0][0][0];
    assign dbg_data0   = data_array[0][0][0];

    // Alamat memori: gunakan base line saat refill, atau alamat asli saat bypass
    assign mem_addr       = (state == ST_REFILL) ? (latched_line_base + (refill_word_cnt * 4)) : l1_req_addr;
    assign mem_write_data = l1_req_write_data;

    integer w, s, k;

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
            refill_word_cnt <= 3'b000;
            latched_line_base <= 32'h8000_0000;
            latched_set <= {INDEX_BITS{1'b0}};
            latched_word_offset <= 3'b000;
            latched_tag <= {TAG_BITS{1'b0}};

            for (s = 0; s < SETS; s = s + 1) begin
                lru_way[s] <= 2'b00;
                for (w = 0; w < WAYS; w = w + 1) begin
                    tag_array[w][s] <= {TAG_BITS{1'b0}};
                    valid_array[w][s] <= {WORDS_PER_LINE{1'b0}};
                    for (k = 0; k < WORDS_PER_LINE; k = k + 1) begin
                        data_array[w][s][k] <= {DATA_WIDTH{1'b0}};
                    end
                end
            end
        end else begin
            state <= next_state;

            case (state)
                ST_IDLE: begin
                    l1_resp_valid <= 1'b0;
                    l1_backpressure <= 1'b0;
                    mem_req_valid <= 1'b0;
                    if (l1_req_valid) begin
                        latched_set         <= req_set;
                        latched_word_offset <= word_offset;
                        latched_tag         <= req_tag;
                        latched_line_base   <= {l1_req_addr[ADDR_WIDTH-1:OFFSET_BITS], {OFFSET_BITS{1'b0}}};
                    end
                end

                ST_COMPARE: begin
                    if (any_hit && !l1_req_write_en) begin
                        l1_resp_hit <= 1'b1;
                        l1_resp_valid <= 1'b1;
                        l1_backpressure <= 1'b0;
                        l1_resp_read_data <= data_array[hit_way][req_set][word_offset];
                        parity_error_detected <= ^data_array[hit_way][req_set][word_offset];
                        mem_req_valid <= 1'b0;
                    end else begin
                        l1_resp_hit <= any_hit;
                        l1_backpressure <= 1'b1;
                        mem_req_valid <= 1'b1;
                        mem_write_en <= l1_req_write_en;
                        refill_word_cnt <= 3'b000;

                        if (any_hit && l1_req_write_en) begin
                            data_array[hit_way][req_set][word_offset] <= l1_req_write_data;
                            valid_array[hit_way][req_set][word_offset] <= 1'b1;
                        end
                    end
                end

                ST_REFILL: begin
                    l1_backpressure <= 1'b1;
                    mem_req_valid <= 1'b1;

                    if (mem_resp_valid) begin
                        if (mem_write_en) begin
                            // Write-No-Allocate: Write passes through to main memory without updating L2 line
                            mem_req_valid <= 1'b0;
                        end else begin
                            data_array[lru_way[latched_set]][latched_set][refill_word_cnt] <= mem_read_data;
                            valid_array[lru_way[latched_set]][latched_set][refill_word_cnt] <= 1'b1;
                            if (refill_word_cnt == (WORDS_PER_LINE - 1)) begin
                                tag_array[lru_way[latched_set]][latched_set] <= latched_tag;
                                lru_way[latched_set] <= lru_way[latched_set] + 1'b1;
                                mem_req_valid <= 1'b0;
                            end else begin
                                refill_word_cnt <= refill_word_cnt + 1'b1;
                            end
                        end
                    end
                end

                ST_RESP: begin
                    l1_resp_hit <= 1'b1;
                    l1_resp_valid <= 1'b1;
                    l1_resp_read_data <= data_array[lru_way[latched_set] - 2'd1][latched_set][latched_word_offset];
                    l1_backpressure <= 1'b0;
                    mem_req_valid <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                if (l1_req_valid) next_state = ST_COMPARE;
            end
            ST_COMPARE: begin
                if (any_hit && !l1_req_write_en) next_state = ST_IDLE;
                else next_state = ST_REFILL;
            end
            ST_REFILL: begin
                if (mem_resp_valid && (mem_write_en || (refill_word_cnt == (WORDS_PER_LINE - 1)))) begin
                    next_state = ST_RESP;
                end
            end
            ST_RESP: next_state = ST_IDLE;
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
