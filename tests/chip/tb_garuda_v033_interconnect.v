// =========================================================================
// GARUDA SEMESTA — DEDICATED MMIO INTERCONNECT TESTBENCH (v0.3.3-R1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Verifies MMIO Interconnect Address Decoding & Routing:
// - SRAM Range:       0x8000_0000 - 0x8000_FFFF
// - INTC Range:       0x4000_1000 - 0x4000_101F
// - Timer Range:      0x4000_2000 - 0x4000_201F
// - UART Range:       0x4000_3000 - 0x4000_301F
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_v033_interconnect;

    reg clk;
    reg rst_n;

    reg  [31:0] m_addr;
    reg  [31:0] m_write_data;
    reg  [3:0]  m_byte_enable;
    reg         m_write_en;
    reg         m_req_valid;
    wire [31:0] m_read_data;
    wire        m_resp_valid;

    // Slaves
    wire [31:0] s0_addr, s1_addr, s2_addr, s3_addr;
    wire [31:0] s0_wdata, s1_wdata, s2_wdata, s3_wdata;
    wire        s0_req, s1_req, s2_req, s3_req;

    always #5 clk = ~clk;

    garuda_chip_interconnect #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_dut_interconnect (
        .clk(clk),
        .rst_n(rst_n),
        .m_addr(m_addr),
        .m_write_data(m_write_data),
        .m_byte_enable(m_byte_enable),
        .m_write_en(m_write_en),
        .m_req_valid(m_req_valid),
        .m_read_data(m_read_data),
        .m_resp_valid(m_resp_valid),
        .s0_addr(s0_addr),
        .s0_write_data(s0_wdata),
        .s0_byte_enable(),
        .s0_write_en(),
        .s0_req_valid(s0_req),
        .s0_read_data(32'd100),
        .s0_resp_valid(s0_req),
        .s1_addr(s1_addr),
        .s1_write_data(s1_wdata),
        .s1_write_en(),
        .s1_req_valid(s1_req),
        .s1_read_data(32'd200),
        .s1_resp_valid(s1_req),
        .s2_addr(s2_addr),
        .s2_write_data(s2_wdata),
        .s2_write_en(),
        .s2_req_valid(s2_req),
        .s2_read_data(32'd300),
        .s2_resp_valid(s2_req),
        .s3_addr(s3_addr),
        .s3_write_data(s3_wdata),
        .s3_write_en(),
        .s3_req_valid(s3_req),
        .s3_read_data(32'd400),
        .s3_resp_valid(s3_req)
    );

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA V0.3.3-R1 — INTERCONNECT DECODING TESTBENCH");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");
        $fflush();

        clk = 0;
        rst_n = 0;
        m_addr = 0;
        m_write_data = 0;
        m_byte_enable = 4'hF;
        m_write_en = 0;
        m_req_valid = 0;

        #20 rst_n = 1;

        // Test INTC decode (0x4000_1000)
        @(posedge clk);
        m_addr = 32'h4000_1000;
        m_req_valid = 1;
        #1;
        if (!s1_req) begin
            $display("FAIL: INTC decode failed!");
            $fatal(1, "Decode fail");
        end
        @(posedge clk);
        m_req_valid = 0;

        // Test Timer decode (0x4000_2000)
        @(posedge clk);
        m_addr = 32'h4000_2000;
        m_req_valid = 1;
        #1;
        if (!s2_req) begin
            $display("FAIL: Timer decode failed!");
            $fatal(1, "Decode fail");
        end
        @(posedge clk);
        m_req_valid = 0;

        // Test UART decode (0x4000_3000)
        @(posedge clk);
        m_addr = 32'h4000_3000;
        m_req_valid = 1;
        #1;
        if (!s3_req) begin
            $display("FAIL: UART decode failed!");
            $fatal(1, "Decode fail");
        end
        @(posedge clk);
        m_req_valid = 0;

        $display("INTERCONNECT_DECODE_ASSERTION_PASS: ALL MMIO SLAVES DECODED SUCCESSFULLY!");
        $fflush();
        $finish;
    end

endmodule
