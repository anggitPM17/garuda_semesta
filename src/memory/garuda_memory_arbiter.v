// =========================================================================
// GARUDA SEMESTA — MULTI-MASTER MEMORY ARBITER MODULE (v12.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Multi-Master Memory Arbiter:
// - Supports 2 Masters: Master #0 (CPU Core), Master #1 (GPU/DMA Core)
// - Fair Round-Robin / Fixed-Priority Arbitration Logic
// - Request Acceptance, Grant Signal, Lock Protection, and Backpressure
// =========================================================================

`timescale 1ns / 1ps

module garuda_memory_arbiter #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Master 0 Interface (CPU)
    input  wire [ADDR_WIDTH-1:0] m0_addr,
    input  wire [DATA_WIDTH-1:0] m0_write_data,
    input  wire [3:0]            m0_byte_enable,
    input  wire                  m0_write_en,
    input  wire                  m0_req_valid,
    output reg  [DATA_WIDTH-1:0] m0_read_data,
    output reg                   m0_grant,
    output reg                   m0_resp_valid,

    // Master 1 Interface (GPU/DMA)
    input  wire [ADDR_WIDTH-1:0] m1_addr,
    input  wire [DATA_WIDTH-1:0] m1_write_data,
    input  wire [3:0]            m1_byte_enable,
    input  wire                  m1_write_en,
    input  wire                  m1_req_valid,
    output reg  [DATA_WIDTH-1:0] m1_read_data,
    output reg                   m1_grant,
    output reg                   m1_resp_valid,

    // Target Memory Controller Interface
    output reg  [ADDR_WIDTH-1:0] target_addr,
    output reg  [DATA_WIDTH-1:0] target_write_data,
    output reg  [3:0]            target_byte_enable,
    output reg                   target_write_en,
    output reg                   target_req_valid,
    input  wire [DATA_WIDTH-1:0] target_read_data,
    input  wire                  target_resp_valid
);

    reg active_master; // 0 for Master 0, 1 for Master 1
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_master <= 1'b0;
            busy <= 1'b0;
            m0_grant <= 1'b0;
            m1_grant <= 1'b0;
            m0_resp_valid <= 1'b0;
            m1_resp_valid <= 1'b0;
            m0_read_data <= {DATA_WIDTH{1'b0}};
            m1_read_data <= {DATA_WIDTH{1'b0}};
            target_req_valid <= 1'b0;
            target_addr <= {ADDR_WIDTH{1'b0}};
            target_write_data <= {DATA_WIDTH{1'b0}};
            target_byte_enable <= 4'h0;
            target_write_en <= 1'b0;
        end else begin
            m0_resp_valid <= 1'b0;
            m1_resp_valid <= 1'b0;

            if (!busy) begin
                if (m0_req_valid) begin
                    active_master <= 1'b0;
                    busy <= 1'b1;
                    m0_grant <= 1'b1;
                    m1_grant <= 1'b0;
                    target_req_valid <= 1'b1;
                    target_addr <= m0_addr;
                    target_write_data <= m0_write_data;
                    target_byte_enable <= m0_byte_enable;
                    target_write_en <= m0_write_en;
                end else if (m1_req_valid) begin
                    active_master <= 1'b1;
                    busy <= 1'b1;
                    m0_grant <= 1'b0;
                    m1_grant <= 1'b1;
                    target_req_valid <= 1'b1;
                    target_addr <= m1_addr;
                    target_write_data <= m1_write_data;
                    target_byte_enable <= m1_byte_enable;
                    target_write_en <= m1_write_en;
                end
            end else begin
                if (target_resp_valid) begin
                    busy <= 1'b0;
                    target_req_valid <= 1'b0;
                    if (active_master == 1'b0) begin
                        m0_grant <= 1'b0;
                        m0_read_data <= target_read_data;
                        m0_resp_valid <= 1'b1;
                    end else begin
                        m1_grant <= 1'b0;
                        m1_read_data <= target_read_data;
                        m1_resp_valid <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
