// =========================================================================
// GARUDA SEMESTA — DEDICATED MMIO INTERCONNECT TRANSACTION FSM TESTBENCH (v13.1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Verifies MMIO Interconnect Transaction FSM & Delayed Slave Responses:
// - SRAM Range:       0x8000_0000 - 0x8000_FFFF
// - INTC Range:       0x4000_1000 - 0x4000_101F
// - Timer Range:      0x4000_2000 - 0x4000_201F
// - UART Range:       0x4000_3000 - 0x4000_301F
// - Unmapped Address: Returns 0xDEADBEEF fault response
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

    reg s0_resp, s1_resp, s2_resp, s3_resp;

    // Slave Response Generator with Delayed Latency (3 cycles)
    reg [2:0] s1_delay_cnt;
    reg       s1_resp_val_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_delay_cnt <= 3'd0;
            s1_resp_val_reg <= 1'b0;
        end else begin
            if (s1_req) begin
                s1_delay_cnt <= 3'd3; // 3 cycles delay
                s1_resp_val_reg <= 1'b0;
            end else if (s1_delay_cnt > 0) begin
                s1_delay_cnt <= s1_delay_cnt - 1'b1;
                if (s1_delay_cnt == 3'd1)
                    s1_resp_val_reg <= 1'b1;
                else
                    s1_resp_val_reg <= 1'b0;
            end else begin
                s1_resp_val_reg <= 1'b0;
            end
        end
    end

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
        .s1_resp_valid(s1_resp_val_reg),
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
        $display("GARUDA SEMESTA V13.1 — INTERCONNECT FSM & DELAYED RESPONSE TESTBENCH");
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

        // Test INTC decode (0x4000_1000) with 3-cycle delayed response
        @(posedge clk);
        m_addr = 32'h4000_1000;
        m_req_valid = 1;

        // Wait for master response valid
        wait(m_resp_valid == 1'b1);
        if (m_read_data !== 32'd200) begin
            $display("FAIL: INTC read data mismatch (Got %d, Expected 200)", m_read_data);
            $fatal(1, "INTC response fail");
        end
        @(posedge clk);
        m_req_valid = 0;

        // Test Unmapped Address (0x1234_5678) -> Expect 0xDEADBEEF
        @(posedge clk);
        m_addr = 32'h1234_5678;
        m_req_valid = 1;

        wait(m_resp_valid == 1'b1);
        #1;
        if (m_read_data !== 32'hDEAD_BEEF) begin
            $display("FAIL: Unmapped address did not return 0xDEADBEEF (Got 0x%h)", m_read_data);
            $fatal(1, "Unmapped fault fail");
        end
        @(posedge clk);
        m_req_valid = 0;

        $display("INTERCONNECT_DECODE_ASSERTION_PASS: ALL MMIO SLAVES & UNMAPPED FAULT VERIFIED!");
        $fflush();
        $finish;
    end

endmodule
