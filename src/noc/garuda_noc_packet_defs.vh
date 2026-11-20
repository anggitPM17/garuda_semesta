// =========================================================================
// GARUDA SEMESTA — 3D MESH/TORUS NoC PACKET HEADER DEFINITIONS (v12.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// 336-bit NoC Flit & Packet Structure:
// - [335:320] Header / Packet Type (16 bits)
// - [319:256] Source / Destination Address (64 bits)
// - [255:224] Virtual Channel & Flow Control Flags (32 bits)
// - [223:32]  Payload Data Stream (192 bits)
// - [31:0]    CRC32 Parity Error Detection (32 bits)
// =========================================================================

`ifndef GARUDA_NOC_PACKET_DEFS_VH
`define GARUDA_NOC_PACKET_DEFS_VH

`define NOC_PACKET_WIDTH 336
`define NOC_ADDR_WIDTH   64
`define NOC_DATA_WIDTH   192
`define NOC_VC_WIDTH     2

// Packet Type Codes
`define PKT_TYPE_READ_REQ  16'h0001
`define PKT_TYPE_WRITE_REQ 16'h0002
`define PKT_TYPE_RESP_ACK  16'h0004
`define PKT_TYPE_INTERRUPT 16'h0008

// Directional Ports
`define PORT_LOCAL 3'd0
`define PORT_NORTH 3'd1
`define PORT_SOUTH 3'd2
`define PORT_EAST  3'd3
`define PORT_WEST  3'd4

`endif // GARUDA_NOC_PACKET_DEFS_VH
