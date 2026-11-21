// =========================================================================
// GARUDA SEMESTA — MODULAR 5-STAGE PIPELINE CPU TOP-LEVEL (v12.5.0-FIX)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 5-Stage Pipeline CPU Core Top-Level:
// - IF (Instruction Fetch), ID (Instruction Decode), EX (Execute), MEM (Memory), WB (Writeback)
// - Integrated PC, Instruction Decoder, 32x64-bit RegFile, 64-bit ALU
// - Load-Use Data Hazard stall, MEM-stage dcache_read_val forwarding, & Hardware IRQ
// - Precise BEQ Branch & JMP Execution with Pipeline Flush Engine
// - Registered icache_req_valid to break cross-module combinatorial loop with icache_stall
// =========================================================================

`timescale 1ns / 1ps

module garuda_cpu_pipeline_top #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Hardware Interrupt Request Line
    input  wire                  irq_req,

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

    // Pipeline Registers
    reg [ADDR_WIDTH-1:0] if_id_pc;
    reg [63:0]           if_id_inst;

    reg [ADDR_WIDTH-1:0] id_ex_pc;
    reg [3:0]            id_ex_opcode;
    reg [3:0]            id_ex_alu_op;
    reg                  id_ex_alu_src_imm;
    reg                  id_ex_reg_write;
    reg                  id_ex_mem_read;
    reg                  id_ex_mem_write;
    reg [4:0]            id_ex_rs1;
    reg [4:0]            id_ex_rs2;
    reg [4:0]            id_ex_rd;
    reg [DATA_WIDTH-1:0] id_ex_rs1_val;
    reg [DATA_WIDTH-1:0] id_ex_rs2_val;
    reg [31:0]           id_ex_imm;
    reg                  id_ex_illegal_inst;

    reg [3:0]            ex_mem_opcode;
    reg                  ex_mem_reg_write;
    reg                  ex_mem_mem_read;
    reg                  ex_mem_mem_write;
    reg [4:0]            ex_mem_rd;
    reg [DATA_WIDTH-1:0] ex_mem_alu_res;
    reg [DATA_WIDTH-1:0] ex_mem_write_val;
    reg                  ex_mem_illegal_inst;

    reg [3:0]            mem_wb_opcode;
    reg                  mem_wb_reg_write;
    reg [4:0]            mem_wb_rd;
    reg [DATA_WIDTH-1:0] mem_wb_final_val;
    reg                  mem_wb_illegal_inst;

    reg                  halt_retires_latched;
    reg                  halt_decoded_latched;
    reg                  dcache_done;
    reg                  irq_latched_reg;

    // Decoder
    wire [3:0]  dec_opcode;
    wire [4:0]  dec_rs1, dec_rs2, dec_rd;
    wire [31:0] dec_imm;
    wire [3:0]  dec_alu_op;
    wire        dec_alu_src_imm;
    wire        dec_reg_write, dec_mem_read, dec_mem_write, dec_branch, dec_jump, dec_illegal;

    // Load-Use Hazard Detection
    wire load_use_hazard = (id_ex_mem_read && (id_ex_rd == dec_rs1 || id_ex_rd == dec_rs2) && id_ex_rd != 5'd0);

    // ALU Signals
    wire [DATA_WIDTH-1:0] alu_result;
    wire alu_zero, alu_sign;

    // Branch & Jump Execution in EX Stage (Gated with rst_n to prevent X propagation)
    wire branch_equal_taken = rst_n && (id_ex_opcode == 4'h5) && alu_zero;
    wire jump_taken         = rst_n && (id_ex_opcode == 4'h6);
    wire branch_taken       = branch_equal_taken || jump_taken;
    wire [ADDR_WIDTH-1:0] branch_target = id_ex_pc + id_ex_imm[31:0];

    // 1. Program Counter & Pipeline Control Logic
    wire halted_sig = halt_retires_latched || (mem_wb_opcode == 4'hF);
    wire dec_halt_sig = halt_decoded_latched || (dec_opcode == 4'hF) || (id_ex_opcode == 4'hF) || (ex_mem_opcode == 4'hF) || halted_sig;

    wire stall_backend = dcache_stall || halted_sig;
    wire stall_pc = icache_stall || dcache_stall || load_use_hazard || dec_halt_sig;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            halt_retires_latched <= 1'b0;
            halt_decoded_latched <= 1'b0;
            dcache_done          <= 1'b0;
            irq_latched_reg      <= 1'b0;
        end else begin
            if (irq_req) begin
                irq_latched_reg <= 1'b1;
            end
            if (dec_opcode == 4'hF && !load_use_hazard && !dcache_stall) begin
                halt_decoded_latched <= 1'b1;
            end
            if (mem_wb_opcode == 4'hF) begin
                halt_retires_latched <= 1'b1;
            end

            if (!ex_mem_mem_read && !ex_mem_mem_write) begin
                dcache_done <= 1'b0;
            end else if (dcache_valid) begin
                dcache_done <= 1'b1;
            end
        end
    end

    // Program Counter Unit
    garuda_pc #(
        .PC_WIDTH(32),
        .RESET_VECTOR(32'h8000_0000)
    ) u_pc (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_pc),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .exception_taken(1'b0),
        .exception_vector(32'h8000_0000),
        .pc(current_pc)
    );

    assign icache_addr = current_pc;

    // Break combinational loop between icache_req_valid and icache_stall
    reg icache_req_valid_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            icache_req_valid_r <= 1'b0;
        end else begin
            icache_req_valid_r <= rst_n && !dcache_stall && !load_use_hazard && !dec_halt_sig;
        end
    end
    assign icache_req_valid = icache_req_valid_r;

    // 2. Instruction Fetch to Decode Pipeline Register (Flushes on Branch Taken)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_id_pc   <= 32'h8000_0000;
            if_id_inst <= 64'h0;
        end else if (branch_taken) begin
            if_id_pc   <= branch_target;
            if_id_inst <= 64'h0; // Flush to NOP
        end else if (!stall_pc && icache_valid) begin
            if_id_pc   <= current_pc;
            if_id_inst <= icache_inst_data;
        end
    end

    // 3. Instruction Decoder
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
        .alu_src_imm(dec_alu_src_imm),
        .reg_write_en(dec_reg_write),
        .mem_read_en(dec_mem_read),
        .mem_write_en(dec_mem_write),
        .branch_op(dec_branch),
        .jump_op(dec_jump),
        .illegal_inst(dec_illegal)
    );

    // 4. Register File (32 x 64-bit)
    wire [DATA_WIDTH-1:0] rf_rs1_val, rf_rs2_val;

    garuda_regfile #(
        .REG_WIDTH(64),
        .REG_COUNT(32)
    ) u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(dec_rs1),
        .rs2_addr(dec_rs2),
        .rd_addr(mem_wb_rd),
        .rd_data(mem_wb_final_val),
        .rd_write_en(mem_wb_reg_write),
        .rs1_data(rf_rs1_val),
        .rs2_data(rf_rs2_val)
    );

    // Forwarding logic
    wire [DATA_WIDTH-1:0] fwd_rs1_val = (ex_mem_reg_write && ex_mem_rd == dec_rs1 && dec_rs1 != 5'd0) ? ex_mem_alu_res :
                                        (mem_wb_reg_write && mem_wb_rd == dec_rs1 && dec_rs1 != 5'd0) ? mem_wb_final_val : rf_rs1_val;

    wire [DATA_WIDTH-1:0] fwd_rs2_val = (ex_mem_reg_write && ex_mem_rd == dec_rs2 && dec_rs2 != 5'd0) ? ex_mem_alu_res :
                                        (mem_wb_reg_write && mem_wb_rd == dec_rs2 && dec_rs2 != 5'd0) ? mem_wb_final_val : rf_rs2_val;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_ex_pc        <= 32'h8000_0000;
            id_ex_opcode    <= 4'h0;
            id_ex_alu_op    <= 4'h0;
            id_ex_alu_src_imm <= 1'b0;
            id_ex_reg_write <= 1'b0;
            id_ex_mem_read  <= 1'b0;
            id_ex_mem_write <= 1'b0;
            id_ex_rs1       <= 5'd0;
            id_ex_rs2       <= 5'd0;
            id_ex_rd        <= 5'd0;
            id_ex_rs1_val   <= 64'd0;
            id_ex_rs2_val   <= 64'd0;
            id_ex_imm       <= 32'd0;
            id_ex_illegal_inst <= 1'b0;
        end else if (!stall_backend) begin
            if (load_use_hazard || branch_taken) begin
                id_ex_pc        <= if_id_pc;
                id_ex_opcode    <= 4'h0;
                id_ex_alu_op    <= 4'h0;
                id_ex_alu_src_imm <= 1'b0;
                id_ex_reg_write <= 1'b0;
                id_ex_mem_read  <= 1'b0;
                id_ex_mem_write <= 1'b0;
                id_ex_rs1       <= 5'd0;
                id_ex_rs2       <= 5'd0;
                id_ex_rd        <= 5'd0;
                id_ex_rs1_val   <= 64'd0;
                id_ex_rs2_val   <= 64'd0;
                id_ex_imm       <= 32'd0;
                id_ex_illegal_inst <= 1'b0;
            end else begin
                id_ex_pc        <= if_id_pc;
                id_ex_opcode    <= dec_opcode;
                id_ex_alu_op    <= dec_alu_op;
                id_ex_alu_src_imm <= dec_alu_src_imm;
                id_ex_reg_write <= dec_reg_write;
                id_ex_mem_read  <= dec_mem_read;
                id_ex_mem_write <= dec_mem_write;
                id_ex_rs1       <= dec_rs1;
                id_ex_rs2       <= dec_rs2;
                id_ex_rd        <= dec_rd;
                id_ex_rs1_val   <= fwd_rs1_val;
                id_ex_rs2_val   <= fwd_rs2_val;
                id_ex_imm       <= dec_imm;
                id_ex_illegal_inst <= dec_illegal;
            end
        end
    end

    // 5. Execute Stage: ALU
    wire [DATA_WIDTH-1:0] alu_operand_b = id_ex_alu_src_imm ? {{32{id_ex_imm[31]}}, id_ex_imm} : id_ex_rs2_val;

    garuda_alu #(
        .DATA_WIDTH(64)
    ) u_alu (
        .operand_a(id_ex_rs1_val),
        .operand_b(alu_operand_b),
        .alu_op(id_ex_alu_op),
        .result(alu_result),
        .zero_flag(alu_zero),
        .sign_flag(alu_sign)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_mem_opcode    <= 4'h0;
            ex_mem_reg_write <= 1'b0;
            ex_mem_mem_read  <= 1'b0;
            ex_mem_mem_write <= 1'b0;
            ex_mem_rd        <= 5'd0;
            ex_mem_alu_res   <= 64'd0;
            ex_mem_write_val <= 64'd0;
            ex_mem_illegal_inst <= 1'b0;
        end else if (!stall_backend) begin
            ex_mem_opcode    <= id_ex_opcode;
            ex_mem_reg_write <= id_ex_reg_write;
            ex_mem_mem_read  <= id_ex_mem_read;
            ex_mem_mem_write <= id_ex_mem_write;
            ex_mem_rd        <= id_ex_rd;
            ex_mem_alu_res   <= alu_result;
            ex_mem_write_val <= id_ex_rs2_val;
            ex_mem_illegal_inst <= id_ex_illegal_inst;
        end
    end

    // 6. Memory Stage
    assign dcache_addr      = ex_mem_alu_res[ADDR_WIDTH-1:0];
    assign dcache_write_val = ex_mem_write_val;
    assign dcache_byte_en   = 4'hF;
    assign dcache_write_en  = ex_mem_mem_write;
    assign dcache_req_valid = (ex_mem_mem_read || ex_mem_mem_write) && !dcache_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_wb_opcode    <= 4'h0;
            mem_wb_reg_write <= 1'b0;
            mem_wb_rd        <= 5'd0;
            mem_wb_final_val <= 64'd0;
            mem_wb_illegal_inst <= 1'b0;
        end else if (!stall_backend) begin
            mem_wb_opcode    <= ex_mem_opcode;
            mem_wb_reg_write <= ex_mem_reg_write;
            mem_wb_rd        <= ex_mem_rd;
            mem_wb_final_val <= ex_mem_mem_read ? dcache_read_val : ex_mem_alu_res;
            mem_wb_illegal_inst <= ex_mem_illegal_inst;
        end
    end

    assign current_pc = u_pc.pc;
    assign pipeline_halted = halted_sig;
    assign illegal_instruction = mem_wb_illegal_inst;

endmodule
