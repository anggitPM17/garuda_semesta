// =========================================================================
// GARUDA SEMESTA — NoC XY DIRECTIONAL ROUTING LOGIC (v12.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable XY Dimension-Order Routing Logic:
// - Computes Output Port (LOCAL, NORTH, SOUTH, EAST, WEST) based on Target Node Coordinates (Dest_X, Dest_Y)
// - Deadlock-Free Dimension Order Routing (X first, then Y)
// =========================================================================

`timescale 1ns / 1ps
`include "garuda_noc_packet_defs.vh"

module garuda_noc_routing_logic #(
    parameter NODE_X = 0,
    parameter NODE_Y = 0
)(
    input  wire [63:0] dest_addr,
    output reg  [2:0]  target_port
);

    wire [3:0] dest_x = dest_addr[7:4];
    wire [3:0] dest_y = dest_addr[3:0];

    always @(*) begin
        if (dest_x == NODE_X[3:0] && dest_y == NODE_Y[3:0]) begin
            target_port = `PORT_LOCAL;
        end else if (dest_x > NODE_X[3:0]) begin
            target_port = `PORT_EAST;
        end else if (dest_x < NODE_X[3:0]) begin
            target_port = `PORT_WEST;
        end else if (dest_y > NODE_Y[3:0]) begin
            target_port = `PORT_NORTH;
        end else begin
            target_port = `PORT_SOUTH;
        end
    end

endmodule
