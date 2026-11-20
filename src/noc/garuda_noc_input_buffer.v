// =========================================================================
// GARUDA SEMESTA — NoC ROUTER FIFO INPUT BUFFER (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable NoC FIFO Input Buffer:
// - Depth: 8 Flits x 336-bit NoC Packet
// - Credit-Based Flow Control & Backpressure (`full` & `empty` signals)
// =========================================================================

`timescale 1ns / 1ps
`include "garuda_noc_packet_defs.vh"

module garuda_noc_input_buffer #(
    parameter DEPTH = 8,
    parameter WIDTH = `NOC_PACKET_WIDTH
)(
    input  wire             clk,
    input  wire             rst_n,

    // Write Interface (From Neighbor Router)
    input  wire [WIDTH-1:0] push_packet,
    input  wire             push_valid,
    output wire             buffer_full,

    // Read Interface (To Routing Logic & Arbiter)
    output wire [WIDTH-1:0] pop_packet,
    input  wire             pop_ready,
    output wire             buffer_empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [2:0] wr_ptr;
    reg [2:0] rd_ptr;
    reg [3:0] count;

    assign buffer_full  = (count == DEPTH);
    assign buffer_empty = (count == 0);
    assign pop_packet   = mem[rd_ptr];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'd0;
            rd_ptr <= 3'd0;
            count  <= 4'd0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end else begin
            case ({push_valid && !buffer_full, pop_ready && !buffer_empty})
                2'b10: begin // Push only
                    mem[wr_ptr] <= push_packet;
                    wr_ptr <= wr_ptr + 1'b1;
                    count <= count + 1'b1;
                end
                2'b01: begin // Pop only
                    rd_ptr <= rd_ptr + 1'b1;
                    count <= count - 1'b1;
                end
                2'b11: begin // Concurrent Push and Pop
                    mem[wr_ptr] <= push_packet;
                    wr_ptr <= wr_ptr + 1'b1;
                    rd_ptr <= rd_ptr + 1'b1;
                end
                default: ; // Idle
            endcase
        end
    end

endmodule
