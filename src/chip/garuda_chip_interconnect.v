// =========================================================================
// GARUDA SEMESTA — CHIP SYSTEM INTERCONNECT TRANSACTION FSM (v13.1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Single-Outstanding Transaction FSM Interconnect:
// - States: IDLE, CAPTURE, ISSUE, WAIT_RESPONSE, RETURN_RESPONSE, ERROR_RESPONSE, WAIT_RELEASE
// - Locks address, write data, byte enables, and selected slave during outstanding transaction
// - Issues single-cycle pulse request to selected slave
// - Unmapped addresses return immediate 0xDEADBEEF fault response without activating slaves
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

    // FSM States
    localparam STATE_IDLE            = 3'b000;
    localparam STATE_CAPTURE         = 3'b001;
    localparam STATE_ISSUE           = 3'b010;
    localparam STATE_WAIT_RESPONSE   = 3'b011;
    localparam STATE_RETURN_RESPONSE = 3'b100;
    localparam STATE_ERROR_RESPONSE  = 3'b101;
    localparam STATE_WAIT_RELEASE    = 3'b110;

    reg [2:0] state, next_state;

    // Latched Transaction Payload (Locked during outstanding transaction)
    reg [ADDR_WIDTH-1:0] latched_addr;
    reg [DATA_WIDTH-1:0] latched_wdata;
    reg [3:0]            latched_be;
    reg                  latched_wen;
    reg [1:0]            latched_slave_id; // 0=SRAM, 1=INTC, 2=Timer, 3=UART

    // Address Decoding (Main SRAM capped to 64 KB 0x8000_0000 - 0x8000_FFFF)
    wire is_sram  = (latched_addr >= 32'h8000_0000) && (latched_addr <= 32'h8000_FFFF);
    wire is_intc  = (latched_addr >= 32'h4000_1000) && (latched_addr <= 32'h4000_101F);
    wire is_timer = (latched_addr >= 32'h4000_2000) && (latched_addr <= 32'h4000_201F);
    wire is_uart  = (latched_addr >= 32'h4000_3000) && (latched_addr <= 32'h4000_301F);
    wire is_unmapped = !(is_sram || is_intc || is_timer || is_uart);

    // Initial Master Request Decoding
    wire req_is_sram  = (m_addr >= 32'h8000_0000) && (m_addr <= 32'h8000_FFFF);
    wire req_is_intc  = (m_addr >= 32'h4000_1000) && (m_addr <= 32'h4000_101F);
    wire req_is_timer = (m_addr >= 32'h4000_2000) && (m_addr <= 32'h4000_201F);
    wire req_is_uart  = (m_addr >= 32'h4000_3000) && (m_addr <= 32'h4000_301F);
    wire req_is_unmapped = !(req_is_sram || req_is_intc || req_is_timer || req_is_uart);

    // FSM Sequential State Transition & Payload Latching
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= STATE_IDLE;
            latched_addr     <= 32'h0;
            latched_wdata    <= 32'h0;
            latched_be       <= 4'h0;
            latched_wen      <= 1'b0;
            latched_slave_id <= 2'b00;
        end else begin
            state <= next_state;
            if (state == STATE_IDLE && m_req_valid) begin
                latched_addr  <= m_addr;
                latched_wdata <= m_write_data;
                latched_be    <= m_byte_enable;
                latched_wen   <= m_write_en;
                if (req_is_intc)       latched_slave_id <= 2'b01;
                else if (req_is_timer) latched_slave_id <= 2'b10;
                else if (req_is_uart)  latched_slave_id <= 2'b11;
                else                   latched_slave_id <= 2'b00;
            end
        end
    end

    // FSM Combinational Next-State & Output Logic (Single-Pulse Slave Request)
    always @(*) begin
        next_state   = state;
        m_read_data  = 32'h0;
        m_resp_valid = 1'b0;

        s0_req_valid = 1'b0;
        s1_req_valid = 1'b0;
        s2_req_valid = 1'b0;
        s3_req_valid = 1'b0;

        s0_addr       = latched_addr;
        s0_write_data = latched_wdata;
        s0_byte_enable= latched_be;
        s0_write_en   = latched_wen;

        s1_addr       = latched_addr;
        s1_write_data = latched_wdata;
        s1_write_en   = latched_wen;

        s2_addr       = latched_addr;
        s2_write_data = latched_wdata;
        s2_write_en   = latched_wen;

        s3_addr       = latched_addr;
        s3_write_data = latched_wdata;
        s3_write_en   = latched_wen;

        case (state)
            STATE_IDLE: begin
                if (m_req_valid) begin
                    if (req_is_unmapped)
                        next_state = STATE_ERROR_RESPONSE;
                    else
                        next_state = STATE_CAPTURE;
                end
            end

            STATE_CAPTURE: begin
                next_state = STATE_ISSUE;
            end

            STATE_ISSUE: begin
                // Single-cycle pulse request issued to locked slave
                case (latched_slave_id)
                    2'b00: s0_req_valid = is_sram;
                    2'b01: s1_req_valid = is_intc;
                    2'b10: s2_req_valid = is_timer;
                    2'b11: s3_req_valid = is_uart;
                endcase
                next_state = STATE_WAIT_RESPONSE;
            end

            STATE_WAIT_RESPONSE: begin
                case (latched_slave_id)
                    2'b00: if (s0_resp_valid) next_state = STATE_RETURN_RESPONSE;
                    2'b01: if (s1_resp_valid) next_state = STATE_RETURN_RESPONSE;
                    2'b10: if (s2_resp_valid) next_state = STATE_RETURN_RESPONSE;
                    2'b11: if (s3_resp_valid) next_state = STATE_RETURN_RESPONSE;
                endcase
            end

            STATE_RETURN_RESPONSE: begin
                m_resp_valid = 1'b1;
                case (latched_slave_id)
                    2'b00: m_read_data = s0_read_data;
                    2'b01: m_read_data = s1_read_data;
                    2'b10: m_read_data = s2_read_data;
                    2'b11: m_read_data = s3_read_data;
                endcase
                next_state = STATE_WAIT_RELEASE;
            end

            STATE_ERROR_RESPONSE: begin
                m_resp_valid = 1'b1;
                m_read_data  = 32'hDEAD_BEEF; // Unmapped bus fault response
                next_state   = STATE_WAIT_RELEASE;
            end

            STATE_WAIT_RELEASE: begin
                // Wait until master deasserts m_req_valid before returning to IDLE
                if (!m_req_valid)
                    next_state = STATE_IDLE;
            end

            default: next_state = STATE_IDLE;
        endcase
    end

endmodule
