// =========================================================================
// GARUDA SEMESTA — MODULAR CPU REGISTER FILE (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 32 x 64-bit Register File:
// - Register r0 is Hardwired Constant Zero (64'h0)
// - Dual Read Ports (rs1, rs2) & Single Write Port (rd)
// - Synchronous Write & Asynchronous / Transparent Read
// =========================================================================

`timescale 1ns / 1ps

module garuda_regfile #(
    parameter REG_WIDTH = 64,
    parameter REG_COUNT = 32
)(
    input  wire                 clk,
    input  wire                 rst_n,

    // Read Port 1
    input  wire [4:0]           rs1_addr,
    output wire [REG_WIDTH-1:0] rs1_data,

    // Read Port 2
    input  wire [4:0]           rs2_addr,
    output wire [REG_WIDTH-1:0] rs2_data,

    // Write Port
    input  wire [4:0]           rd_addr,
    input  wire [REG_WIDTH-1:0] rd_data,
    input  wire                 rd_write_en
);

    reg [REG_WIDTH-1:0] registers [0:REG_COUNT-1];

    // Read Logic (r0 is hardwired to 0)
    assign rs1_data = (rs1_addr == 5'd0) ? {REG_WIDTH{1'b0}} : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? {REG_WIDTH{1'b0}} : registers[rs2_addr];

    integer i;

    // Write Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < REG_COUNT; i = i + 1) begin
                registers[i] <= {REG_WIDTH{1'b0}};
            end
        end else if (rd_write_en && (rd_addr != 5'd0)) begin
            registers[rd_addr] <= rd_data;
        end
    end

endmodule
