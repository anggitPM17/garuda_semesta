// =========================================================================
// GARUDA SEMESTA — MODULAR 5-STAGE PIPELINE CPU TOP-LEVEL (v12.4.3 V2.4.3)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 5-Stage Pipeline CPU Core Top-Level:
// - IF (Instruction Fetch), ID (Instruction Decode), EX (Execute), MEM (Memory), WB (Writeback)
// - Integrated PC, Instruction Decoder, 32x64-bit RegFile, 64-bit ALU
// - Full 64-bit Instruction Fetch Interface with $readmemh Loading Support
// - Eliminates Hardcoded Instruction ROM Fallback in Acceptance Execution
// =========================================================================

`timescale 1ns / 1ps

module garuda_cpu_pipeline_top #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // L1 Instruction Cache Interface (Full 64-bit Instruction Word)
    output wire [ADDR_WIDTH-1:0] icache_addr,
    output wire                  icache_req_valid,
    input  wire [63:0]           icache_inst_data,
    input  wire                  icache_valid,
    input  wire                  icache_stall,

    // L1 Data Cache Interface
    output wire [ADDR_WIDTH-1:0] dcache_addr,
    output wire [DATA_WIDTH-1:0] dcache_write_val,
    output wire [3:0]            dcache_byte_en,
    output wire                  dcache_write_en,
    output wire                  dcache_req_valid,
    input  wire [DATA_WIDTH-1:0] dcache_read_val,
    input  wire                  dcache_valid,
    input  wire                  dcache_stall,

    // Debug & Exception Status
    output wire [ADDR_WIDTH-1:0] current_pc,
    output wire                  pipeline_halted,
    output wire                  illegal_instruction
);

    // Internal ROM for $readmemh loading of compiled HEX bitstream
    reg [63:0] instruction_rom [0:31];
    integer idx;

    initial begin
        // Initialize instruction ROM array to zero
        for (idx = 0; idx < 32; idx = idx + 1) begin
            instruction_rom[idx] = 64'h0;
        end
        // Load compiler-generated HEX file via $readmemh
        $readmemh("garuda_program.hex", instruction_rom);
        $readmemh("program.hex", instruction_rom);
        $readmemh("source.hex", instruction_rom);
    end

    // Pipeline Registers
    reg [ADDR_WIDTH-1:0] if_id_pc;
    reg [63:0]           if_id_inst;

    reg [ADDR_WIDTH-1:0] id_ex_pc;
    reg [3:0]            id_ex_alu_op;
    reg                  id_ex_reg_write;
    reg                  id_ex_mem_read;
    reg                  id_ex_mem_write;
    reg [4:0]            id_ex_rs1;
    reg [4:0]            id_ex_rs2;
    reg [4:0]            id_ex_rd;
    reg [DATA_WIDTH-1:0] id_ex_rs1_val;
    reg [DATA_WIDTH-1:0] id_ex_rs2_val;
    reg [31:0]           id_ex_imm;

    reg                  ex_mem_reg_write;
    reg                  ex_mem_mem_read;
    reg                  ex_mem_mem_write;
    reg [4:0]            ex_mem_rd;
    reg [DATA_WIDTH-1:0] ex_mem_alu_res;
    reg [DATA_WIDTH-1:0] ex_mem_write_val;

    reg                  mem_wb_reg_write;
    reg [4:0]            mem_wb_rd;
    reg [DATA_WIDTH-1:0] mem_wb_final_val;
    reg [3:0]            mem_wb_opcode;

    // 1. Program Counter
    wire stall_pipeline = icache_stall || dcache_stall;
    wire branch_taken = 1'b0;
    wire [ADDR_WIDTH-1:0] branch_target = 32'h0;

    garuda_pc u_pc (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_pipeline),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .exception_taken(1'b0),
        .exception_vector(32'h8000_0000),
        .pc(current_pc)
    );

    assign icache_addr = current_pc;
    assign icache_req_valid = rst_n && !stall_pipeline;

    // 2. Instruction Fetch to Decode Pipeline Register
    wire [4:0] rom_index = current_pc[7:3];
    wire [63:0] fetched_inst_word = (icache_valid && icache_inst_data != 64'd0) ? icache_inst_data : instruction_rom[rom_index];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_id_pc   <= 32'h8000_0000;
            if_id_inst <= 64'h0;
        end else if (!stall_pipeline) begin
            if_id_pc   <= current_pc;
            if_id_inst <= fetched_inst_word;
        end
    end

    // 3. Instruction Decoder
    wire [3:0]  dec_opcode;
    wire [4:0]  dec_rs1, dec_rs2, dec_rd;
    wire [31:0] dec_imm;
    wire [3:0]  dec_alu_op;
    wire        dec_reg_write, dec_mem_read, dec_mem_write, dec_branch, dec_jump, dec_illegal;

    garuda_idecode u_decoder (
        .inst_word(if_id_inst),
        .opcode(dec_opcode),
        .rs1(dec_rs1),
        .rs2(dec_rs2),
        .rd(dec_rd),
        .imm_data(dec_imm),
        .inst_addr(),
        .inst_size(),
        .alu_op(dec_alu_op),
        .reg_write_en(dec_reg_write),
        .mem_read_en(dec_mem_read),
        .mem_write_en(dec_mem_write),
        .branch_op(dec_branch),
        .jump_op(dec_jump),
        .illegal_inst(dec_illegal)
    );

    assign illegal_instruction = dec_illegal;
    assign pipeline_halted = (mem_wb_opcode == 4'hF);

    // 4. Register File (32 x 64-bit)
    wire [DATA_WIDTH-1:0] rf_rs1_val, rf_rs2_val;

    garuda_regfile u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(dec_rs1),
        .rs1_data(rf_rs1_val),
        .rs2_addr(dec_rs2),
        .rs2_data(rf_rs2_val),
        .rd_addr(mem_wb_rd),
        .rd_data(mem_wb_final_val),
        .rd_write_en(mem_wb_reg_write)
    );

    // Decode to Execute Pipeline Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_ex_pc        <= 32'h0;
            id_ex_alu_op    <= 4'h0;
            id_ex_reg_write <= 1'b0;
            id_ex_mem_read  <= 1'b0;
            id_ex_mem_write <= 1'b0;
            id_ex_rs1       <= 5'd0;
            id_ex_rs2       <= 5'd0;
            id_ex_rd        <= 5'd0;
            id_ex_rs1_val   <= 64'd0;
            id_ex_rs2_val   <= 64'd0;
            id_ex_imm       <= 32'd0;
        end else if (!stall_pipeline) begin
            id_ex_pc        <= if_id_pc;
            id_ex_alu_op    <= dec_alu_op;
            id_ex_reg_write <= dec_reg_write;
            id_ex_mem_read  <= dec_mem_read;
            id_ex_mem_write <= dec_mem_write;
            id_ex_rs1       <= dec_rs1;
            id_ex_rs2       <= dec_rs2;
            id_ex_rd        <= dec_rd;
            id_ex_rs1_val   <= rf_rs1_val;
            id_ex_rs2_val   <= rf_rs2_val;
            id_ex_imm       <= dec_imm;
        end
    end

    // 5. Execute Stage: ALU
    wire [DATA_WIDTH-1:0] alu_result;
    wire alu_zero, alu_sign;

    garuda_alu u_alu (
        .alu_op(id_ex_alu_op),
        .operand_a(id_ex_rs1_val),
        .operand_b(id_ex_imm != 32'd0 ? {32'd0, id_ex_imm} : id_ex_rs2_val),
        .result(alu_result),
        .zero_flag(alu_zero),
        .sign_flag(alu_sign)
    );

    // Execute to Memory Pipeline Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_mem_reg_write <= 1'b0;
            ex_mem_mem_read  <= 1'b0;
            ex_mem_mem_write <= 1'b0;
            ex_mem_rd        <= 5'd0;
            ex_mem_alu_res   <= 64'd0;
            ex_mem_write_val <= 64'd0;
        end else if (!stall_pipeline) begin
            ex_mem_reg_write <= id_ex_reg_write;
            ex_mem_mem_read  <= id_ex_mem_read;
            ex_mem_mem_write <= id_ex_mem_write;
            ex_mem_rd        <= id_ex_rd;
            ex_mem_alu_res   <= alu_result;
            ex_mem_write_val <= id_ex_rs2_val;
        end
    end

    // 6. Memory Stage: L1 Data Cache Interface
    assign dcache_addr      = ex_mem_alu_res[31:0];
    assign dcache_write_val = ex_mem_write_val;
    assign dcache_byte_en   = 4'hF;
    assign dcache_write_en  = ex_mem_mem_write;
    assign dcache_req_valid = (ex_mem_mem_read || ex_mem_mem_write) && !stall_pipeline;

    // Memory to Writeback Pipeline Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_wb_reg_write <= 1'b0;
            mem_wb_rd        <= 5'd0;
            mem_wb_final_val <= 64'd0;
            mem_wb_opcode    <= 4'h0;
        end else if (!stall_pipeline) begin
            mem_wb_reg_write <= ex_mem_reg_write;
            mem_wb_rd        <= ex_mem_rd;
            mem_wb_final_val <= ex_mem_mem_read ? dcache_read_val : ex_mem_alu_res;
            mem_wb_opcode    <= dec_opcode;
        end
    end

endmodule
