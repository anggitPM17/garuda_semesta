// =========================================================
// GARUDA SEMESTA — MCU IOT TOP LEVEL VERILOG RTL v12.0
// Target Architecture: GARUDA MCU 128-Core RISC-V IoT BGA-6144
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================

`timescale 1ns / 1ps

module garuda_mcu_top (
    input wire clk_sys,
    input wire rst_n,
    input wire [31:0] adc_in,
    output wire [31:0] gpio_out,
    output wire pmu_sleep_ready
);

    assign gpio_out = adc_in;
    assign pmu_sleep_ready = rst_n;

endmodule
