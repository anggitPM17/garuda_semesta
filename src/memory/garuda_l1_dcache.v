// =========================================================================
// GARUDA SEMESTA — L1 4KB DATA CACHE MODULE (v12.4.6)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 4 KB L1 Data Cache:
// - 32-bit Address, 32-bit Data Bus, 4-bit Byte Enable
// - Direct-Mapped / Write-Through to guarantee SRAM consistency
// =========================================================================

`timescale 1ns / 1ps

module garuda_l1_dcache #(
    parameter CACHE_SIZE_BYTES = 4096,
    parameter LINE_SIZE_BYTES  = 32,
    parameter ADDR_WIDTH       = 32,
    parameter DATA_WIDTH       = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Core Interface
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_write_data,
    input  wire [3:0]            req_byte_enable,
    input  wire                  req_write_en,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] resp_read_data,
    output reg                   resp_hit,
    output reg                   resp_valid,
    output reg                   stall,

    // Management
    input  wire                  flush,
    input  wire                  invalidate,

    // Memory Controller / L2 Interconnect
    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_write_data,
    output reg                   mem_write_en,
    output reg                   mem_req_valid,
    input  wire                  mem_backpressure,
    input  wire [DATA_WIDTH-1:0] mem_read_data,
    input  wire                  mem_resp_valid
);

    localparam NUM_LINES   = CACHE_SIZE_BYTES / LINE_SIZE_BYTES; // 128
    localparam OFFSET_BITS  = 5;  // 32 bytes
    localparam INDEX_BITS   = 7;  // 128 lines
    localparam TAG_BITS     = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS; // 20 bits

    // FSM States
    localparam ST_IDLE         = 3'b000;
    localparam ST_COMPARE      = 3'b001;
    localparam ST_REFILL       = 3'b011;
    localparam ST_WRITE_THRU   = 3'b100;
    localparam ST_RESP         = 3'b101;

    reg [2:0] state, next_state;

    // Cache Arrays
    reg [TAG_BITS-1:0]  tag_array   [0:NUM_LINES-1];
    reg                 valid_array [0:NUM_LINES-1];
    reg [DATA_WIDTH-1:0] data_array  [0:NUM_LINES-1][0:(LINE_SIZE_BYTES/4)-1];

    wire [TAG_BITS-1:0]   req_tag     = req_addr[ADDR_WIDTH-1 : INDEX_BITS+OFFSET_BITS];
    wire [INDEX_BITS-1:0] req_index   = req_addr[INDEX_BITS+OFFSET_BITS-1 : OFFSET_BITS];
    wire [2:0]            word_offset = req_addr[OFFSET_BITS-1 : 2];

    wire hit = valid_array[req_index] && (tag_array[req_index] == req_tag);

    // Combinational memory address and data assignment
    assign mem_addr       = (req_write_en) ? req_addr : {req_addr[ADDR_WIDTH-1:OFFSET_BITS], {OFFSET_BITS{1'b0}}};
    assign mem_write_data = req_write_data;

    integer i, j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            stall <= 1'b0;
            resp_hit <= 1'b0;
            resp_valid <= 1'b0;
            resp_read_data <= {DATA_WIDTH{1'b0}};
            mem_req_valid <= 1'b0;
            mem_write_en <= 1'b0;

            for (i = 0; i < NUM_LINES; i = i + 1) begin
                valid_array[i] <= 1'b0;
                tag_array[i] <= {TAG_BITS{1'b0}};
                for (j = 0; j < (LINE_SIZE_BYTES/4); j = j + 1) begin
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
                    if (req_valid) stall <= 1'b1;
                end

                ST_COMPARE: begin
                    if (hit && !req_write_en) begin
                        resp_hit <= 1'b1;
                        resp_valid <= 1'b1;
                        resp_read_data <= data_array[req_index][word_offset];
                        stall <= 1'b0;
                    end else begin
                        resp_hit <= hit;
                        stall <= 1'b1;
                        mem_req_valid <= 1'b1;
                        mem_write_en <= req_write_en;
                        if (req_write_en && hit) begin
                            if (req_byte_enable[0]) data_array[req_index][word_offset][7:0]   <= req_write_data[7:0];
                            if (req_byte_enable[1]) data_array[req_index][word_offset][15:8]  <= req_write_data[15:8];
                            if (req_byte_enable[2]) data_array[req_index][word_offset][23:16] <= req_write_data[23:16];
                            if (req_byte_enable[3]) data_array[req_index][word_offset][31:24] <= req_write_data[31:24];
                        end
                    end
                end

                ST_WRITE_THRU: begin
                    if (mem_resp_valid) begin
                        mem_req_valid <= 1'b0;
                        mem_write_en <= 1'b0;
                    end
                end

                ST_REFILL: begin
                    if (mem_resp_valid) begin
                        tag_array[req_index] <= req_tag;
                        valid_array[req_index] <= 1'b1;
                        data_array[req_index][word_offset] <= mem_read_data;
                        mem_req_valid <= 1'b0;
                    end
                end

                ST_RESP: begin
                    resp_hit <= 1'b1;
                    resp_valid <= 1'b1;
                    resp_read_data <= (req_write_en) ? req_write_data : data_array[req_index][word_offset];
                    stall <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: if (req_valid) next_state = ST_COMPARE;
            ST_COMPARE: begin
                if (hit && !req_write_en) next_state = ST_IDLE;
                else if (req_write_en) next_state = ST_WRITE_THRU;
                else next_state = ST_REFILL;
            end
            ST_WRITE_THRU: if (mem_resp_valid) next_state = ST_RESP;
            ST_REFILL: if (mem_resp_valid) next_state = ST_RESP;
            ST_RESP: next_state = ST_IDLE;
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
