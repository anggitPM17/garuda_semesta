// =========================================================================
// GARUDA SEMESTA — 64-BIT TO 32-BIT BUS ADAPTER (v12.9.1-TIMINGFIX)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// FIX v12.9.1:
//  - m_resp_valid asserted only when state == ST_DONE (upper_data settled)
//  - Prevents race condition where m_resp_data used un-settled upper_data
// =========================================================================

`timescale 1ns / 1ps

module garuda_bus_adapter_64to32 #(
    parameter ADDR_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // 64-bit Master Interface (e.g. from I-Cache)
    input  wire [ADDR_WIDTH-1:0] m_req_addr,
    input  wire                  m_req_valid,
    output reg                   m_req_ready,
    output reg  [63:0]           m_resp_data,
    output reg                   m_resp_valid,
    output reg                   m_resp_error,

    // 32-bit Slave Interface (e.g. to L2 Cache)
    output reg  [ADDR_WIDTH-1:0] s_req_addr,
    output reg                   s_req_valid,
    input  wire                  s_req_ready,
    input  wire [31:0]           s_resp_data,
    input  wire                  s_resp_valid,
    input  wire                  s_resp_error
);

    localparam ST_IDLE   = 2'b00;
    localparam ST_READ_L = 2'b01; // Fetch lower 32-bits (addr + 0)
    localparam ST_READ_H = 2'b10; // Fetch upper 32-bits (addr + 4)
    localparam ST_DONE   = 2'b11; // Response hold state

    reg [1:0]            state, next_state;
    reg [31:0]           lower_data;
    reg [31:0]           upper_data;
    reg                  error_flag;
    reg [ADDR_WIDTH-1:0] latched_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= ST_IDLE;
            lower_data   <= 32'd0;
            upper_data   <= 32'd0;
            error_flag   <= 1'b0;
            latched_addr <= 32'h8000_0000;
        end else begin
            state <= next_state;

            if (state == ST_IDLE && m_req_valid && (^m_req_addr !== 1'bx)) begin
                latched_addr <= m_req_addr;
            end

            if (state == ST_READ_L && s_resp_valid) begin
                lower_data <= s_resp_data;
                if (s_resp_error) error_flag <= 1'b1;
            end
            if (state == ST_READ_H && s_resp_valid) begin
                upper_data <= s_resp_data;
                if (s_resp_error) error_flag <= 1'b1;
            end
            if (state == ST_IDLE) begin
                error_flag <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state   = state;
        m_req_ready  = 1'b0;
        m_resp_valid = 1'b0;
        m_resp_data  = 64'd0;
        m_resp_error = 1'b0;
        s_req_valid  = 1'b0;
        s_req_addr   = latched_addr;

        case (state)
            ST_IDLE: begin
                m_req_ready = 1'b1;
                if (m_req_valid) begin
                    next_state = ST_READ_L;
                end
            end
            ST_READ_L: begin
                s_req_valid = 1'b1;
                s_req_addr  = latched_addr; // Lower 32-bits
                if (s_resp_valid) begin
                    next_state = ST_READ_H;
                end
            end
            ST_READ_H: begin
                s_req_valid = 1'b1;
                s_req_addr  = latched_addr + 32'd4; // Upper 32-bits
                if (s_resp_valid) begin
                    next_state = ST_DONE;
                end
            end
            ST_DONE: begin
                m_req_ready  = 1'b0;
                m_resp_valid = 1'b1;
                m_resp_data  = {upper_data, lower_data};
                m_resp_error = error_flag;
                next_state   = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

endmodule
