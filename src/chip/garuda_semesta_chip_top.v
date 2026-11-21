// =========================================================================
// GARUDA SEMESTA — CHIP SYSTEM-ON-CHIP TOP-LEVEL MODULE (v0.3.3)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable GARUDA SEMESTA Chip System-on-Chip Entry Point:
// - Integrates 5-Stage CPU Core Pipeline (garuda_cpu_pipeline_top) with IRQ Line
// - Integrates Memory Subsystem Top (garuda_memory_subsystem_top)
// - Integrates Active System Interconnect & MMIO MUX (garuda_chip_interconnect)
// - Integrates Active MMIO Interrupt Controller (garuda_interrupt_controller)
// - Integrates Active MMIO Timer Peripheral (garuda_timer)
// - Integrates Active MMIO UART Serial Engine (garuda_uart)
// - Integrates Main SRAM Controller (garuda_memory_controller)
// =========================================================================

`timescale 1ns / 1ps

module garuda_semesta_chip_top #(
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

    // External Peripherals Interface
    output wire                  uart_tx,
    input  wire                  uart_rx,
    input  wire [7:0]            external_irq_inputs,

    // Status Signals
    output wire [ADDR_WIDTH-1:0] current_pc,
    output wire                  pipeline_halted,
    output wire                  illegal_instruction,
    output wire                  chip_irq_to_cpu,
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

    // Memory Subsystem Wires
    wire [31:0] sram_dcache_read_val;
    wire        sram_dcache_valid;
    wire        sram_dcache_stall;

    // MMIO Interconnect Wires
    wire [31:0] mmio_read_data;
    wire        mmio_resp_valid;
    wire [ADDR_WIDTH-1:0] intc_addr, timer_addr, uart_addr;
    wire [31:0]           intc_wdata, timer_wdata, uart_wdata;
    wire                  intc_wen, timer_wen, uart_wen;
    wire                  intc_req, timer_req, uart_req;
    wire [31:0]           intc_rdata, timer_rdata, uart_rdata;
    wire                  intc_rvalid, timer_rvalid, uart_rvalid;

    // Address Decoding: SRAM >= 0x8000_0000, MMIO < 0x8000_0000
    wire is_mmio_addr = (dcache_addr < 32'h8000_0000);

    // Muxing MMIO Read Data & Valid Response back into CPU D-Cache Interface
    assign dcache_read_val[31:0]  = is_mmio_addr ? mmio_read_data : sram_dcache_read_val;
    assign dcache_read_val[63:32] = 32'd0;
    assign dcache_valid           = is_mmio_addr ? mmio_resp_valid : sram_dcache_valid;
    assign dcache_stall           = is_mmio_addr ? 1'b0 : sram_dcache_stall;

    // 1. Modular 5-Stage CPU Pipeline Core
    garuda_cpu_pipeline_top #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32)
    ) u_cpu (
        .clk(clk),
        .rst_n(rst_n),
        .irq_req(chip_irq_to_cpu),
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

    // 2. Memory Subsystem Top (SRAM Transactions >= 0x8000_0000)
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
        .cpu_data_req_valid(dcache_req_valid && !is_mmio_addr),
        .cpu_data_read_val(sram_dcache_read_val),
        .cpu_data_hit(sram_dcache_valid),
        .cpu_data_valid(sram_dcache_valid),
        .cpu_data_stall(sram_dcache_stall),
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

    assign ext_dma_read_val[63:32] = 32'd0;

    // 3. Active Interconnect Routing & Address Decoder (MMIO Transactions < 0x8000_0000)
    garuda_chip_interconnect #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_interconnect (
        .clk(clk),
        .rst_n(rst_n),
        .m_addr(dcache_addr),
        .m_write_data(dcache_write_val[31:0]),
        .m_byte_enable(dcache_byte_en),
        .m_write_en(dcache_write_en),
        .m_req_valid(dcache_req_valid && is_mmio_addr),
        .m_read_data(mmio_read_data),
        .m_resp_valid(mmio_resp_valid),

        // SRAM Slave (handled via memory subsystem top)
        .s0_addr(),
        .s0_write_data(),
        .s0_byte_enable(),
        .s0_write_en(),
        .s0_req_valid(),
        .s0_read_data(32'd0),
        .s0_resp_valid(1'b0),

        // Interrupt Controller Slave (0x4000_1000)
        .s1_addr(intc_addr),
        .s1_write_data(intc_wdata),
        .s1_write_en(intc_wen),
        .s1_req_valid(intc_req),
        .s1_read_data(intc_rdata),
        .s1_resp_valid(intc_rvalid),

        // Timer Slave (0x4000_2000)
        .s2_addr(timer_addr),
        .s2_write_data(timer_wdata),
        .s2_write_en(timer_wen),
        .s2_req_valid(timer_req),
        .s2_read_data(timer_rdata),
        .s2_resp_valid(timer_rvalid),

        // UART Slave (0x4000_3000)
        .s3_addr(uart_addr),
        .s3_write_data(uart_wdata),
        .s3_write_en(uart_wen),
        .s3_req_valid(uart_req),
        .s3_read_data(uart_rdata),
        .s3_resp_valid(uart_rvalid)
    );

    // 4. Interrupt Controller
    wire timer_irq_sig, uart_tx_irq_sig;
    wire [7:0] combined_irq_inputs = external_irq_inputs | {6'd0, uart_tx_irq_sig, timer_irq_sig};

    garuda_interrupt_controller #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_intc (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(intc_addr),
        .req_write_data(intc_wdata),
        .req_write_en(intc_wen),
        .req_valid(intc_req),
        .resp_read_data(intc_rdata),
        .resp_valid(intc_rvalid),
        .irq_inputs(combined_irq_inputs),
        .irq_to_cpu(chip_irq_to_cpu),
        .active_irq_vector()
    );

    // 5. Timer Peripheral
    garuda_timer #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_timer (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(timer_addr),
        .req_write_data(timer_wdata),
        .req_write_en(timer_wen),
        .req_valid(timer_req),
        .resp_read_data(timer_rdata),
        .resp_valid(timer_rvalid),
        .timer_irq(timer_irq_sig)
    );

    // 6. UART Peripheral
    garuda_uart #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_uart (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(uart_addr),
        .req_write_data(uart_wdata),
        .req_write_en(uart_wen),
        .req_valid(uart_req),
        .resp_read_data(uart_rdata),
        .resp_valid(uart_rvalid),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .uart_tx_irq(uart_tx_irq_sig)
    );

endmodule
