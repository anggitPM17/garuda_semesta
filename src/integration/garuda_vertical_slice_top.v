// =========================================================================
// GARUDA SEMESTA — VERTICAL SLICE TOP-LEVEL MODULE (v12.5.0-64BITFIX)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Vertical Slice Top-Level:
// - Integrates 5-Stage CPU Pipeline Core (garuda_cpu_pipeline_top)
// - Integrates Memory Subsystem Top with 64-bit Instruction Word Interface
// - Integrates L1 Instruction Cache, L1 Data Cache, L2 Cache, and SRAM Controller
// =========================================================================

`timescale 1ns / 1ps

module garuda_vertical_slice_top #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // External DMA Master Interface (Secondary Bus Master)
    input  wire [ADDR_WIDTH-1:0] ext_dma_addr,
    input  wire [DATA_WIDTH-1:0] ext_dma_write_val,
    input  wire [3:0]            ext_dma_byte_en,
    input  wire                  ext_dma_write_en,
    input  wire                  ext_dma_req_valid,
    output wire [DATA_WIDTH-1:0] ext_dma_read_val,
    output wire                  ext_dma_grant,
    output wire                  ext_dma_resp_valid,

    // Status Signals
    output wire [ADDR_WIDTH-1:0] current_pc,
    output wire                  pipeline_halted,
    output wire                  illegal_instruction,
    output wire                  parity_error_detected
);

    // CPU Wires
    wire [ADDR_WIDTH-1:0] icache_addr;
    wire                  icache_req_valid;
    wire [63:0]           icache_inst_data;
    wire                  icache_valid;
    wire                  icache_stall;

    wire [ADDR_WIDTH-1:0] dcache_addr;
    wire [DATA_WIDTH-1:0] dcache_write_val;
    wire [3:0]            dcache_byte_en;
    wire                  dcache_write_en;
    wire                  dcache_req_valid;
    wire [DATA_WIDTH-1:0] dcache_read_val;
    wire                  dcache_valid;
    wire                  dcache_stall;

    // 1. Modular 5-Stage CPU Pipeline Core
    garuda_cpu_pipeline_top #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32)
    ) u_cpu (
        .clk(clk),
        .rst_n(rst_n),
        .irq_req(1'b0),
        .icache_addr(icache_addr),
        .icache_req_valid(icache_req_valid),
        .icache_inst_data(icache_inst_data),
        .icache_valid(icache_valid),
        .icache_stall(icache_stall),
        .dcache_addr(dcache_addr),
        .dcache_write_val(dcache_write_val),
        .dcache_byte_en(dcache_byte_en),
        .dcache_write_en(dcache_write_en),
        .dcache_req_valid(dcache_req_valid),
        .dcache_read_val(dcache_read_val),
        .dcache_valid(dcache_valid),
        .dcache_stall(dcache_stall),
        .current_pc(current_pc),
        .pipeline_halted(pipeline_halted),
        .illegal_instruction(illegal_instruction)
    );

    // 2. Memory Subsystem Top
    garuda_memory_subsystem_top #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_memory_subsystem (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_inst_addr(icache_addr),
        .cpu_inst_req_valid(icache_req_valid),
        .cpu_inst_data(icache_inst_data),
        .cpu_inst_hit(icache_valid),
        .cpu_inst_valid(icache_valid),
        .cpu_inst_stall(icache_stall),
        .cpu_data_addr(dcache_addr),
        .cpu_data_write_val(dcache_write_val[31:0]),
        .cpu_data_byte_en(dcache_byte_en),
        .cpu_data_write_en(dcache_write_en),
        .cpu_data_req_valid(dcache_req_valid),
        .cpu_data_read_val(dcache_read_val[31:0]),
        .cpu_data_hit(dcache_valid),
        .cpu_data_valid(dcache_valid),
        .cpu_data_stall(dcache_stall),
        .gpu_dma_addr(ext_dma_addr),
        .gpu_dma_write_val(ext_dma_write_val[31:0]),
        .gpu_dma_byte_en(ext_dma_byte_en),
        .gpu_dma_write_en(ext_dma_write_en),
        .gpu_dma_req_valid(ext_dma_req_valid),
        .gpu_dma_read_val(ext_dma_read_val[31:0]),
        .gpu_dma_grant(ext_dma_grant),
        .gpu_dma_resp_valid(ext_dma_resp_valid),
        .flush_all_caches(1'b0),
        .invalidate_all_caches(1'b0),
        .subsystem_parity_error(parity_error_detected)
    );

    assign dcache_read_val[63:32] = 32'd0;
    assign ext_dma_read_val[63:32] = 32'd0;

endmodule
