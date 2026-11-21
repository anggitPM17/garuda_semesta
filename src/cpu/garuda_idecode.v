// =========================================================================
// GARUDA SEMESTA — MODULAR CPU INSTRUCTION DECODER (v12.4.6)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Instruction Decoder:
// - Decodes 64-bit GARUDA ISA Instruction Word Format:
//   [63:60] Opcode (4 bits)
//   [59:55] RS1 (5 bits)
//   [54:50] RS2 (5 bits)
//   [42:38] RD (5 bits)
//   [31:0]  Immediate (32 bits)
// - Generates Control Signals for ALU, LSU, Branch, and Register File
// - Explicit alu_src_imm signal to resolve Immediate vs Register Operand B
// =========================================================================

`timescale 1ns / 1ps

module garuda_idecode (
    input  wire [63:0] inst_word,

    // Decoded Instruction Fields
    output wire [3:0]  opcode,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [31:0] imm_data,
    output wire [11:0] inst_addr,
    output wire [10:0] inst_size,

    // Generated Control Signals
    output reg  [3:0]  alu_op,
    output reg         alu_src_imm, // 1 = Immediate, 0 = Register (RS2)
    output reg         reg_write_en,
    output reg         mem_read_en,
    output reg         mem_write_en,
    output reg         branch_op,
    output reg         jump_op,
    output reg         illegal_inst
);

    assign opcode    = inst_word[63:60];
    assign rs1       = inst_word[59:55];
    assign rs2       = inst_word[54:50];
    assign rd        = inst_word[42:38];
    assign inst_addr = inst_word[54:43];
    assign inst_size = inst_word[42:32];
    assign imm_data  = inst_word[31:0];

    // Opcode Definitions
    localparam OP_NOP   = 4'h0;
    localparam OP_ADD   = 4'h1;
    localparam OP_SUB   = 4'h2;
    localparam OP_LOAD  = 4'h3;
    localparam OP_STORE = 4'h4;
    localparam OP_BEQ   = 4'h5;
    localparam OP_JMP   = 4'h6;
    localparam OP_MUL   = 4'h7;
    localparam OP_AND   = 4'h8;
    localparam OP_OR    = 4'h9;
    localparam OP_XOR   = 4'hA;
    localparam OP_HALT  = 4'hF;

    always @(*) begin
        alu_op       = 4'h0;
        alu_src_imm  = 1'b0;
        reg_write_en = 1'b0;
        mem_read_en  = 1'b0;
        mem_write_en = 1'b0;
        branch_op    = 1'b0;
        jump_op      = 1'b0;
        illegal_inst = 1'b0;

        case (opcode)
            OP_NOP: begin
                // No Operation
            end
            OP_ADD: begin
                alu_op       = 4'h1; // ADD
                reg_write_en = 1'b1;
                // If RS2 is r0 (0), use immediate. Else use RS2.
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_SUB: begin
                alu_op       = 4'h2; // SUB
                reg_write_en = 1'b1;
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_LOAD: begin
                alu_op       = 4'h1; // Address calc (ADD)
                alu_src_imm  = 1'b1; // Load uses Immediate offset
                mem_read_en  = 1'b1;
                reg_write_en = 1'b1;
            end
            OP_STORE: begin
                alu_op       = 4'h1; // Address calc (ADD)
                alu_src_imm  = 1'b1; // Store uses Immediate offset
                mem_write_en = 1'b1;
            end
            OP_BEQ: begin
                alu_op       = 4'h2; // SUB for comparison
                alu_src_imm  = 1'b0; // BEQ compares RS1 and RS2
                branch_op    = 1'b1;
            end
            OP_JMP: begin
                jump_op = 1'b1;
            end
            OP_MUL: begin
                alu_op       = 4'h7; // MUL
                reg_write_en = 1'b1;
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_AND: begin
                alu_op       = 4'h8; // AND
                reg_write_en = 1'b1;
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_OR: begin
                alu_op       = 4'h9; // OR
                reg_write_en = 1'b1;
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_XOR: begin
                alu_op       = 4'hA; // XOR
                reg_write_en = 1'b1;
                alu_src_imm  = (rs2 == 5'd0);
            end
            OP_HALT: begin
                // Halt handled by Control Unit
            end
            default: begin
                illegal_inst = 1'b1;
            end
        endcase
    end

endmodule
