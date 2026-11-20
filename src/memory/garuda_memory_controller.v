// =========================================================================
// GARUDA SEMESTA — MAIN MEMORY CONTROLLER & SRAM BACKEND (v12.3.2-R2)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Main Memory Controller with SRAM Behavioral Model:
// - Address Bounds Decoder (Base: 0x8000_0000, Size: 65,536 bytes, End: 0x8001_0000)
// - Out-of-bounds addresses (< 0x8000_0000 OR >= 0x8001_0000) trigger resp_error = 1
// - Configurable Wait States, Response Valid, Error Response
// - Reset Recovery & Transaction Handshake
// =========================================================================

`timescale 1ns / 1ps

module garuda_memory_controller #(
    parameter MEM_SIZE_BYTES = 65536, // 64 KB Main SRAM
    parameter ADDR_WIDTH     = 32,
    parameter DATA_WIDTH     = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Interface from Arbiter / Cache
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_write_data,
    input  wire [3:0]            req_byte_enable,
    input  wire                  req_write_en,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] resp_read_data,
    output reg                   resp_valid,
    output reg                   resp_error
);

    localparam NUM_WORDS = MEM_SIZE_BYTES / 4; // 16384 words
    localparam ADDR_BITS = 14;

    reg [31:0] main_sram [0:NUM_WORDS-1];
    wire [ADDR_BITS-1:0] word_addr = req_addr[ADDR_BITS+1:2];

    // Address Bounds Validation: Base 0x8000_0000 to End-Exclusive 0x8001_0000
    wire addr_valid = (req_addr >= 32'h8000_0000) && (req_addr < 32'h8000_0000 + MEM_SIZE_BYTES);

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            resp_read_data <= 32'h0;
            resp_valid <= 1'b0;
            resp_error <= 1'b0;
            for (i = 0; i < NUM_WORDS; i = i + 1) begin
                main_sram[i] <= 32'h0;
            end
        end else begin
            resp_valid <= 1'b0;
            resp_error <= 1'b0;

            if (req_valid) begin
                if (!addr_valid) begin
                    // Out-of-bounds address error response (< 0x8000_0000 OR >= 0x8001_0000)
                    resp_error <= 1'b1;
                    resp_valid <= 1'b1;
                end else begin
                    resp_valid <= 1'b1;
                    if (req_write_en) begin
                        if (req_byte_enable[0]) main_sram[word_addr][7:0]   <= req_write_data[7:0];
                        if (req_byte_enable[1]) main_sram[word_addr][15:8]  <= req_write_data[15:8];
                        if (req_byte_enable[2]) main_sram[word_addr][23:16] <= req_write_data[23:16];
                        if (req_byte_enable[3]) main_sram[word_addr][31:24] <= req_write_data[31:24];
                    end
                    resp_read_data <= main_sram[word_addr];
                end
            end
        end
    end

endmodule
