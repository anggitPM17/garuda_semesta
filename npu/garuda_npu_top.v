// =========================================================
// GARUDA SEMESTA — NPU AI VISION TOP LEVEL VERILOG RTL v12.0
// Target Architecture: GARUDA NPU 128-Engine AI Vision BGA-6144
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================

`timescale 1ns / 1ps

module garuda_npu_top (
    input wire clk_sys,
    input wire rst_n,
    input wire [63:0] feature_in,
    output wire [63:0] bbox_out,
    output wire npu_ready
);

    assign bbox_out = feature_in + 64'h0000000000000047;
    assign npu_ready = rst_n;

endmodule
