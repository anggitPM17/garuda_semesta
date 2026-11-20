// =========================================================
// GARUDA SEMESTA — CPU SOC TOP LEVEL VERILOG RTL v12.0
// Target Architecture: GARUDA CPU 32-Core Ultra-SMP BGA-6144
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================

`timescale 1ns / 1ps

module garuda_cpu_top (
    input wire clk_sys,
    input wire rst_n,
    input wire [63:0] in_data,
    output wire [63:0] out_data,
    output wire ready
);

    assign out_data = in_data + 64'h0000000000000001;
    assign ready = rst_n;

endmodule
