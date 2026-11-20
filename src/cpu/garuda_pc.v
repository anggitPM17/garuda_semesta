// =========================================================================
// GARUDA SEMESTA — MODULAR CPU PROGRAM COUNTER (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Program Counter (PC) Unit:
// - 32-bit / 64-bit Instruction Address Pointer
// - Supports PC Increment (+8 bytes for 64-bit GARUDA ISA words)
// - Supports Branch/Jump Target Override & Pipeline Stall
// =========================================================================

`timescale 1ns / 1ps

module garuda_pc #(
    parameter PC_WIDTH = 32,
    parameter RESET_VECTOR = 32'h8000_0000
)(
    input  wire                clk,
    input  wire                rst_n,
    input  wire                stall,
    input  wire                branch_taken,
    input  wire [PC_WIDTH-1:0] branch_target,
    input  wire                exception_taken,
    input  wire [PC_WIDTH-1:0] exception_vector,
    output reg  [PC_WIDTH-1:0] pc
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= RESET_VECTOR;
        end else if (exception_taken) begin
            pc <= exception_vector;
        end else if (branch_taken) begin
            pc <= branch_target;
        end else if (!stall) begin
            pc <= pc + 32'd8; // 64-bit (8-byte) instruction word stride
        end
    end

endmodule
