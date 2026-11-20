// =========================================================================
// GARUDA SEMESTA — 16KB LOW-LATENCY SCRATCHPAD SRAM MODULE (v12.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 16 KB Low-Latency Scratchpad Memory:
// - Single-Cycle Synchronous Read / Write Access
// - 4-Byte Byte Enables for Byte / Half-Word / Word Access
// =========================================================================

`timescale 1ns / 1ps

module garuda_scratchpad_mem #(
    parameter MEM_SIZE_BYTES = 16384,
    parameter ADDR_WIDTH     = 32,
    parameter DATA_WIDTH     = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] write_data,
    input  wire [3:0]            byte_enable,
    input  wire                  write_en,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] read_data,
    output reg                   resp_valid
);

    localparam NUM_WORDS = MEM_SIZE_BYTES / 4; // 4096 32-bit words
    localparam ADDR_BITS = 12;

    reg [31:0] sram [0:NUM_WORDS-1];
    wire [ADDR_BITS-1:0] word_addr = addr[ADDR_BITS+1:2];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 32'h0;
            resp_valid <= 1'b0;
            for (i = 0; i < NUM_WORDS; i = i + 1) begin
                sram[i] <= 32'h0;
            end
        end else begin
            resp_valid <= req_valid;
            if (req_valid) begin
                if (write_en) begin
                    if (byte_enable[0]) sram[word_addr][7:0]   <= write_data[7:0];
                    if (byte_enable[1]) sram[word_addr][15:8]  <= write_data[15:8];
                    if (byte_enable[2]) sram[word_addr][23:16] <= write_data[23:16];
                    if (byte_enable[3]) sram[word_addr][31:24] <= write_data[31:24];
                end
                read_data <= sram[word_addr];
            end
        end
    end

endmodule
