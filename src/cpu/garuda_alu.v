// =========================================================================
// GARUDA SEMESTA — MODULAR CPU ALITHMETIC LOGIC UNIT (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 64-bit Arithmetic Logic Unit (ALU):
// - ADD, SUB, MUL, AND, OR, XOR, SHL, SHR, CMP Operations
// - Generates Zero Flag, Sign Flag, and Overflow Flag
// =========================================================================

`timescale 1ns / 1ps

module garuda_alu #(
    parameter DATA_WIDTH = 64
)(
    input  wire [3:0]            alu_op,
    input  wire [DATA_WIDTH-1:0] operand_a,
    input  wire [DATA_WIDTH-1:0] operand_b,
    output reg  [DATA_WIDTH-1:0] result,
    output wire                  zero_flag,
    output wire                  sign_flag
);

    localparam ALU_NOP  = 4'h0;
    localparam ALU_ADD  = 4'h1;
    localparam ALU_SUB  = 4'h2;
    localparam ALU_SHL  = 4'h3;
    localparam ALU_SHR  = 4'h4;
    localparam ALU_CMP  = 4'h5;
    localparam ALU_MUL  = 4'h7;
    localparam ALU_AND  = 4'h8;
    localparam ALU_OR   = 4'h9;
    localparam ALU_XOR  = 4'hA;

    assign zero_flag = (result == {DATA_WIDTH{1'b0}});
    assign sign_flag = result[DATA_WIDTH-1];

    always @(*) begin
        case (alu_op)
            ALU_ADD: result = operand_a + operand_b;
            ALU_SUB: result = operand_a - operand_b;
            ALU_SHL: result = operand_a << operand_b[5:0];
            ALU_SHR: result = operand_a >> operand_b[5:0];
            ALU_CMP: result = (operand_a == operand_b) ? 64'd1 : 64'd0;
            ALU_MUL: result = operand_a * operand_b;
            ALU_AND: result = operand_a & operand_b;
            ALU_OR:  result = operand_a | operand_b;
            ALU_XOR: result = operand_a ^ operand_b;
            default: result = {DATA_WIDTH{1'b0}};
        endcase
    end

endmodule
