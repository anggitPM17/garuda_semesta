// =========================================================================
// GARUDA SECURE v1.0 ULTIMATE - Crypto Vault (Fully Unrolled Verilog RTL)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================================

`default_nettype none

module garuda_secure_top (
    input wire clk_sec, clk_mem, rst_n, tamper_mesh_trig,
    input wire [27:0] pll_ref_clks,
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
    output wire [31:0] trng_entropy_out,
    output wire [15:0] secure_status_flags, zeroization_alert,
    inout wire [1199:0] VDD_SEC,
    inout wire [599:0] VDD_MEM,
    inout wire [279:0] VDD_IO,
    inout wire [799:0] VSS_GND
);

    // EXPLICIT WIRES FOR ALL 64 TRNG QUANTUM ENTROPY ENGINES
    wire [63:0] trng_unit_0_entropy_out;

    wire [63:0] trng_unit_1_entropy_out;

    wire [63:0] trng_unit_2_entropy_out;

    wire [63:0] trng_unit_3_entropy_out;

    wire [63:0] trng_unit_4_entropy_out;

    wire [63:0] trng_unit_5_entropy_out;

    wire [63:0] trng_unit_6_entropy_out;

    wire [63:0] trng_unit_7_entropy_out;

    wire [63:0] trng_unit_8_entropy_out;

    wire [63:0] trng_unit_9_entropy_out;

    wire [63:0] trng_unit_10_entropy_out;

    wire [63:0] trng_unit_11_entropy_out;

    wire [63:0] trng_unit_12_entropy_out;

    wire [63:0] trng_unit_13_entropy_out;

    wire [63:0] trng_unit_14_entropy_out;

    wire [63:0] trng_unit_15_entropy_out;

    wire [63:0] trng_unit_16_entropy_out;

    wire [63:0] trng_unit_17_entropy_out;

    wire [63:0] trng_unit_18_entropy_out;

    wire [63:0] trng_unit_19_entropy_out;

    wire [63:0] trng_unit_20_entropy_out;

    wire [63:0] trng_unit_21_entropy_out;

    wire [63:0] trng_unit_22_entropy_out;

    wire [63:0] trng_unit_23_entropy_out;

    wire [63:0] trng_unit_24_entropy_out;

    wire [63:0] trng_unit_25_entropy_out;

    wire [63:0] trng_unit_26_entropy_out;

    wire [63:0] trng_unit_27_entropy_out;

    wire [63:0] trng_unit_28_entropy_out;

    wire [63:0] trng_unit_29_entropy_out;

    wire [63:0] trng_unit_30_entropy_out;

    wire [63:0] trng_unit_31_entropy_out;

    wire [63:0] trng_unit_32_entropy_out;

    wire [63:0] trng_unit_33_entropy_out;

    wire [63:0] trng_unit_34_entropy_out;

    wire [63:0] trng_unit_35_entropy_out;

    wire [63:0] trng_unit_36_entropy_out;

    wire [63:0] trng_unit_37_entropy_out;

    wire [63:0] trng_unit_38_entropy_out;

    wire [63:0] trng_unit_39_entropy_out;

    wire [63:0] trng_unit_40_entropy_out;

    wire [63:0] trng_unit_41_entropy_out;

    wire [63:0] trng_unit_42_entropy_out;

    wire [63:0] trng_unit_43_entropy_out;

    wire [63:0] trng_unit_44_entropy_out;

    wire [63:0] trng_unit_45_entropy_out;

    wire [63:0] trng_unit_46_entropy_out;

    wire [63:0] trng_unit_47_entropy_out;

    wire [63:0] trng_unit_48_entropy_out;

    wire [63:0] trng_unit_49_entropy_out;

    wire [63:0] trng_unit_50_entropy_out;

    wire [63:0] trng_unit_51_entropy_out;

    wire [63:0] trng_unit_52_entropy_out;

    wire [63:0] trng_unit_53_entropy_out;

    wire [63:0] trng_unit_54_entropy_out;

    wire [63:0] trng_unit_55_entropy_out;

    wire [63:0] trng_unit_56_entropy_out;

    wire [63:0] trng_unit_57_entropy_out;

    wire [63:0] trng_unit_58_entropy_out;

    wire [63:0] trng_unit_59_entropy_out;

    wire [63:0] trng_unit_60_entropy_out;

    wire [63:0] trng_unit_61_entropy_out;

    wire [63:0] trng_unit_62_entropy_out;

    wire [63:0] trng_unit_63_entropy_out;

    // EXPLICIT INSTANTIATION OF ALL 64 TRNG ENTROPY CORES
    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 0
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd0) ) trng_unit_0 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_0_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 1
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd1) ) trng_unit_1 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_1_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 2
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd2) ) trng_unit_2 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_2_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 3
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd3) ) trng_unit_3 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_3_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 4
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd4) ) trng_unit_4 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_4_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 5
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd5) ) trng_unit_5 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_5_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 6
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd6) ) trng_unit_6 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_6_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 7
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd7) ) trng_unit_7 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_7_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 8
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd8) ) trng_unit_8 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_8_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 9
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd9) ) trng_unit_9 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_9_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 10
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd10) ) trng_unit_10 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_10_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 11
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd11) ) trng_unit_11 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_11_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 12
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd12) ) trng_unit_12 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_12_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 13
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd13) ) trng_unit_13 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_13_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 14
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd14) ) trng_unit_14 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_14_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 15
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd15) ) trng_unit_15 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_15_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 16
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd16) ) trng_unit_16 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_16_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 17
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd17) ) trng_unit_17 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_17_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 18
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd18) ) trng_unit_18 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_18_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 19
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd19) ) trng_unit_19 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_19_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 20
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd20) ) trng_unit_20 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_20_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 21
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd21) ) trng_unit_21 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_21_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 22
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd22) ) trng_unit_22 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_22_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 23
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd23) ) trng_unit_23 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_23_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 24
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd24) ) trng_unit_24 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_24_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 25
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd25) ) trng_unit_25 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_25_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 26
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd26) ) trng_unit_26 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_26_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 27
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd27) ) trng_unit_27 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_27_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 28
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd28) ) trng_unit_28 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_28_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 29
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd29) ) trng_unit_29 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_29_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 30
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd30) ) trng_unit_30 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_30_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 31
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd31) ) trng_unit_31 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_31_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 32
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd32) ) trng_unit_32 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_32_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 33
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd33) ) trng_unit_33 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_33_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 34
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd34) ) trng_unit_34 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_34_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 35
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd35) ) trng_unit_35 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_35_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 36
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd36) ) trng_unit_36 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_36_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 37
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd37) ) trng_unit_37 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_37_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 38
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd38) ) trng_unit_38 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_38_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 39
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd39) ) trng_unit_39 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_39_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 40
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd40) ) trng_unit_40 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_40_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 41
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd41) ) trng_unit_41 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_41_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 42
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd42) ) trng_unit_42 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_42_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 43
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd43) ) trng_unit_43 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_43_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 44
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd44) ) trng_unit_44 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_44_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 45
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd45) ) trng_unit_45 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_45_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 46
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd46) ) trng_unit_46 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_46_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 47
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd47) ) trng_unit_47 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_47_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 48
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd48) ) trng_unit_48 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_48_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 49
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd49) ) trng_unit_49 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_49_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 50
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd50) ) trng_unit_50 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_50_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 51
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd51) ) trng_unit_51 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_51_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 52
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd52) ) trng_unit_52 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_52_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 53
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd53) ) trng_unit_53 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_53_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 54
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd54) ) trng_unit_54 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_54_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 55
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd55) ) trng_unit_55 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_55_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 56
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd56) ) trng_unit_56 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_56_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 57
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd57) ) trng_unit_57 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_57_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 58
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd58) ) trng_unit_58 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_58_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 59
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd59) ) trng_unit_59 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_59_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 60
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd60) ) trng_unit_60 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_60_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 61
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd61) ) trng_unit_61 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_61_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 62
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd62) ) trng_unit_62 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_62_entropy_out)
    );

    // ---------------------------------------------------------
    // TRNG ENTROPY CORE 63
    // ---------------------------------------------------------
    garuda_trng_entropy_core #( .ENGINE_ID(6'd63) ) trng_unit_63 (
        .clk(clk_sec),
        .reset_n(rst_n),
        .entropy_out(trng_unit_63_entropy_out)
    );

// =========================================================
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 0
// =========================================================
module garuda_explicit_trng_core_0 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 1
// =========================================================
module garuda_explicit_trng_core_1 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 2
// =========================================================
module garuda_explicit_trng_core_2 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 3
// =========================================================
module garuda_explicit_trng_core_3 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 4
// =========================================================
module garuda_explicit_trng_core_4 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 5
// =========================================================
module garuda_explicit_trng_core_5 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 6
// =========================================================
module garuda_explicit_trng_core_6 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 7
// =========================================================
module garuda_explicit_trng_core_7 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 8
// =========================================================
module garuda_explicit_trng_core_8 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 9
// =========================================================
module garuda_explicit_trng_core_9 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 10
// =========================================================
module garuda_explicit_trng_core_10 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 11
// =========================================================
module garuda_explicit_trng_core_11 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 12
// =========================================================
module garuda_explicit_trng_core_12 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 13
// =========================================================
module garuda_explicit_trng_core_13 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 14
// =========================================================
module garuda_explicit_trng_core_14 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 15
// =========================================================
module garuda_explicit_trng_core_15 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 16
// =========================================================
module garuda_explicit_trng_core_16 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 17
// =========================================================
module garuda_explicit_trng_core_17 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 18
// =========================================================
module garuda_explicit_trng_core_18 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 19
// =========================================================
module garuda_explicit_trng_core_19 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 20
// =========================================================
module garuda_explicit_trng_core_20 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 21
// =========================================================
module garuda_explicit_trng_core_21 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 22
// =========================================================
module garuda_explicit_trng_core_22 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 23
// =========================================================
module garuda_explicit_trng_core_23 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 24
// =========================================================
module garuda_explicit_trng_core_24 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 25
// =========================================================
module garuda_explicit_trng_core_25 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 26
// =========================================================
module garuda_explicit_trng_core_26 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 27
// =========================================================
module garuda_explicit_trng_core_27 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 28
// =========================================================
module garuda_explicit_trng_core_28 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 29
// =========================================================
module garuda_explicit_trng_core_29 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 30
// =========================================================
module garuda_explicit_trng_core_30 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 31
// =========================================================
module garuda_explicit_trng_core_31 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 32
// =========================================================
module garuda_explicit_trng_core_32 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 33
// =========================================================
module garuda_explicit_trng_core_33 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 34
// =========================================================
module garuda_explicit_trng_core_34 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 35
// =========================================================
module garuda_explicit_trng_core_35 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 36
// =========================================================
module garuda_explicit_trng_core_36 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 37
// =========================================================
module garuda_explicit_trng_core_37 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 38
// =========================================================
module garuda_explicit_trng_core_38 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 39
// =========================================================
module garuda_explicit_trng_core_39 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 40
// =========================================================
module garuda_explicit_trng_core_40 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 41
// =========================================================
module garuda_explicit_trng_core_41 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 42
// =========================================================
module garuda_explicit_trng_core_42 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 43
// =========================================================
module garuda_explicit_trng_core_43 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 44
// =========================================================
module garuda_explicit_trng_core_44 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 45
// =========================================================
module garuda_explicit_trng_core_45 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 46
// =========================================================
module garuda_explicit_trng_core_46 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 47
// =========================================================
module garuda_explicit_trng_core_47 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 48
// =========================================================
module garuda_explicit_trng_core_48 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 49
// =========================================================
module garuda_explicit_trng_core_49 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 50
// =========================================================
module garuda_explicit_trng_core_50 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 51
// =========================================================
module garuda_explicit_trng_core_51 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 52
// =========================================================
module garuda_explicit_trng_core_52 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 53
// =========================================================
module garuda_explicit_trng_core_53 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 54
// =========================================================
module garuda_explicit_trng_core_54 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 55
// =========================================================
module garuda_explicit_trng_core_55 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 56
// =========================================================
module garuda_explicit_trng_core_56 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 57
// =========================================================
module garuda_explicit_trng_core_57 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 58
// =========================================================
module garuda_explicit_trng_core_58 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 59
// =========================================================
module garuda_explicit_trng_core_59 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 60
// =========================================================
module garuda_explicit_trng_core_60 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 61
// =========================================================
module garuda_explicit_trng_core_61 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 62
// =========================================================
module garuda_explicit_trng_core_62 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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
// EXPLICIT TRNG HARDWARE SUBSYSTEM: ENTROPY CORE 63
// =========================================================
module garuda_explicit_trng_core_63 (
    input wire clk, reset_n,
    output reg [63:0] entropy_out
);
    reg [63:0] register_file [0:63];
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