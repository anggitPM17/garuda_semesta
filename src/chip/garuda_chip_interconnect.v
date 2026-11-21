// =========================================================================
// GARUDA SEMESTA — CHIP SYSTEM INTERCONNECT & ADDRESS DECODER (v0.3.2)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Chip Interconnect & Address Decoder:
// Routes Master transactions (Memory Subsystem / Arbiter) to Slaves:
// - SRAM Main Memory:           0x8000_0000 - 0x8000_FFFF (64 KB)
// - Interrupt Controller MMIO:  0x4000_1000 - 0x4000_101F
// - Timer MMIO:                 0x4000_2000 - 0x4000_201F
// - UART MMIO:                  0x4000_3000 - 0x4000_301F
// - Unmapped Addresses: Returns 0xDEADBEEF fault response without SRAM access
// =========================================================================

`timescale 1ns / 1ps

module garuda_chip_interconnect #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Master Interface (From CPU / Memory Arbiter)
    input  wire [ADDR_WIDTH-1:0] m_addr,
    input  wire [DATA_WIDTH-1:0] m_write_data,
    input  wire [3:0]            m_byte_enable,
    input  wire                  m_write_en,
    input  wire                  m_req_valid,
    output reg  [DATA_WIDTH-1:0] m_read_data,
    output reg                   m_resp_valid,

    // Slave #0: Memory Controller / SRAM
    output reg  [ADDR_WIDTH-1:0] s0_addr,
    output reg  [DATA_WIDTH-1:0] s0_write_data,
    output reg  [3:0]            s0_byte_enable,
    output reg                   s0_write_en,
    output reg                   s0_req_valid,
    input  wire [DATA_WIDTH-1:0] s0_read_data,
    input  wire                  s0_resp_valid,

    // Slave #1: Interrupt Controller MMIO (0x4000_1000)
    output reg  [ADDR_WIDTH-1:0] s1_addr,
    output reg  [DATA_WIDTH-1:0] s1_write_data,
    output reg                   s1_write_en,
    output reg                   s1_req_valid,
    input  wire [DATA_WIDTH-1:0] s1_read_data,
    input  wire                  s1_resp_valid,

    // Slave #2: Timer MMIO (0x4000_2000)
    output reg  [ADDR_WIDTH-1:0] s2_addr,
    output reg  [DATA_WIDTH-1:0] s2_write_data,
    output reg                   s2_write_en,
    output reg                   s2_req_valid,
    input  wire [DATA_WIDTH-1:0] s2_read_data,
    input  wire                  s2_resp_valid,

    // Slave #3: UART MMIO (0x4000_3000)
    output reg  [ADDR_WIDTH-1:0] s3_addr,
    output reg  [DATA_WIDTH-1:0] s3_write_data,
    output reg                   s3_write_en,
    output reg                   s3_req_valid,
    input  wire [DATA_WIDTH-1:0] s3_read_data,
    input  wire                  s3_resp_valid
);

    // Address Decoding (Main SRAM capped to 64 KB 0x8000_0000 - 0x8000_FFFF)
    wire is_sram  = (m_addr >= 32'h8000_0000) && (m_addr <= 32'h8000_FFFF);
    wire is_intc  = (m_addr >= 32'h4000_1000) && (m_addr <= 32'h4000_101F);
    wire is_timer = (m_addr >= 32'h4000_2000) && (m_addr <= 32'h4000_201F);
    wire is_uart  = (m_addr >= 32'h4000_3000) && (m_addr <= 32'h4000_301F);
    wire is_unmapped = m_req_valid && !(is_sram || is_intc || is_timer || is_uart);

    reg [1:0] latched_active_slave;

    always @(*) begin
        s0_req_valid = 1'b0;
        s1_req_valid = 1'b0;
        s2_req_valid = 1'b0;
        s3_req_valid = 1'b0;

        s0_addr       = m_addr;
        s0_write_data = m_write_data;
        s0_byte_enable= m_byte_enable;
        s0_write_en   = m_write_en;

        s1_addr       = m_addr;
        s1_write_data = m_write_data;
        s1_write_en   = m_write_en;

        s2_addr       = m_addr;
        s2_write_data = m_write_data;
        s2_write_en   = m_write_en;

        s3_addr       = m_addr;
        s3_write_data = m_write_data;
        s3_write_en   = m_write_en;

        if (m_req_valid) begin
            if (is_sram)       s0_req_valid = 1'b1;
            else if (is_intc)  s1_req_valid = 1'b1;
            else if (is_timer) s2_req_valid = 1'b1;
            else if (is_uart)  s3_req_valid = 1'b1;
            // No default SRAM routing for unmapped addresses!
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            latched_active_slave <= 2'b00;
        end else if (m_req_valid) begin
            if (is_intc)       latched_active_slave <= 2'b01;
            else if (is_timer) latched_active_slave <= 2'b10;
            else if (is_uart)  latched_active_slave <= 2'b11;
            else               latched_active_slave <= 2'b00;
        end
    end

    // Response Routing & Unmapped Address Fault Handling
    always @(*) begin
        if (is_unmapped) begin
            m_read_data  = 32'hDEAD_BEEF;
            m_resp_valid = 1'b1; // Immediate fault response
        end else begin
            case (latched_active_slave)
                2'b00: begin
                    m_read_data  = s0_read_data;
                    m_resp_valid = s0_resp_valid;
                end
                2'b01: begin
                    m_read_data  = s1_read_data;
                    m_resp_valid = s1_resp_valid;
                end
                2'b10: begin
                    m_read_data  = s2_read_data;
                    m_resp_valid = s2_resp_valid;
                end
                2'b11: begin
                    m_read_data  = s3_read_data;
                    m_resp_valid = s3_resp_valid;
                end
            endcase
        end
    end

endmodule
