// =========================================================================
// GARUDA SEMESTA — UNIFIED MEMORY SUBSYSTEM TOP-LEVEL (v12.3.2-R2)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Top-Level Memory Subsystem:
// - L1 Instruction Cache (4KB, 64-bit Instruction Words)
// - L1 Data Cache (4KB, 32-bit Data Bus) & L2 Unified Cache (32KB 4-Way)
// - Low-Latency 16KB Scratchpad SRAM
// - Multi-Master Memory Arbiter (CPU & GPU Masters)
// - Main Memory Controller with 64KB SRAM Backend (Base: 0x80000000)
// =========================================================================

`timescale 1ns / 1ps

module garuda_memory_subsystem_top #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // CPU Instruction Fetch Interface (Master 0) - Full 64-bit Instruction Bus
    input  wire [ADDR_WIDTH-1:0] cpu_inst_addr,
    input  wire                  cpu_inst_req_valid,
    output wire [63:0]           cpu_inst_data,
    output wire                  cpu_inst_hit,
    output wire                  cpu_inst_valid,
    output wire                  cpu_inst_stall,

    // CPU Data Load/Store Interface (Master 1)
    input  wire [ADDR_WIDTH-1:0] cpu_data_addr,
    input  wire [DATA_WIDTH-1:0] cpu_data_write_val,
    input  wire [3:0]            cpu_data_byte_en,
    input  wire                  cpu_data_write_en,
    input  wire                  cpu_data_req_valid,
    output wire [DATA_WIDTH-1:0] cpu_data_read_val,
    output wire                  cpu_data_hit,
    output wire                  cpu_data_valid,
    output wire                  cpu_data_stall,

    // GPU / DMA Master Interface (Master 2)
    input  wire [ADDR_WIDTH-1:0] gpu_dma_addr,
    input  wire [DATA_WIDTH-1:0] gpu_dma_write_val,
    input  wire [3:0]            gpu_dma_byte_en,
    input  wire                  gpu_dma_write_en,
    input  wire                  gpu_dma_req_valid,
    output wire [DATA_WIDTH-1:0] gpu_dma_read_val,
    output wire                  gpu_dma_grant,
    output wire                  gpu_dma_resp_valid,

    // Subsystem Management Signals
    input  wire                  flush_all_caches,
    input  wire                  invalidate_all_caches,
    output wire                  subsystem_parity_error
);

    // Internal Wires for Interconnect
    wire [ADDR_WIDTH-1:0] icache_mem_addr;
    wire                  icache_mem_valid;
    wire [63:0]           icache_mem_data;
    wire                  icache_mem_resp_valid;

    wire [ADDR_WIDTH-1:0] dcache_mem_addr;
    wire [DATA_WIDTH-1:0] dcache_mem_write_data;
    wire                  dcache_mem_write_en;
    wire                  dcache_mem_valid;
    wire [DATA_WIDTH-1:0] dcache_mem_read_data;
    wire                  dcache_mem_resp_valid;

    wire [ADDR_WIDTH-1:0] l2_mem_addr;
    wire [DATA_WIDTH-1:0] l2_mem_write_data;
    wire                  l2_mem_write_en;
    wire                  l2_mem_req_valid;
    wire [DATA_WIDTH-1:0] l2_mem_read_data;
    wire                  l2_mem_resp_valid;

    // 1. Instantiate L1 4KB Instruction Cache (Full 64-bit Data Bus)
    garuda_l1_icache #(
        .CACHE_SIZE_BYTES(4096),
        .LINE_SIZE_BYTES(32),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(64)
    ) u_icache (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(cpu_inst_addr),
        .req_valid(cpu_inst_req_valid),
        .resp_data(cpu_inst_data),
        .resp_hit(cpu_inst_hit),
        .resp_valid(cpu_inst_valid),
        .stall(cpu_inst_stall),
        .flush(flush_all_caches),
        .invalidate(invalidate_all_caches),
        .mem_req_addr(icache_mem_addr),
        .mem_req_valid(icache_mem_valid),
        .mem_resp_data({32'd0, l2_mem_read_data}),
        .mem_resp_valid(icache_mem_resp_valid)
    );

    // 2. Instantiate L1 4KB Data Cache
    garuda_l1_dcache #(
        .CACHE_SIZE_BYTES(4096),
        .LINE_SIZE_BYTES(32),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_dcache (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(cpu_data_addr),
        .req_write_data(cpu_data_write_val),
        .req_byte_enable(cpu_data_byte_en),
        .req_write_en(cpu_data_write_en),
        .req_valid(cpu_data_req_valid),
        .resp_read_data(cpu_data_read_val),
        .resp_hit(cpu_data_hit),
        .resp_valid(cpu_data_valid),
        .stall(cpu_data_stall),
        .flush(flush_all_caches),
        .invalidate(invalidate_all_caches),
        .mem_addr(dcache_mem_addr),
        .mem_write_data(dcache_mem_write_data),
        .mem_write_en(dcache_mem_write_en),
        .mem_req_valid(dcache_mem_valid),
        .mem_read_data(l2_mem_read_data),
        .mem_resp_valid(dcache_mem_resp_valid)
    );

    // 3. Instantiate L2 32KB Cache
    garuda_l2_cache #(
        .CACHE_SIZE_BYTES(32768),
        .WAYS(4),
        .LINE_SIZE_BYTES(32),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_l2_cache (
        .clk(clk),
        .rst_n(rst_n),
        .l1_req_addr(dcache_mem_addr),
        .l1_req_write_data(dcache_mem_write_data),
        .l1_req_write_en(dcache_mem_write_en),
        .l1_req_valid(dcache_mem_valid),
        .l1_resp_read_data(l2_mem_read_data),
        .l1_resp_hit(),
        .l1_resp_valid(dcache_mem_resp_valid),
        .l1_backpressure(),
        .parity_error_detected(subsystem_parity_error),
        .mem_addr(l2_mem_addr),
        .mem_write_data(l2_mem_write_data),
        .mem_write_en(l2_mem_write_en),
        .mem_req_valid(l2_mem_req_valid),
        .mem_read_data(gpu_dma_read_val),
        .mem_resp_valid(gpu_dma_resp_valid)
    );

    // 4. Instantiate Multi-Master Arbiter (L2 / CPU & GPU Masters)
    wire [ADDR_WIDTH-1:0] arb_target_addr;
    wire [DATA_WIDTH-1:0] arb_target_write_data;
    wire [3:0]            arb_target_byte_en;
    wire                  arb_target_write_en;
    wire                  arb_target_req_valid;
    wire [DATA_WIDTH-1:0] arb_target_read_data;
    wire                  arb_target_resp_valid;

    garuda_memory_arbiter #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_arbiter (
        .clk(clk),
        .rst_n(rst_n),
        .m0_addr(l2_mem_addr),
        .m0_write_data(l2_mem_write_data),
        .m0_byte_enable(4'hF),
        .m0_write_en(l2_mem_write_en),
        .m0_req_valid(l2_mem_req_valid),
        .m0_read_data(),
        .m0_grant(),
        .m0_resp_valid(),
        .m1_addr(gpu_dma_addr),
        .m1_write_data(gpu_dma_write_val),
        .m1_byte_enable(gpu_dma_byte_en),
        .m1_write_en(gpu_dma_write_en),
        .m1_req_valid(gpu_dma_req_valid),
        .m1_read_data(gpu_dma_read_val),
        .m1_grant(gpu_dma_grant),
        .m1_resp_valid(gpu_dma_resp_valid),
        .target_addr(arb_target_addr),
        .target_write_data(arb_target_write_data),
        .target_byte_enable(arb_target_byte_en),
        .target_write_en(arb_target_write_en),
        .target_req_valid(arb_target_req_valid),
        .target_read_data(arb_target_read_data),
        .target_resp_valid(arb_target_resp_valid)
    );

    // 5. Instantiate Main Memory Controller (64KB SRAM Backend)
    garuda_memory_controller #(
        .MEM_SIZE_BYTES(65536),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_mem_controller (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(arb_target_addr),
        .req_write_data(arb_target_write_data),
        .req_byte_enable(arb_target_byte_en),
        .req_write_en(arb_target_write_en),
        .req_valid(arb_target_req_valid),
        .resp_read_data(arb_target_read_data),
        .resp_valid(arb_target_resp_valid),
        .resp_error()
    );

endmodule
