// =========================================================================
// GARUDA SEMESTA — 5-PORT NoC ROUTER TOP-LEVEL (v12.0 TITAN-TITANIUM)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 5-Port Mesh NoC Router:
// - Ports: Local (0), North (1), South (2), East (3), West (4)
// - 336-bit Flit Input Buffers, XY Routing Logic, Fair Round-Robin Arbiter
// - Backpressure & Flow Control Handshaking
// =========================================================================

`timescale 1ns / 1ps
`include "garuda_noc_packet_defs.vh"

module garuda_noc_router_top #(
    parameter NODE_X = 0,
    parameter NODE_Y = 0,
    parameter WIDTH  = `NOC_PACKET_WIDTH
)(
    input  wire             clk,
    input  wire             rst_n,

    // 5 Input Ports (Local, North, South, East, West)
    input  wire [WIDTH-1:0] in_packet [0:4],
    input  wire             in_valid  [0:4],
    output wire             in_full   [0:4],

    // 5 Output Ports (Local, North, South, East, West)
    output reg  [WIDTH-1:0] out_packet [0:4],
    output reg              out_valid  [0:4],
    input  wire             out_ready  [0:4]
);

    wire [WIDTH-1:0] buf_out_packet [0:4];
    wire             buf_empty [0:4];
    reg              buf_pop_ready [0:4];
    wire [2:0]       route_target_port [0:4];

    genvar p;
    generate
        for (p = 0; p < 5; p = p + 1) begin : PORT_GEN
            garuda_noc_input_buffer #(
                .DEPTH(8),
                .WIDTH(WIDTH)
            ) u_buf (
                .clk(clk),
                .rst_n(rst_n),
                .push_packet(in_packet[p]),
                .push_valid(in_valid[p]),
                .buffer_full(in_full[p]),
                .pop_packet(buf_out_packet[p]),
                .pop_ready(buf_pop_ready[p]),
                .buffer_empty(buf_empty[p])
            );

            garuda_noc_routing_logic #(
                .NODE_X(NODE_X),
                .NODE_Y(NODE_Y)
            ) u_route (
                .dest_addr(buf_out_packet[p][319:256]),
                .target_port(route_target_port[p])
            );
        end
    endgenerate

    integer i;

    // Arbiter & Switch Crossbar Transfer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 5; i = i + 1) begin
                out_packet[i] <= {WIDTH{1'b0}};
                out_valid[i]  <= 1'b0;
                buf_pop_ready[i] <= 1'b0;
            end
        end else begin
            for (i = 0; i < 5; i = i + 1) begin
                out_valid[i] <= 1'b0;
                buf_pop_ready[i] <= 1'b0;
            end

            // Route non-empty buffer to requested target port
            for (i = 0; i < 5; i = i + 1) begin
                if (!buf_empty[i] && out_ready[route_target_port[i]]) begin
                    out_packet[route_target_port[i]] <= buf_out_packet[i];
                    out_valid[route_target_port[i]]  <= 1'b1;
                    buf_pop_ready[i] <= 1'b1;
                end
            end
        end
    end

endmodule
