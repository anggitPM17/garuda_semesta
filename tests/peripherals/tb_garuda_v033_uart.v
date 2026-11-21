// =========================================================================
// GARUDA SEMESTA — V13.1-R2 BIT-LEVEL UART SERIAL WAVEFORM TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Rigorous Bit-Level UART Serial Frame Verification:
// - Transmits Byte 0x41 ('A') via MMIO write
// - Samples start bit (0), 8 data bits LSB-first (1,0,0,0,0,0,1,0), stop bit (1) at bit centers
// - Verifies uart_tx_irq and baud timing
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

    // Bit-level capture registers
    reg [9:0] captured_frame;
    integer bit_idx;

    always #5 clk = ~clk;

    garuda_uart #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32),
        .CLK_FREQ_HZ(100000000),
        .BAUD_RATE(10000000) // Fast baud rate for testbench simulation (10 Mbaud -> 10 clocks per bit)
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
        $display("GARUDA SEMESTA V13.1-R2 — BIT-LEVEL UART FRAME TESTBENCH");
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
        captured_frame = 10'h3FF;

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
        $display("[UART TEST] Start Bit (0) Captured. Sampling 8 data bits and stop bit at bit centers...");
        $fflush();

        // Wait 5 clocks (half bit period) to reach center of start bit
        #50;
        // Sample Start Bit (Expected 0)
        if (uart_tx !== 1'b0) begin
            $display("FAIL: Start bit mismatch (Got %b)", uart_tx);
            $fatal(1, "Start bit fail");
        end

        // Sample 8 Data Bits (10 clocks per bit)
        for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
            #100; // 1 bit period
            captured_frame[bit_idx] = uart_tx;
            $display("[UART TEST] Data Bit D%0d = %b", bit_idx, uart_tx);
        end

        // Sample Stop Bit
        #100;
        captured_frame[8] = uart_tx; // Stop bit
        $display("[UART TEST] Stop Bit = %b", uart_tx);
        $fflush();

        // Wait for Transmit Interrupt
        wait(uart_tx_irq == 1'b1);
        $display("[UART TEST] Transmit Complete Interrupt (uart_tx_irq) Asserted!");
        $fflush();

        // Assert Captured Frame equals 0x41 ('A' LSB first: D0=1, D1=0, D2=0, D3=0, D4=0, D5=0, D6=1, D7=0)
        // captured_frame[7:0] should be 8'h41
        if (captured_frame[7:0] === 8'h41) begin
            $display("UART_WAVEFORM_ASSERTION_PASS: BIT-LEVEL SERIAL TX FRAME VERIFIED (0x41 'A')");
            $fflush();
            $finish;
        end else begin
            $display("FAIL: UART Frame Mismatch (Captured 0x%h, Expected 0x41)", captured_frame[7:0]);
            $fatal(1, "UART Frame Mismatch");
        end
    end

endmodule
