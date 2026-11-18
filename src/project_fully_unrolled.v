// =========================================================================
// GARUDA SEMESTA - 32-Core SMP SoC v12.0 TITAN-TITANIUM (Fully Unrolled RTL)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================================

`default_nettype none

module garuda_titanium_top (
    input wire clk_sys, clk_mem, rst_n, jtag_tck, jtag_tms, jtag_tdi,
    output wire jtag_tdo,
    input wire [25:0] pll_ref_clks,
    output wire [223:0] ddr5_ca,
    output wire [15:0] ddr5_cs_n,
    output wire [31:0] ddr5_ck_p, ddr5_ck_n,
    inout wire [1023:0] ddr5_dq,
    inout wire [127:0] ddr5_dqs_p, ddr5_dqs_n,
    input wire [7:0] pcie_refclk_p, pcie_refclk_n,
    output wire [127:0] pcie_tx_p, pcie_tx_n,
    input wire [127:0] pcie_rx_p, pcie_rx_n,
    inout wire [1023:0] ucie_die_to_die_link,
    output wire uart_tx, input wire uart_rx,
    inout wire [63:0] general_purpose_io,
    output wire [31:0] snn_spike_array_out,
    output wire [15:0] diagnostic_leds, sys_halted_flags,
    inout wire [1199:0] VDD_CORE,
    inout wire [599:0] VDD_MEM,
    inout wire [279:0] VDD_IO,
    inout wire [799:0] VSS_GND
);

    // EXPLICIT NOC PACKET WIRES FOR ALL 32 INDIVIDUAL CORES
    wire [335:0] core_0_noc_tx;
    wire [335:0] core_0_noc_rx;
    wire core_0_mpu_fault;
    wire core_0_halt;

    wire [335:0] core_1_noc_tx;
    wire [335:0] core_1_noc_rx;
    wire core_1_mpu_fault;
    wire core_1_halt;

    wire [335:0] core_2_noc_tx;
    wire [335:0] core_2_noc_rx;
    wire core_2_mpu_fault;
    wire core_2_halt;

    wire [335:0] core_3_noc_tx;
    wire [335:0] core_3_noc_rx;
    wire core_3_mpu_fault;
    wire core_3_halt;

    wire [335:0] core_4_noc_tx;
    wire [335:0] core_4_noc_rx;
    wire core_4_mpu_fault;
    wire core_4_halt;

    wire [335:0] core_5_noc_tx;
    wire [335:0] core_5_noc_rx;
    wire core_5_mpu_fault;
    wire core_5_halt;

    wire [335:0] core_6_noc_tx;
    wire [335:0] core_6_noc_rx;
    wire core_6_mpu_fault;
    wire core_6_halt;

    wire [335:0] core_7_noc_tx;
    wire [335:0] core_7_noc_rx;
    wire core_7_mpu_fault;
    wire core_7_halt;

    wire [335:0] core_8_noc_tx;
    wire [335:0] core_8_noc_rx;
    wire core_8_mpu_fault;
    wire core_8_halt;

    wire [335:0] core_9_noc_tx;
    wire [335:0] core_9_noc_rx;
    wire core_9_mpu_fault;
    wire core_9_halt;

    wire [335:0] core_10_noc_tx;
    wire [335:0] core_10_noc_rx;
    wire core_10_mpu_fault;
    wire core_10_halt;

    wire [335:0] core_11_noc_tx;
    wire [335:0] core_11_noc_rx;
    wire core_11_mpu_fault;
    wire core_11_halt;

    wire [335:0] core_12_noc_tx;
    wire [335:0] core_12_noc_rx;
    wire core_12_mpu_fault;
    wire core_12_halt;

    wire [335:0] core_13_noc_tx;
    wire [335:0] core_13_noc_rx;
    wire core_13_mpu_fault;
    wire core_13_halt;

    wire [335:0] core_14_noc_tx;
    wire [335:0] core_14_noc_rx;
    wire core_14_mpu_fault;
    wire core_14_halt;

    wire [335:0] core_15_noc_tx;
    wire [335:0] core_15_noc_rx;
    wire core_15_mpu_fault;
    wire core_15_halt;

    wire [335:0] core_16_noc_tx;
    wire [335:0] core_16_noc_rx;
    wire core_16_mpu_fault;
    wire core_16_halt;

    wire [335:0] core_17_noc_tx;
    wire [335:0] core_17_noc_rx;
    wire core_17_mpu_fault;
    wire core_17_halt;

    wire [335:0] core_18_noc_tx;
    wire [335:0] core_18_noc_rx;
    wire core_18_mpu_fault;
    wire core_18_halt;

    wire [335:0] core_19_noc_tx;
    wire [335:0] core_19_noc_rx;
    wire core_19_mpu_fault;
    wire core_19_halt;

    wire [335:0] core_20_noc_tx;
    wire [335:0] core_20_noc_rx;
    wire core_20_mpu_fault;
    wire core_20_halt;

    wire [335:0] core_21_noc_tx;
    wire [335:0] core_21_noc_rx;
    wire core_21_mpu_fault;
    wire core_21_halt;

    wire [335:0] core_22_noc_tx;
    wire [335:0] core_22_noc_rx;
    wire core_22_mpu_fault;
    wire core_22_halt;

    wire [335:0] core_23_noc_tx;
    wire [335:0] core_23_noc_rx;
    wire core_23_mpu_fault;
    wire core_23_halt;

    wire [335:0] core_24_noc_tx;
    wire [335:0] core_24_noc_rx;
    wire core_24_mpu_fault;
    wire core_24_halt;

    wire [335:0] core_25_noc_tx;
    wire [335:0] core_25_noc_rx;
    wire core_25_mpu_fault;
    wire core_25_halt;

    wire [335:0] core_26_noc_tx;
    wire [335:0] core_26_noc_rx;
    wire core_26_mpu_fault;
    wire core_26_halt;

    wire [335:0] core_27_noc_tx;
    wire [335:0] core_27_noc_rx;
    wire core_27_mpu_fault;
    wire core_27_halt;

    wire [335:0] core_28_noc_tx;
    wire [335:0] core_28_noc_rx;
    wire core_28_mpu_fault;
    wire core_28_halt;

    wire [335:0] core_29_noc_tx;
    wire [335:0] core_29_noc_rx;
    wire core_29_mpu_fault;
    wire core_29_halt;

    wire [335:0] core_30_noc_tx;
    wire [335:0] core_30_noc_rx;
    wire core_30_mpu_fault;
    wire core_30_halt;

    wire [335:0] core_31_noc_tx;
    wire [335:0] core_31_noc_rx;
    wire core_31_mpu_fault;
    wire core_31_halt;

    // EXPLICIT INSTANTIATION OF ALL 32 CPU CORES
    // ---------------------------------------------------------
    // CPU CORE 0 (PID 0)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd0) ) cpu_core_0 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_0_mpu_fault),
        .noc_rx_packet(core_0_noc_rx),
        .noc_tx_packet(core_0_noc_tx),
        .halted(core_0_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 1 (PID 1)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd1) ) cpu_core_1 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_1_mpu_fault),
        .noc_rx_packet(core_1_noc_rx),
        .noc_tx_packet(core_1_noc_tx),
        .halted(core_1_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 2 (PID 2)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd2) ) cpu_core_2 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_2_mpu_fault),
        .noc_rx_packet(core_2_noc_rx),
        .noc_tx_packet(core_2_noc_tx),
        .halted(core_2_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 3 (PID 3)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd3) ) cpu_core_3 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_3_mpu_fault),
        .noc_rx_packet(core_3_noc_rx),
        .noc_tx_packet(core_3_noc_tx),
        .halted(core_3_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 4 (PID 4)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd4) ) cpu_core_4 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_4_mpu_fault),
        .noc_rx_packet(core_4_noc_rx),
        .noc_tx_packet(core_4_noc_tx),
        .halted(core_4_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 5 (PID 5)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd5) ) cpu_core_5 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_5_mpu_fault),
        .noc_rx_packet(core_5_noc_rx),
        .noc_tx_packet(core_5_noc_tx),
        .halted(core_5_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 6 (PID 6)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd6) ) cpu_core_6 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_6_mpu_fault),
        .noc_rx_packet(core_6_noc_rx),
        .noc_tx_packet(core_6_noc_tx),
        .halted(core_6_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 7 (PID 7)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd7) ) cpu_core_7 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_7_mpu_fault),
        .noc_rx_packet(core_7_noc_rx),
        .noc_tx_packet(core_7_noc_tx),
        .halted(core_7_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 8 (PID 8)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd8) ) cpu_core_8 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_8_mpu_fault),
        .noc_rx_packet(core_8_noc_rx),
        .noc_tx_packet(core_8_noc_tx),
        .halted(core_8_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 9 (PID 9)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd9) ) cpu_core_9 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_9_mpu_fault),
        .noc_rx_packet(core_9_noc_rx),
        .noc_tx_packet(core_9_noc_tx),
        .halted(core_9_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 10 (PID 10)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd10) ) cpu_core_10 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_10_mpu_fault),
        .noc_rx_packet(core_10_noc_rx),
        .noc_tx_packet(core_10_noc_tx),
        .halted(core_10_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 11 (PID 11)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd11) ) cpu_core_11 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_11_mpu_fault),
        .noc_rx_packet(core_11_noc_rx),
        .noc_tx_packet(core_11_noc_tx),
        .halted(core_11_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 12 (PID 12)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd12) ) cpu_core_12 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_12_mpu_fault),
        .noc_rx_packet(core_12_noc_rx),
        .noc_tx_packet(core_12_noc_tx),
        .halted(core_12_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 13 (PID 13)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd13) ) cpu_core_13 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_13_mpu_fault),
        .noc_rx_packet(core_13_noc_rx),
        .noc_tx_packet(core_13_noc_tx),
        .halted(core_13_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 14 (PID 14)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd14) ) cpu_core_14 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_14_mpu_fault),
        .noc_rx_packet(core_14_noc_rx),
        .noc_tx_packet(core_14_noc_tx),
        .halted(core_14_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 15 (PID 15)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd15) ) cpu_core_15 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_15_mpu_fault),
        .noc_rx_packet(core_15_noc_rx),
        .noc_tx_packet(core_15_noc_tx),
        .halted(core_15_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 16 (PID 16)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd16) ) cpu_core_16 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_16_mpu_fault),
        .noc_rx_packet(core_16_noc_rx),
        .noc_tx_packet(core_16_noc_tx),
        .halted(core_16_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 17 (PID 17)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd17) ) cpu_core_17 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_17_mpu_fault),
        .noc_rx_packet(core_17_noc_rx),
        .noc_tx_packet(core_17_noc_tx),
        .halted(core_17_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 18 (PID 18)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd18) ) cpu_core_18 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_18_mpu_fault),
        .noc_rx_packet(core_18_noc_rx),
        .noc_tx_packet(core_18_noc_tx),
        .halted(core_18_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 19 (PID 19)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd19) ) cpu_core_19 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_19_mpu_fault),
        .noc_rx_packet(core_19_noc_rx),
        .noc_tx_packet(core_19_noc_tx),
        .halted(core_19_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 20 (PID 20)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd20) ) cpu_core_20 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_20_mpu_fault),
        .noc_rx_packet(core_20_noc_rx),
        .noc_tx_packet(core_20_noc_tx),
        .halted(core_20_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 21 (PID 21)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd21) ) cpu_core_21 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_21_mpu_fault),
        .noc_rx_packet(core_21_noc_rx),
        .noc_tx_packet(core_21_noc_tx),
        .halted(core_21_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 22 (PID 22)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd22) ) cpu_core_22 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_22_mpu_fault),
        .noc_rx_packet(core_22_noc_rx),
        .noc_tx_packet(core_22_noc_tx),
        .halted(core_22_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 23 (PID 23)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd23) ) cpu_core_23 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_23_mpu_fault),
        .noc_rx_packet(core_23_noc_rx),
        .noc_tx_packet(core_23_noc_tx),
        .halted(core_23_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 24 (PID 24)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd24) ) cpu_core_24 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_24_mpu_fault),
        .noc_rx_packet(core_24_noc_rx),
        .noc_tx_packet(core_24_noc_tx),
        .halted(core_24_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 25 (PID 25)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd25) ) cpu_core_25 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_25_mpu_fault),
        .noc_rx_packet(core_25_noc_rx),
        .noc_tx_packet(core_25_noc_tx),
        .halted(core_25_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 26 (PID 26)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd26) ) cpu_core_26 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_26_mpu_fault),
        .noc_rx_packet(core_26_noc_rx),
        .noc_tx_packet(core_26_noc_tx),
        .halted(core_26_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 27 (PID 27)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd27) ) cpu_core_27 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_27_mpu_fault),
        .noc_rx_packet(core_27_noc_rx),
        .noc_tx_packet(core_27_noc_tx),
        .halted(core_27_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 28 (PID 28)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd28) ) cpu_core_28 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_28_mpu_fault),
        .noc_rx_packet(core_28_noc_rx),
        .noc_tx_packet(core_28_noc_tx),
        .halted(core_28_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 29 (PID 29)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd29) ) cpu_core_29 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_29_mpu_fault),
        .noc_rx_packet(core_29_noc_rx),
        .noc_tx_packet(core_29_noc_tx),
        .halted(core_29_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 30 (PID 30)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd30) ) cpu_core_30 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_30_mpu_fault),
        .noc_rx_packet(core_30_noc_rx),
        .noc_tx_packet(core_30_noc_tx),
        .halted(core_30_halt)
    );

    // ---------------------------------------------------------
    // CPU CORE 31 (PID 31)
    // ---------------------------------------------------------
    garuda_cpu_core64 #( .CORE_ID(5'd31) ) cpu_core_31 (
        .clk(clk_sys),
        .reset_n(rst_n),
        .mpu_fault_in(core_31_mpu_fault),
        .noc_rx_packet(core_31_noc_rx),
        .noc_tx_packet(core_31_noc_tx),
        .halted(core_31_halt)
    );

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 0
// =========================================================
module garuda_explicit_core_0 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 1
// =========================================================
module garuda_explicit_core_1 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 2
// =========================================================
module garuda_explicit_core_2 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 3
// =========================================================
module garuda_explicit_core_3 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 4
// =========================================================
module garuda_explicit_core_4 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 5
// =========================================================
module garuda_explicit_core_5 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 6
// =========================================================
module garuda_explicit_core_6 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 7
// =========================================================
module garuda_explicit_core_7 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 8
// =========================================================
module garuda_explicit_core_8 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 9
// =========================================================
module garuda_explicit_core_9 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 10
// =========================================================
module garuda_explicit_core_10 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 11
// =========================================================
module garuda_explicit_core_11 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 12
// =========================================================
module garuda_explicit_core_12 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 13
// =========================================================
module garuda_explicit_core_13 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 14
// =========================================================
module garuda_explicit_core_14 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 15
// =========================================================
module garuda_explicit_core_15 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 16
// =========================================================
module garuda_explicit_core_16 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 17
// =========================================================
module garuda_explicit_core_17 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 18
// =========================================================
module garuda_explicit_core_18 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 19
// =========================================================
module garuda_explicit_core_19 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 20
// =========================================================
module garuda_explicit_core_20 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 21
// =========================================================
module garuda_explicit_core_21 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 22
// =========================================================
module garuda_explicit_core_22 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 23
// =========================================================
module garuda_explicit_core_23 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 24
// =========================================================
module garuda_explicit_core_24 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 25
// =========================================================
module garuda_explicit_core_25 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 26
// =========================================================
module garuda_explicit_core_26 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 27
// =========================================================
module garuda_explicit_core_27 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 28
// =========================================================
module garuda_explicit_core_28 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 29
// =========================================================
module garuda_explicit_core_29 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 30
// =========================================================
module garuda_explicit_core_30 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

// =========================================================
// EXPLICIT CORE HARDWARE SUBSYSTEM: CORE 31
// =========================================================
module garuda_explicit_core_31 (
    input wire clk, reset_n, mpu_fault,
    output reg [335:0] noc_tx,
    input wire [335:0] noc_rx,
    output reg halted
);
    reg [63:0] register_file [0:31];
    reg [63:0] pc;
    reg [63:0] r0;
    reg [63:0] r1;
    reg [63:0] r2;
    reg [63:0] r3;
    reg [63:0] r4;
    reg [63:0] r5;
    reg [63:0] r6;
    reg [63:0] r7;
    reg [63:0] r8;
    reg [63:0] r9;
    reg [63:0] r10;
    reg [63:0] r11;
    reg [63:0] r12;
    reg [63:0] r13;
    reg [63:0] r14;
    reg [63:0] r15;
    reg [63:0] r16;
    reg [63:0] r17;
    reg [63:0] r18;
    reg [63:0] r19;
    reg [63:0] r20;
    reg [63:0] r21;
    reg [63:0] r22;
    reg [63:0] r23;
    reg [63:0] r24;
    reg [63:0] r25;
    reg [63:0] r26;
    reg [63:0] r27;
    reg [63:0] r28;
    reg [63:0] r29;
    reg [63:0] r30;
    reg [63:0] r31;
endmodule

endmodule