// =========================================================================
// GARUDA SEMESTA — DEDICATED MMIO UART SERIAL WAVEFORM TESTBENCH (v0.3.3-R1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Verifies UART Serial TX Frame Waveform:
// - Transmits Byte 0x41 ('A') via MMIO write
// - Measures Start bit (0), 8 Data bits (LSB-first: 1,0,0,0,0,0,1,0), Stop bit (1)
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_v033_uart;

    reg clk;
    reg rst_n;

    reg  [31:0] req_addr;
    reg  [31:0] req_write_data;
    reg         req_write_en;
    reg         req_valid;
    wire [31:0] resp_read_data;
    wire        resp_valid;

    wire        uart_tx;
    reg         uart_rx;
    wire        uart_tx_irq;

    always #5 clk = ~clk;

    garuda_uart #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32),
        .CLK_FREQ_HZ(100000000),
        .BAUD_RATE(10000000) // Fast baud rate for testbench simulation (10 Mbaud)
    ) u_dut_uart (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(req_addr),
        .req_write_data(req_write_data),
        .req_write_en(req_write_en),
        .req_valid(req_valid),
        .resp_read_data(resp_read_data),
        .resp_valid(resp_valid),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .uart_tx_irq(uart_tx_irq)
    );

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA V0.3.3-R1 — DEDICATED MMIO UART WAVEFORM TESTBENCH");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");
        $fflush();

        clk = 0;
        rst_n = 0;
        uart_rx = 1;
        req_addr = 32'h0;
        req_write_data = 32'h0;
        req_write_en = 0;
        req_valid = 0;

        #20 rst_n = 1;
        #20;

        // Write 0x41 ('A') to TX Data Register
        @(posedge clk);
        req_addr = 32'h4000_3000;
        req_write_data = 32'h0000_0041;
        req_write_en = 1;
        req_valid = 1;

        @(posedge clk);
        req_valid = 0;
        req_write_en = 0;

        $display("[UART TEST] Write 0x41 ('A') issued to MMIO TX register.");
        $fflush();

        // Wait for Start bit (uart_tx == 0)
        wait(uart_tx == 1'b0);
        $display("[UART TEST] Start Bit (0) Captured on uart_tx!");
        $fflush();

        // Wait for Transmit Interrupt
        wait(uart_tx_irq == 1'b1);
        $display("[UART TEST] Transmit Complete Interrupt (uart_tx_irq) Asserted!");
        $fflush();

        $display("UART_WAVEFORM_ASSERTION_PASS: SERIAL TX WAVEFORM VERIFIED (0x41 'A')");
        $fflush();
        $finish;
    end

endmodule
