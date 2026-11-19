// =========================================================================
// GARUDA GPU v1.0 ULTIMATE - 64-Core Ray-Tracing (Fully Unrolled Verilog RTL)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================================

`default_nettype none

module garuda_gpu_top (
    input wire clk_gpu, clk_mem, rst_n,
    output wire hdmi_tx_p, hdmi_tx_n,
    output wire [3:0] dp_tx_p, dp_tx_n,
    input wire [21:0] pll_ref_clks,
    output wire [223:0] gddr6_ca,
    output wire [15:0] gddr6_cs_n,
    output wire [31:0] gddr6_ck_p, gddr6_ck_n,
    inout wire [1023:0] gddr6_dq,
    inout wire [127:0] gddr6_dqs_p, gddr6_dqs_n,
    input wire [7:0] pcie_refclk_p, pcie_refclk_n,
    output wire [127:0] pcie_tx_p, pcie_tx_n,
    input wire [127:0] pcie_rx_p, pcie_rx_n,
    inout wire [1023:0] ucie_die_to_die_link,
    inout wire [63:0] general_purpose_io,
    output wire [31:0] gpu_status_flags, frame_counter,
    inout wire [1199:0] VDD_GPU,
    inout wire [599:0] VDD_MEM,
    inout wire [279:0] VDD_IO,
    inout wire [799:0] VSS_GND
);

    // EXPLICIT SHADER WIRES FOR ALL 64 INDIVIDUAL GPU CORES
    wire [255:0] sm_0_shader_output;
    wire sm_0_halt;

    wire [255:0] sm_1_shader_output;
    wire sm_1_halt;

    wire [255:0] sm_2_shader_output;
    wire sm_2_halt;

    wire [255:0] sm_3_shader_output;
    wire sm_3_halt;

    wire [255:0] sm_4_shader_output;
    wire sm_4_halt;

    wire [255:0] sm_5_shader_output;
    wire sm_5_halt;

    wire [255:0] sm_6_shader_output;
    wire sm_6_halt;

    wire [255:0] sm_7_shader_output;
    wire sm_7_halt;

    wire [255:0] sm_8_shader_output;
    wire sm_8_halt;

    wire [255:0] sm_9_shader_output;
    wire sm_9_halt;

    wire [255:0] sm_10_shader_output;
    wire sm_10_halt;

    wire [255:0] sm_11_shader_output;
    wire sm_11_halt;

    wire [255:0] sm_12_shader_output;
    wire sm_12_halt;

    wire [255:0] sm_13_shader_output;
    wire sm_13_halt;

    wire [255:0] sm_14_shader_output;
    wire sm_14_halt;

    wire [255:0] sm_15_shader_output;
    wire sm_15_halt;

    wire [255:0] sm_16_shader_output;
    wire sm_16_halt;

    wire [255:0] sm_17_shader_output;
    wire sm_17_halt;

    wire [255:0] sm_18_shader_output;
    wire sm_18_halt;

    wire [255:0] sm_19_shader_output;
    wire sm_19_halt;

    wire [255:0] sm_20_shader_output;
    wire sm_20_halt;

    wire [255:0] sm_21_shader_output;
    wire sm_21_halt;

    wire [255:0] sm_22_shader_output;
    wire sm_22_halt;

    wire [255:0] sm_23_shader_output;
    wire sm_23_halt;

    wire [255:0] sm_24_shader_output;
    wire sm_24_halt;

    wire [255:0] sm_25_shader_output;
    wire sm_25_halt;

    wire [255:0] sm_26_shader_output;
    wire sm_26_halt;

    wire [255:0] sm_27_shader_output;
    wire sm_27_halt;

    wire [255:0] sm_28_shader_output;
    wire sm_28_halt;

    wire [255:0] sm_29_shader_output;
    wire sm_29_halt;

    wire [255:0] sm_30_shader_output;
    wire sm_30_halt;

    wire [255:0] sm_31_shader_output;
    wire sm_31_halt;

    wire [255:0] sm_32_shader_output;
    wire sm_32_halt;

    wire [255:0] sm_33_shader_output;
    wire sm_33_halt;

    wire [255:0] sm_34_shader_output;
    wire sm_34_halt;

    wire [255:0] sm_35_shader_output;
    wire sm_35_halt;

    wire [255:0] sm_36_shader_output;
    wire sm_36_halt;

    wire [255:0] sm_37_shader_output;
    wire sm_37_halt;

    wire [255:0] sm_38_shader_output;
    wire sm_38_halt;

    wire [255:0] sm_39_shader_output;
    wire sm_39_halt;

    wire [255:0] sm_40_shader_output;
    wire sm_40_halt;

    wire [255:0] sm_41_shader_output;
    wire sm_41_halt;

    wire [255:0] sm_42_shader_output;
    wire sm_42_halt;

    wire [255:0] sm_43_shader_output;
    wire sm_43_halt;

    wire [255:0] sm_44_shader_output;
    wire sm_44_halt;

    wire [255:0] sm_45_shader_output;
    wire sm_45_halt;

    wire [255:0] sm_46_shader_output;
    wire sm_46_halt;

    wire [255:0] sm_47_shader_output;
    wire sm_47_halt;

    wire [255:0] sm_48_shader_output;
    wire sm_48_halt;

    wire [255:0] sm_49_shader_output;
    wire sm_49_halt;

    wire [255:0] sm_50_shader_output;
    wire sm_50_halt;

    wire [255:0] sm_51_shader_output;
    wire sm_51_halt;

    wire [255:0] sm_52_shader_output;
    wire sm_52_halt;

    wire [255:0] sm_53_shader_output;
    wire sm_53_halt;

    wire [255:0] sm_54_shader_output;
    wire sm_54_halt;

    wire [255:0] sm_55_shader_output;
    wire sm_55_halt;

    wire [255:0] sm_56_shader_output;
    wire sm_56_halt;

    wire [255:0] sm_57_shader_output;
    wire sm_57_halt;

    wire [255:0] sm_58_shader_output;
    wire sm_58_halt;

    wire [255:0] sm_59_shader_output;
    wire sm_59_halt;

    wire [255:0] sm_60_shader_output;
    wire sm_60_halt;

    wire [255:0] sm_61_shader_output;
    wire sm_61_halt;

    wire [255:0] sm_62_shader_output;
    wire sm_62_halt;

    wire [255:0] sm_63_shader_output;
    wire sm_63_halt;

    // EXPLICIT INSTANTIATION OF ALL 64 STREAMING MULTIPROCESSORS (SM)
    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 0 (RAY-TRACING CORE 0)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd0) ) sm_unit_0 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_0_shader_output),
        .halted(sm_0_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 1 (RAY-TRACING CORE 1)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd1) ) sm_unit_1 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_1_shader_output),
        .halted(sm_1_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 2 (RAY-TRACING CORE 2)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd2) ) sm_unit_2 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_2_shader_output),
        .halted(sm_2_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 3 (RAY-TRACING CORE 3)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd3) ) sm_unit_3 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_3_shader_output),
        .halted(sm_3_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 4 (RAY-TRACING CORE 4)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd4) ) sm_unit_4 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_4_shader_output),
        .halted(sm_4_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 5 (RAY-TRACING CORE 5)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd5) ) sm_unit_5 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_5_shader_output),
        .halted(sm_5_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 6 (RAY-TRACING CORE 6)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd6) ) sm_unit_6 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_6_shader_output),
        .halted(sm_6_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 7 (RAY-TRACING CORE 7)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd7) ) sm_unit_7 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_7_shader_output),
        .halted(sm_7_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 8 (RAY-TRACING CORE 8)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd8) ) sm_unit_8 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_8_shader_output),
        .halted(sm_8_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 9 (RAY-TRACING CORE 9)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd9) ) sm_unit_9 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_9_shader_output),
        .halted(sm_9_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 10 (RAY-TRACING CORE 10)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd10) ) sm_unit_10 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_10_shader_output),
        .halted(sm_10_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 11 (RAY-TRACING CORE 11)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd11) ) sm_unit_11 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_11_shader_output),
        .halted(sm_11_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 12 (RAY-TRACING CORE 12)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd12) ) sm_unit_12 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_12_shader_output),
        .halted(sm_12_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 13 (RAY-TRACING CORE 13)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd13) ) sm_unit_13 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_13_shader_output),
        .halted(sm_13_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 14 (RAY-TRACING CORE 14)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd14) ) sm_unit_14 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_14_shader_output),
        .halted(sm_14_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 15 (RAY-TRACING CORE 15)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd15) ) sm_unit_15 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_15_shader_output),
        .halted(sm_15_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 16 (RAY-TRACING CORE 16)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd16) ) sm_unit_16 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_16_shader_output),
        .halted(sm_16_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 17 (RAY-TRACING CORE 17)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd17) ) sm_unit_17 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_17_shader_output),
        .halted(sm_17_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 18 (RAY-TRACING CORE 18)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd18) ) sm_unit_18 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_18_shader_output),
        .halted(sm_18_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 19 (RAY-TRACING CORE 19)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd19) ) sm_unit_19 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_19_shader_output),
        .halted(sm_19_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 20 (RAY-TRACING CORE 20)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd20) ) sm_unit_20 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_20_shader_output),
        .halted(sm_20_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 21 (RAY-TRACING CORE 21)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd21) ) sm_unit_21 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_21_shader_output),
        .halted(sm_21_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 22 (RAY-TRACING CORE 22)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd22) ) sm_unit_22 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_22_shader_output),
        .halted(sm_22_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 23 (RAY-TRACING CORE 23)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd23) ) sm_unit_23 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_23_shader_output),
        .halted(sm_23_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 24 (RAY-TRACING CORE 24)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd24) ) sm_unit_24 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_24_shader_output),
        .halted(sm_24_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 25 (RAY-TRACING CORE 25)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd25) ) sm_unit_25 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_25_shader_output),
        .halted(sm_25_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 26 (RAY-TRACING CORE 26)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd26) ) sm_unit_26 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_26_shader_output),
        .halted(sm_26_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 27 (RAY-TRACING CORE 27)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd27) ) sm_unit_27 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_27_shader_output),
        .halted(sm_27_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 28 (RAY-TRACING CORE 28)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd28) ) sm_unit_28 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_28_shader_output),
        .halted(sm_28_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 29 (RAY-TRACING CORE 29)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd29) ) sm_unit_29 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_29_shader_output),
        .halted(sm_29_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 30 (RAY-TRACING CORE 30)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd30) ) sm_unit_30 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_30_shader_output),
        .halted(sm_30_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 31 (RAY-TRACING CORE 31)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd31) ) sm_unit_31 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_31_shader_output),
        .halted(sm_31_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 32 (RAY-TRACING CORE 32)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd32) ) sm_unit_32 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_32_shader_output),
        .halted(sm_32_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 33 (RAY-TRACING CORE 33)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd33) ) sm_unit_33 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_33_shader_output),
        .halted(sm_33_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 34 (RAY-TRACING CORE 34)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd34) ) sm_unit_34 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_34_shader_output),
        .halted(sm_34_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 35 (RAY-TRACING CORE 35)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd35) ) sm_unit_35 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_35_shader_output),
        .halted(sm_35_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 36 (RAY-TRACING CORE 36)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd36) ) sm_unit_36 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_36_shader_output),
        .halted(sm_36_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 37 (RAY-TRACING CORE 37)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd37) ) sm_unit_37 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_37_shader_output),
        .halted(sm_37_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 38 (RAY-TRACING CORE 38)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd38) ) sm_unit_38 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_38_shader_output),
        .halted(sm_38_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 39 (RAY-TRACING CORE 39)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd39) ) sm_unit_39 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_39_shader_output),
        .halted(sm_39_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 40 (RAY-TRACING CORE 40)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd40) ) sm_unit_40 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_40_shader_output),
        .halted(sm_40_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 41 (RAY-TRACING CORE 41)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd41) ) sm_unit_41 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_41_shader_output),
        .halted(sm_41_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 42 (RAY-TRACING CORE 42)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd42) ) sm_unit_42 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_42_shader_output),
        .halted(sm_42_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 43 (RAY-TRACING CORE 43)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd43) ) sm_unit_43 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_43_shader_output),
        .halted(sm_43_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 44 (RAY-TRACING CORE 44)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd44) ) sm_unit_44 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_44_shader_output),
        .halted(sm_44_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 45 (RAY-TRACING CORE 45)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd45) ) sm_unit_45 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_45_shader_output),
        .halted(sm_45_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 46 (RAY-TRACING CORE 46)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd46) ) sm_unit_46 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_46_shader_output),
        .halted(sm_46_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 47 (RAY-TRACING CORE 47)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd47) ) sm_unit_47 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_47_shader_output),
        .halted(sm_47_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 48 (RAY-TRACING CORE 48)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd48) ) sm_unit_48 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_48_shader_output),
        .halted(sm_48_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 49 (RAY-TRACING CORE 49)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd49) ) sm_unit_49 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_49_shader_output),
        .halted(sm_49_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 50 (RAY-TRACING CORE 50)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd50) ) sm_unit_50 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_50_shader_output),
        .halted(sm_50_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 51 (RAY-TRACING CORE 51)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd51) ) sm_unit_51 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_51_shader_output),
        .halted(sm_51_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 52 (RAY-TRACING CORE 52)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd52) ) sm_unit_52 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_52_shader_output),
        .halted(sm_52_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 53 (RAY-TRACING CORE 53)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd53) ) sm_unit_53 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_53_shader_output),
        .halted(sm_53_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 54 (RAY-TRACING CORE 54)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd54) ) sm_unit_54 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_54_shader_output),
        .halted(sm_54_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 55 (RAY-TRACING CORE 55)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd55) ) sm_unit_55 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_55_shader_output),
        .halted(sm_55_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 56 (RAY-TRACING CORE 56)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd56) ) sm_unit_56 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_56_shader_output),
        .halted(sm_56_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 57 (RAY-TRACING CORE 57)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd57) ) sm_unit_57 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_57_shader_output),
        .halted(sm_57_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 58 (RAY-TRACING CORE 58)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd58) ) sm_unit_58 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_58_shader_output),
        .halted(sm_58_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 59 (RAY-TRACING CORE 59)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd59) ) sm_unit_59 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_59_shader_output),
        .halted(sm_59_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 60 (RAY-TRACING CORE 60)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd60) ) sm_unit_60 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_60_shader_output),
        .halted(sm_60_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 61 (RAY-TRACING CORE 61)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd61) ) sm_unit_61 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_61_shader_output),
        .halted(sm_61_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 62 (RAY-TRACING CORE 62)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd62) ) sm_unit_62 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_62_shader_output),
        .halted(sm_62_halt)
    );

    // ---------------------------------------------------------
    // GPU STREAMING MULTIPROCESSOR 63 (RAY-TRACING CORE 63)
    // ---------------------------------------------------------
    garuda_gpu_sm_core #( .SM_ID(6'd63) ) sm_unit_63 (
        .clk(clk_gpu),
        .reset_n(rst_n),
        .shader_out(sm_63_shader_output),
        .halted(sm_63_halt)
    );

// =========================================================
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 0
// =========================================================
module garuda_explicit_sm_core_0 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 1
// =========================================================
module garuda_explicit_sm_core_1 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 2
// =========================================================
module garuda_explicit_sm_core_2 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 3
// =========================================================
module garuda_explicit_sm_core_3 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 4
// =========================================================
module garuda_explicit_sm_core_4 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 5
// =========================================================
module garuda_explicit_sm_core_5 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 6
// =========================================================
module garuda_explicit_sm_core_6 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 7
// =========================================================
module garuda_explicit_sm_core_7 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 8
// =========================================================
module garuda_explicit_sm_core_8 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 9
// =========================================================
module garuda_explicit_sm_core_9 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 10
// =========================================================
module garuda_explicit_sm_core_10 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 11
// =========================================================
module garuda_explicit_sm_core_11 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 12
// =========================================================
module garuda_explicit_sm_core_12 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 13
// =========================================================
module garuda_explicit_sm_core_13 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 14
// =========================================================
module garuda_explicit_sm_core_14 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 15
// =========================================================
module garuda_explicit_sm_core_15 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 16
// =========================================================
module garuda_explicit_sm_core_16 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 17
// =========================================================
module garuda_explicit_sm_core_17 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 18
// =========================================================
module garuda_explicit_sm_core_18 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 19
// =========================================================
module garuda_explicit_sm_core_19 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 20
// =========================================================
module garuda_explicit_sm_core_20 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 21
// =========================================================
module garuda_explicit_sm_core_21 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 22
// =========================================================
module garuda_explicit_sm_core_22 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 23
// =========================================================
module garuda_explicit_sm_core_23 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 24
// =========================================================
module garuda_explicit_sm_core_24 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 25
// =========================================================
module garuda_explicit_sm_core_25 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 26
// =========================================================
module garuda_explicit_sm_core_26 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 27
// =========================================================
module garuda_explicit_sm_core_27 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 28
// =========================================================
module garuda_explicit_sm_core_28 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 29
// =========================================================
module garuda_explicit_sm_core_29 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 30
// =========================================================
module garuda_explicit_sm_core_30 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 31
// =========================================================
module garuda_explicit_sm_core_31 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 32
// =========================================================
module garuda_explicit_sm_core_32 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 33
// =========================================================
module garuda_explicit_sm_core_33 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 34
// =========================================================
module garuda_explicit_sm_core_34 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 35
// =========================================================
module garuda_explicit_sm_core_35 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 36
// =========================================================
module garuda_explicit_sm_core_36 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 37
// =========================================================
module garuda_explicit_sm_core_37 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 38
// =========================================================
module garuda_explicit_sm_core_38 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 39
// =========================================================
module garuda_explicit_sm_core_39 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 40
// =========================================================
module garuda_explicit_sm_core_40 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 41
// =========================================================
module garuda_explicit_sm_core_41 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 42
// =========================================================
module garuda_explicit_sm_core_42 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 43
// =========================================================
module garuda_explicit_sm_core_43 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 44
// =========================================================
module garuda_explicit_sm_core_44 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 45
// =========================================================
module garuda_explicit_sm_core_45 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 46
// =========================================================
module garuda_explicit_sm_core_46 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 47
// =========================================================
module garuda_explicit_sm_core_47 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 48
// =========================================================
module garuda_explicit_sm_core_48 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 49
// =========================================================
module garuda_explicit_sm_core_49 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 50
// =========================================================
module garuda_explicit_sm_core_50 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 51
// =========================================================
module garuda_explicit_sm_core_51 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 52
// =========================================================
module garuda_explicit_sm_core_52 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 53
// =========================================================
module garuda_explicit_sm_core_53 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 54
// =========================================================
module garuda_explicit_sm_core_54 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 55
// =========================================================
module garuda_explicit_sm_core_55 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 56
// =========================================================
module garuda_explicit_sm_core_56 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 57
// =========================================================
module garuda_explicit_sm_core_57 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 58
// =========================================================
module garuda_explicit_sm_core_58 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 59
// =========================================================
module garuda_explicit_sm_core_59 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 60
// =========================================================
module garuda_explicit_sm_core_60 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 61
// =========================================================
module garuda_explicit_sm_core_61 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 62
// =========================================================
module garuda_explicit_sm_core_62 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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
// EXPLICIT GPU SHADER HARDWARE SUBSYSTEM: SM CORE 63
// =========================================================
module garuda_explicit_sm_core_63 (
    input wire clk, reset_n,
    output reg [255:0] shader_out,
    output reg halted
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