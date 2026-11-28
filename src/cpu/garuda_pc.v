// =========================================================================
// GARUDA SEMESTA — MODULAR CPU PROGRAM COUNTER (v12.5.0-XSAFE)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Program Counter (PC) Unit:
// - 32-bit / 64-bit Instruction Address Pointer
// - Supports PC Increment (+8 bytes for 64-bit GARUDA ISA words)
// - Supports Branch/Jump Target Override & Pipeline Stall
// - Strict X-safe pc_next gating to prevent X propagation to pc_reg
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
    output wire [PC_WIDTH-1:0] pc
);

    reg [PC_WIDTH-1:0] pc_reg;

    initial begin
        pc_reg = RESET_VECTOR;
    end

    assign pc = pc_reg;

    wire branch_taken_safe    = (rst_n === 1'b1) && (branch_taken === 1'b1) && (^branch_target !== 1'bx);
    wire exception_taken_safe = (rst_n === 1'b1) && (exception_taken === 1'b1) && (^exception_vector !== 1'bx);
    wire stall_safe           = (stall === 1'b1);

    wire [PC_WIDTH-1:0] pc_next = !rst_n ? RESET_VECTOR :
                                  exception_taken_safe ? exception_vector :
                                  branch_taken_safe ? branch_target :
                                  !stall_safe ? (pc_reg + 32'd8) : pc_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_reg <= RESET_VECTOR;
        end else begin
            pc_reg <= pc_next;
        end
    end

    always @(posedge clk) begin
        if (rst_n) begin
            $display("[PC_RAW] rst_n=%b stall=%b pc_next=%h pc_reg=%h", rst_n, stall, pc_next, pc_reg);
            $fflush();
        end
    end

endmodule
