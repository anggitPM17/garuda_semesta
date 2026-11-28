// =========================================================================
// GARUDA SEMESTA — UNIFIED MEMORY SUBSYSTEM TOP-LEVEL (v12.4.6-R2)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Top-Level Memory Subsystem:
// - L1 Instruction Cache (4KB, 64-bit Instruction Words)
// - 64-to-32 Bit Bus Adapter for I-Cache Refill
// - L1 Data Cache (4KB, 32-bit Data Bus) & L2 Unified Cache (32KB 4-Way)
// - L1-to-L2 Locked Request Arbiter with L2 Backpressure Check
// - Multi-Master Memory Arbiter (L2 & GPU Masters)
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

    // ---------------------------------------------------------
    // Internal Wires
    // ---------------------------------------------------------

    // I-Cache to Adapter (64-bit)
    wire [ADDR_WIDTH-1:0] icache_mem_addr;
    wire                  icache_mem_valid;
    wire                  icache_mem_ready;
    wire [63:0]           icache_mem_data;
    wire                  icache_mem_resp_valid;
    wire                  icache_mem_resp_error;

    // Adapter to L1-to-L2 Arbiter (32-bit)
    wire [ADDR_WIDTH-1:0] adapter_l2_req_addr;
    wire                  adapter_l2_req_valid;
    wire                  adapter_l2_req_ready;
    wire [31:0]           adapter_l2_resp_data;
    wire                  adapter_l2_resp_valid;
    wire                  adapter_l2_resp_error;

    // D-Cache to L1-to-L2 Arbiter (32-bit)
    wire [ADDR_WIDTH-1:0] dcache_mem_addr;
    wire [DATA_WIDTH-1:0] dcache_mem_write_data;
    wire                  dcache_mem_write_en;
    wire                  dcache_mem_valid;
    wire                  dcache_mem_backpressure;
    wire [DATA_WIDTH-1:0] dcache_mem_read_data;
    wire                  dcache_mem_resp_valid;

    // ---------------------------------------------------------
    // 1. L1 Instruction Cache (64-bit)
    // ---------------------------------------------------------
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
        .mem_req_ready(icache_mem_ready),
        .mem_resp_data(icache_mem_data),
        .mem_resp_valid(icache_mem_resp_valid),
        .mem_resp_error(icache_mem_resp_error)
    );

    // ---------------------------------------------------------
    // 1b. 64-to-32 Bus Adapter for I-Cache Refill
    // ---------------------------------------------------------
    garuda_bus_adapter_64to32 u_icache_adapter (
        .clk(clk),
        .rst_n(rst_n),
        .m_req_addr(icache_mem_addr),
        .m_req_valid(icache_mem_valid),
        .m_req_ready(icache_mem_ready),
        .m_resp_data(icache_mem_data),
        .m_resp_valid(icache_mem_resp_valid),
        .m_resp_error(icache_mem_resp_error),
        .s_req_addr(adapter_l2_req_addr),
        .s_req_valid(adapter_l2_req_valid),
        .s_req_ready(adapter_l2_req_ready),
        .s_resp_data(adapter_l2_resp_data),
        .s_resp_valid(adapter_l2_resp_valid),
        .s_resp_error(adapter_l2_resp_error)
    );

    // ---------------------------------------------------------
    // 2. L1 Data Cache (32-bit)
    // ---------------------------------------------------------
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
        .mem_backpressure(dcache_mem_backpressure),
        .mem_read_data(dcache_mem_read_data),
        .mem_resp_valid(dcache_mem_resp_valid)
    );

    // ---------------------------------------------------------
    // 3. L1-to-L2 Locked Arbiter & Concurrency Multiplexer
    // ---------------------------------------------------------
    reg        l1_arb_busy;
    reg        l1_arb_active_master; // 0 for I-Cache/Adapter, 1 for D-Cache
    reg [31:0] latched_l2_req_addr;
    reg [31:0] latched_l2_req_write_data;
    reg        latched_l2_req_write_en;

    wire [31:0] l1_resp_read_data;
    wire        l1_resp_valid;
    wire        l2_backpressure;

    wire safe_dcache_valid  = rst_n && (dcache_mem_valid === 1'b1);
    wire safe_adapter_valid = rst_n && (adapter_l2_req_valid === 1'b1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            l1_arb_busy <= 1'b0;
            l1_arb_active_master <= 1'b0;
            latched_l2_req_addr <= 32'h8000_0000;
            latched_l2_req_write_data <= 32'd0;
            latched_l2_req_write_en <= 1'b0;
        end else begin
            if (!l1_arb_busy && !l2_backpressure) begin
                if (safe_dcache_valid) begin
                    l1_arb_busy <= 1'b1;
                    l1_arb_active_master <= 1'b1;
                    latched_l2_req_addr <= dcache_mem_addr;
                    latched_l2_req_write_data <= dcache_mem_write_data;
                    latched_l2_req_write_en <= dcache_mem_write_en;
                end else if (safe_adapter_valid) begin
                    l1_arb_busy <= 1'b1;
                    l1_arb_active_master <= 1'b0;
                    latched_l2_req_addr <= adapter_l2_req_addr;
                    latched_l2_req_write_data <= 32'd0;
                    latched_l2_req_write_en <= 1'b0;
                end
            end else if (l1_resp_valid) begin
                l1_arb_busy <= 1'b0;
            end
        end
    end

    wire [ADDR_WIDTH-1:0] l2_req_addr       = l1_arb_busy ? latched_l2_req_addr : (safe_dcache_valid ? dcache_mem_addr : adapter_l2_req_addr);
    wire [DATA_WIDTH-1:0] l2_req_write_data = l1_arb_busy ? latched_l2_req_write_data : dcache_mem_write_data;
    wire                  l2_req_write_en   = l1_arb_busy ? latched_l2_req_write_en : (safe_dcache_valid ? dcache_mem_write_en : 1'b0);
    wire                  l2_req_valid      = l1_arb_busy | safe_dcache_valid | safe_adapter_valid;

    assign dcache_mem_backpressure = l2_backpressure || (l1_arb_busy && l1_arb_active_master == 1'b0);
    assign adapter_l2_req_ready    = !l2_backpressure && (!l1_arb_busy || l1_arb_active_master == 1'b0);

    // Response Routing based on locked active master
    assign dcache_mem_resp_valid = l1_resp_valid & l1_arb_active_master;
    assign dcache_mem_read_data  = l1_resp_read_data;

    assign adapter_l2_resp_valid = l1_resp_valid & ~l1_arb_active_master;
    assign adapter_l2_resp_data  = l1_resp_read_data;
    assign adapter_l2_resp_error = 1'b0;

    // ---------------------------------------------------------
    // 4. L2 Unified Cache (32-bit)
    // ---------------------------------------------------------
    wire [ADDR_WIDTH-1:0] l2_mem_addr;
    wire [DATA_WIDTH-1:0] l2_mem_write_data;
    wire                  l2_mem_write_en;
    wire                  l2_mem_req_valid;
    wire [DATA_WIDTH-1:0] l2_mem_read_data;
    wire                  l2_mem_resp_valid;

    garuda_l2_cache #(
        .CACHE_SIZE_BYTES(2048),
        .WAYS(4),
        .LINE_SIZE_BYTES(32),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_l2_cache (
        .clk(clk),
        .rst_n(rst_n),
        .l1_req_addr(l2_req_addr),
        .l1_req_write_data(l2_req_write_data),
        .l1_req_write_en(l2_req_write_en),
        .l1_req_valid(l2_req_valid),
        .l1_resp_read_data(l1_resp_read_data),
        .l1_resp_hit(),
        .l1_resp_valid(l1_resp_valid),
        .l1_backpressure(l2_backpressure),
        .parity_error_detected(subsystem_parity_error),
        .mem_addr(l2_mem_addr),
        .mem_write_data(l2_mem_write_data),
        .mem_write_en(l2_mem_write_en),
        .mem_req_valid(l2_mem_req_valid),
        .mem_read_data(l2_mem_read_data),
        .mem_resp_valid(l2_mem_resp_valid)
    );

    // ---------------------------------------------------------
    // 5. Multi-Master Memory Arbiter (L2 / CPU & GPU Masters)
    // ---------------------------------------------------------
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
        // Master 0: L2 Cache
        .m0_addr(l2_mem_addr),
        .m0_write_data(l2_mem_write_data),
        .m0_byte_enable(4'hF),
        .m0_write_en(l2_mem_write_en),
        .m0_req_valid(l2_mem_req_valid),
        .m0_read_data(l2_mem_read_data),
        .m0_grant(),
        .m0_resp_valid(l2_mem_resp_valid),

        // Master 1: GPU / DMA
        .m1_addr(gpu_dma_addr),
        .m1_write_data(gpu_dma_write_val),
        .m1_byte_enable(gpu_dma_byte_en),
        .m1_write_en(gpu_dma_write_en),
        .m1_req_valid(gpu_dma_req_valid),
        .m1_read_data(gpu_dma_read_val),
        .m1_grant(gpu_dma_grant),
        .m1_resp_valid(gpu_dma_resp_valid),

        // Output to Memory Controller
        .target_addr(arb_target_addr),
        .target_write_data(arb_target_write_data),
        .target_byte_enable(arb_target_byte_en),
        .target_write_en(arb_target_write_en),
        .target_req_valid(arb_target_req_valid),
        .target_read_data(arb_target_read_data),
        .target_resp_valid(arb_target_resp_valid)
    );

    // ---------------------------------------------------------
    // 6. Main Memory Controller (64KB SRAM Backend)
    // ---------------------------------------------------------
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
