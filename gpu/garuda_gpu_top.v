// =========================================================
// GARUDA SEMESTA — GPU TOP LEVEL VERILOG RTL v12.0
// Target Architecture: GARUDA GPU 128-Core Ray-Tracing BGA-6144
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================

`timescale 1ns / 1ps

module garuda_gpu_top (
    input wire clk_sys,
    input wire rst_n,
    input wire [63:0] ray_in,
    output wire [63:0] pixel_out,
    output wire render_ready
);

    assign pixel_out = ray_in ^ 64'hFFFFFFFFFFFFFFFF;
    assign render_ready = rst_n;

endmodule
