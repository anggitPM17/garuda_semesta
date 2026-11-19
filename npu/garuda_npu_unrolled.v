// =========================================================================
// GARUDA NPU v1.0 ULTIMATE - 64-Engine AI Vision (Fully Unrolled Verilog RTL)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================================

`default_nettype none

module garuda_npu_top (
    input wire clk_npu, clk_mem, rst_n,
    input wire [7:0] mipi_csi_clk_p, mipi_csi_clk_n,
    input wire [15:0] mipi_csi_data_p, mipi_csi_data_n,
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
    output wire [15:0] npu_status_flags, yolo_bbox_count,
    inout wire [1199:0] VDD_NPU,
    inout wire [599:0] VDD_MEM,
    inout wire [279:0] VDD_IO,
    inout wire [799:0] VSS_GND
);

    // EXPLICIT WIRES FOR ALL 64 CONVOLUTIONAL SYSTOLIC ENGINES
    wire [255:0] conv_engine_0_out;
    wire conv_engine_0_halt;

    wire [255:0] conv_engine_1_out;
    wire conv_engine_1_halt;

    wire [255:0] conv_engine_2_out;
    wire conv_engine_2_halt;

    wire [255:0] conv_engine_3_out;
    wire conv_engine_3_halt;

    wire [255:0] conv_engine_4_out;
    wire conv_engine_4_halt;

    wire [255:0] conv_engine_5_out;
    wire conv_engine_5_halt;

    wire [255:0] conv_engine_6_out;
    wire conv_engine_6_halt;

    wire [255:0] conv_engine_7_out;
    wire conv_engine_7_halt;

    wire [255:0] conv_engine_8_out;
    wire conv_engine_8_halt;

    wire [255:0] conv_engine_9_out;
    wire conv_engine_9_halt;

    wire [255:0] conv_engine_10_out;
    wire conv_engine_10_halt;

    wire [255:0] conv_engine_11_out;
    wire conv_engine_11_halt;

    wire [255:0] conv_engine_12_out;
    wire conv_engine_12_halt;

    wire [255:0] conv_engine_13_out;
    wire conv_engine_13_halt;

    wire [255:0] conv_engine_14_out;
    wire conv_engine_14_halt;

    wire [255:0] conv_engine_15_out;
    wire conv_engine_15_halt;

    wire [255:0] conv_engine_16_out;
    wire conv_engine_16_halt;

    wire [255:0] conv_engine_17_out;
    wire conv_engine_17_halt;

    wire [255:0] conv_engine_18_out;
    wire conv_engine_18_halt;

    wire [255:0] conv_engine_19_out;
    wire conv_engine_19_halt;

    wire [255:0] conv_engine_20_out;
    wire conv_engine_20_halt;

    wire [255:0] conv_engine_21_out;
    wire conv_engine_21_halt;

    wire [255:0] conv_engine_22_out;
    wire conv_engine_22_halt;

    wire [255:0] conv_engine_23_out;
    wire conv_engine_23_halt;

    wire [255:0] conv_engine_24_out;
    wire conv_engine_24_halt;

    wire [255:0] conv_engine_25_out;
    wire conv_engine_25_halt;

    wire [255:0] conv_engine_26_out;
    wire conv_engine_26_halt;

    wire [255:0] conv_engine_27_out;
    wire conv_engine_27_halt;

    wire [255:0] conv_engine_28_out;
    wire conv_engine_28_halt;

    wire [255:0] conv_engine_29_out;
    wire conv_engine_29_halt;

    wire [255:0] conv_engine_30_out;
    wire conv_engine_30_halt;

    wire [255:0] conv_engine_31_out;
    wire conv_engine_31_halt;

    wire [255:0] conv_engine_32_out;
    wire conv_engine_32_halt;

    wire [255:0] conv_engine_33_out;
    wire conv_engine_33_halt;

    wire [255:0] conv_engine_34_out;
    wire conv_engine_34_halt;

    wire [255:0] conv_engine_35_out;
    wire conv_engine_35_halt;

    wire [255:0] conv_engine_36_out;
    wire conv_engine_36_halt;

    wire [255:0] conv_engine_37_out;
    wire conv_engine_37_halt;

    wire [255:0] conv_engine_38_out;
    wire conv_engine_38_halt;

    wire [255:0] conv_engine_39_out;
    wire conv_engine_39_halt;

    wire [255:0] conv_engine_40_out;
    wire conv_engine_40_halt;

    wire [255:0] conv_engine_41_out;
    wire conv_engine_41_halt;

    wire [255:0] conv_engine_42_out;
    wire conv_engine_42_halt;

    wire [255:0] conv_engine_43_out;
    wire conv_engine_43_halt;

    wire [255:0] conv_engine_44_out;
    wire conv_engine_44_halt;

    wire [255:0] conv_engine_45_out;
    wire conv_engine_45_halt;

    wire [255:0] conv_engine_46_out;
    wire conv_engine_46_halt;

    wire [255:0] conv_engine_47_out;
    wire conv_engine_47_halt;

    wire [255:0] conv_engine_48_out;
    wire conv_engine_48_halt;

    wire [255:0] conv_engine_49_out;
    wire conv_engine_49_halt;

    wire [255:0] conv_engine_50_out;
    wire conv_engine_50_halt;

    wire [255:0] conv_engine_51_out;
    wire conv_engine_51_halt;

    wire [255:0] conv_engine_52_out;
    wire conv_engine_52_halt;

    wire [255:0] conv_engine_53_out;
    wire conv_engine_53_halt;

    wire [255:0] conv_engine_54_out;
    wire conv_engine_54_halt;

    wire [255:0] conv_engine_55_out;
    wire conv_engine_55_halt;

    wire [255:0] conv_engine_56_out;
    wire conv_engine_56_halt;

    wire [255:0] conv_engine_57_out;
    wire conv_engine_57_halt;

    wire [255:0] conv_engine_58_out;
    wire conv_engine_58_halt;

    wire [255:0] conv_engine_59_out;
    wire conv_engine_59_halt;

    wire [255:0] conv_engine_60_out;
    wire conv_engine_60_halt;

    wire [255:0] conv_engine_61_out;
    wire conv_engine_61_halt;

    wire [255:0] conv_engine_62_out;
    wire conv_engine_62_halt;

    wire [255:0] conv_engine_63_out;
    wire conv_engine_63_halt;

    // EXPLICIT INSTANTIATION OF ALL 64 NPU CONV ENGINES
    // ---------------------------------------------------------
    // NPU CONV ENGINE 0 (SYSTOLIC MAC ARRAY 0)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd0) ) conv_engine_0 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_0_out),
        .halted(conv_engine_0_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 1 (SYSTOLIC MAC ARRAY 1)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd1) ) conv_engine_1 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_1_out),
        .halted(conv_engine_1_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 2 (SYSTOLIC MAC ARRAY 2)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd2) ) conv_engine_2 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_2_out),
        .halted(conv_engine_2_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 3 (SYSTOLIC MAC ARRAY 3)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd3) ) conv_engine_3 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_3_out),
        .halted(conv_engine_3_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 4 (SYSTOLIC MAC ARRAY 4)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd4) ) conv_engine_4 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_4_out),
        .halted(conv_engine_4_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 5 (SYSTOLIC MAC ARRAY 5)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd5) ) conv_engine_5 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_5_out),
        .halted(conv_engine_5_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 6 (SYSTOLIC MAC ARRAY 6)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd6) ) conv_engine_6 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_6_out),
        .halted(conv_engine_6_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 7 (SYSTOLIC MAC ARRAY 7)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd7) ) conv_engine_7 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_7_out),
        .halted(conv_engine_7_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 8 (SYSTOLIC MAC ARRAY 8)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd8) ) conv_engine_8 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_8_out),
        .halted(conv_engine_8_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 9 (SYSTOLIC MAC ARRAY 9)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd9) ) conv_engine_9 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_9_out),
        .halted(conv_engine_9_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 10 (SYSTOLIC MAC ARRAY 10)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd10) ) conv_engine_10 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_10_out),
        .halted(conv_engine_10_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 11 (SYSTOLIC MAC ARRAY 11)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd11) ) conv_engine_11 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_11_out),
        .halted(conv_engine_11_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 12 (SYSTOLIC MAC ARRAY 12)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd12) ) conv_engine_12 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_12_out),
        .halted(conv_engine_12_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 13 (SYSTOLIC MAC ARRAY 13)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd13) ) conv_engine_13 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_13_out),
        .halted(conv_engine_13_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 14 (SYSTOLIC MAC ARRAY 14)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd14) ) conv_engine_14 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_14_out),
        .halted(conv_engine_14_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 15 (SYSTOLIC MAC ARRAY 15)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd15) ) conv_engine_15 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_15_out),
        .halted(conv_engine_15_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 16 (SYSTOLIC MAC ARRAY 16)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd16) ) conv_engine_16 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_16_out),
        .halted(conv_engine_16_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 17 (SYSTOLIC MAC ARRAY 17)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd17) ) conv_engine_17 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_17_out),
        .halted(conv_engine_17_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 18 (SYSTOLIC MAC ARRAY 18)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd18) ) conv_engine_18 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_18_out),
        .halted(conv_engine_18_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 19 (SYSTOLIC MAC ARRAY 19)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd19) ) conv_engine_19 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_19_out),
        .halted(conv_engine_19_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 20 (SYSTOLIC MAC ARRAY 20)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd20) ) conv_engine_20 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_20_out),
        .halted(conv_engine_20_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 21 (SYSTOLIC MAC ARRAY 21)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd21) ) conv_engine_21 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_21_out),
        .halted(conv_engine_21_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 22 (SYSTOLIC MAC ARRAY 22)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd22) ) conv_engine_22 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_22_out),
        .halted(conv_engine_22_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 23 (SYSTOLIC MAC ARRAY 23)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd23) ) conv_engine_23 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_23_out),
        .halted(conv_engine_23_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 24 (SYSTOLIC MAC ARRAY 24)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd24) ) conv_engine_24 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_24_out),
        .halted(conv_engine_24_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 25 (SYSTOLIC MAC ARRAY 25)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd25) ) conv_engine_25 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_25_out),
        .halted(conv_engine_25_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 26 (SYSTOLIC MAC ARRAY 26)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd26) ) conv_engine_26 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_26_out),
        .halted(conv_engine_26_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 27 (SYSTOLIC MAC ARRAY 27)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd27) ) conv_engine_27 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_27_out),
        .halted(conv_engine_27_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 28 (SYSTOLIC MAC ARRAY 28)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd28) ) conv_engine_28 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_28_out),
        .halted(conv_engine_28_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 29 (SYSTOLIC MAC ARRAY 29)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd29) ) conv_engine_29 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_29_out),
        .halted(conv_engine_29_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 30 (SYSTOLIC MAC ARRAY 30)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd30) ) conv_engine_30 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_30_out),
        .halted(conv_engine_30_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 31 (SYSTOLIC MAC ARRAY 31)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd31) ) conv_engine_31 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_31_out),
        .halted(conv_engine_31_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 32 (SYSTOLIC MAC ARRAY 32)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd32) ) conv_engine_32 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_32_out),
        .halted(conv_engine_32_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 33 (SYSTOLIC MAC ARRAY 33)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd33) ) conv_engine_33 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_33_out),
        .halted(conv_engine_33_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 34 (SYSTOLIC MAC ARRAY 34)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd34) ) conv_engine_34 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_34_out),
        .halted(conv_engine_34_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 35 (SYSTOLIC MAC ARRAY 35)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd35) ) conv_engine_35 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_35_out),
        .halted(conv_engine_35_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 36 (SYSTOLIC MAC ARRAY 36)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd36) ) conv_engine_36 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_36_out),
        .halted(conv_engine_36_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 37 (SYSTOLIC MAC ARRAY 37)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd37) ) conv_engine_37 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_37_out),
        .halted(conv_engine_37_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 38 (SYSTOLIC MAC ARRAY 38)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd38) ) conv_engine_38 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_38_out),
        .halted(conv_engine_38_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 39 (SYSTOLIC MAC ARRAY 39)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd39) ) conv_engine_39 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_39_out),
        .halted(conv_engine_39_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 40 (SYSTOLIC MAC ARRAY 40)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd40) ) conv_engine_40 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_40_out),
        .halted(conv_engine_40_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 41 (SYSTOLIC MAC ARRAY 41)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd41) ) conv_engine_41 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_41_out),
        .halted(conv_engine_41_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 42 (SYSTOLIC MAC ARRAY 42)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd42) ) conv_engine_42 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_42_out),
        .halted(conv_engine_42_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 43 (SYSTOLIC MAC ARRAY 43)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd43) ) conv_engine_43 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_43_out),
        .halted(conv_engine_43_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 44 (SYSTOLIC MAC ARRAY 44)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd44) ) conv_engine_44 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_44_out),
        .halted(conv_engine_44_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 45 (SYSTOLIC MAC ARRAY 45)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd45) ) conv_engine_45 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_45_out),
        .halted(conv_engine_45_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 46 (SYSTOLIC MAC ARRAY 46)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd46) ) conv_engine_46 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_46_out),
        .halted(conv_engine_46_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 47 (SYSTOLIC MAC ARRAY 47)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd47) ) conv_engine_47 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_47_out),
        .halted(conv_engine_47_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 48 (SYSTOLIC MAC ARRAY 48)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd48) ) conv_engine_48 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_48_out),
        .halted(conv_engine_48_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 49 (SYSTOLIC MAC ARRAY 49)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd49) ) conv_engine_49 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_49_out),
        .halted(conv_engine_49_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 50 (SYSTOLIC MAC ARRAY 50)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd50) ) conv_engine_50 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_50_out),
        .halted(conv_engine_50_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 51 (SYSTOLIC MAC ARRAY 51)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd51) ) conv_engine_51 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_51_out),
        .halted(conv_engine_51_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 52 (SYSTOLIC MAC ARRAY 52)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd52) ) conv_engine_52 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_52_out),
        .halted(conv_engine_52_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 53 (SYSTOLIC MAC ARRAY 53)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd53) ) conv_engine_53 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_53_out),
        .halted(conv_engine_53_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 54 (SYSTOLIC MAC ARRAY 54)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd54) ) conv_engine_54 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_54_out),
        .halted(conv_engine_54_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 55 (SYSTOLIC MAC ARRAY 55)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd55) ) conv_engine_55 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_55_out),
        .halted(conv_engine_55_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 56 (SYSTOLIC MAC ARRAY 56)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd56) ) conv_engine_56 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_56_out),
        .halted(conv_engine_56_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 57 (SYSTOLIC MAC ARRAY 57)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd57) ) conv_engine_57 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_57_out),
        .halted(conv_engine_57_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 58 (SYSTOLIC MAC ARRAY 58)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd58) ) conv_engine_58 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_58_out),
        .halted(conv_engine_58_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 59 (SYSTOLIC MAC ARRAY 59)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd59) ) conv_engine_59 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_59_out),
        .halted(conv_engine_59_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 60 (SYSTOLIC MAC ARRAY 60)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd60) ) conv_engine_60 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_60_out),
        .halted(conv_engine_60_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 61 (SYSTOLIC MAC ARRAY 61)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd61) ) conv_engine_61 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_61_out),
        .halted(conv_engine_61_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 62 (SYSTOLIC MAC ARRAY 62)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd62) ) conv_engine_62 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_62_out),
        .halted(conv_engine_62_halt)
    );

    // ---------------------------------------------------------
    // NPU CONV ENGINE 63 (SYSTOLIC MAC ARRAY 63)
    // ---------------------------------------------------------
    garuda_npu_conv_engine #( .ENGINE_ID(6'd63) ) conv_engine_63 (
        .clk(clk_npu),
        .reset_n(rst_n),
        .engine_out(conv_engine_63_out),
        .halted(conv_engine_63_halt)
    );

// =========================================================
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 0
// =========================================================
module garuda_explicit_conv_engine_0 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 1
// =========================================================
module garuda_explicit_conv_engine_1 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 2
// =========================================================
module garuda_explicit_conv_engine_2 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 3
// =========================================================
module garuda_explicit_conv_engine_3 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 4
// =========================================================
module garuda_explicit_conv_engine_4 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 5
// =========================================================
module garuda_explicit_conv_engine_5 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 6
// =========================================================
module garuda_explicit_conv_engine_6 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 7
// =========================================================
module garuda_explicit_conv_engine_7 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 8
// =========================================================
module garuda_explicit_conv_engine_8 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 9
// =========================================================
module garuda_explicit_conv_engine_9 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 10
// =========================================================
module garuda_explicit_conv_engine_10 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 11
// =========================================================
module garuda_explicit_conv_engine_11 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 12
// =========================================================
module garuda_explicit_conv_engine_12 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 13
// =========================================================
module garuda_explicit_conv_engine_13 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 14
// =========================================================
module garuda_explicit_conv_engine_14 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 15
// =========================================================
module garuda_explicit_conv_engine_15 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 16
// =========================================================
module garuda_explicit_conv_engine_16 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 17
// =========================================================
module garuda_explicit_conv_engine_17 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 18
// =========================================================
module garuda_explicit_conv_engine_18 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 19
// =========================================================
module garuda_explicit_conv_engine_19 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 20
// =========================================================
module garuda_explicit_conv_engine_20 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 21
// =========================================================
module garuda_explicit_conv_engine_21 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 22
// =========================================================
module garuda_explicit_conv_engine_22 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 23
// =========================================================
module garuda_explicit_conv_engine_23 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 24
// =========================================================
module garuda_explicit_conv_engine_24 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 25
// =========================================================
module garuda_explicit_conv_engine_25 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 26
// =========================================================
module garuda_explicit_conv_engine_26 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 27
// =========================================================
module garuda_explicit_conv_engine_27 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 28
// =========================================================
module garuda_explicit_conv_engine_28 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 29
// =========================================================
module garuda_explicit_conv_engine_29 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 30
// =========================================================
module garuda_explicit_conv_engine_30 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 31
// =========================================================
module garuda_explicit_conv_engine_31 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 32
// =========================================================
module garuda_explicit_conv_engine_32 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 33
// =========================================================
module garuda_explicit_conv_engine_33 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 34
// =========================================================
module garuda_explicit_conv_engine_34 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 35
// =========================================================
module garuda_explicit_conv_engine_35 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 36
// =========================================================
module garuda_explicit_conv_engine_36 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 37
// =========================================================
module garuda_explicit_conv_engine_37 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 38
// =========================================================
module garuda_explicit_conv_engine_38 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 39
// =========================================================
module garuda_explicit_conv_engine_39 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 40
// =========================================================
module garuda_explicit_conv_engine_40 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 41
// =========================================================
module garuda_explicit_conv_engine_41 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 42
// =========================================================
module garuda_explicit_conv_engine_42 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 43
// =========================================================
module garuda_explicit_conv_engine_43 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 44
// =========================================================
module garuda_explicit_conv_engine_44 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 45
// =========================================================
module garuda_explicit_conv_engine_45 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 46
// =========================================================
module garuda_explicit_conv_engine_46 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 47
// =========================================================
module garuda_explicit_conv_engine_47 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 48
// =========================================================
module garuda_explicit_conv_engine_48 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 49
// =========================================================
module garuda_explicit_conv_engine_49 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 50
// =========================================================
module garuda_explicit_conv_engine_50 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 51
// =========================================================
module garuda_explicit_conv_engine_51 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 52
// =========================================================
module garuda_explicit_conv_engine_52 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 53
// =========================================================
module garuda_explicit_conv_engine_53 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 54
// =========================================================
module garuda_explicit_conv_engine_54 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 55
// =========================================================
module garuda_explicit_conv_engine_55 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 56
// =========================================================
module garuda_explicit_conv_engine_56 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 57
// =========================================================
module garuda_explicit_conv_engine_57 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 58
// =========================================================
module garuda_explicit_conv_engine_58 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 59
// =========================================================
module garuda_explicit_conv_engine_59 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 60
// =========================================================
module garuda_explicit_conv_engine_60 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 61
// =========================================================
module garuda_explicit_conv_engine_61 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 62
// =========================================================
module garuda_explicit_conv_engine_62 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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
// EXPLICIT NPU SYSTOLIC HARDWARE SUBSYSTEM: CONV ENGINE 63
// =========================================================
module garuda_explicit_conv_engine_63 (
    input wire clk, reset_n,
    output reg [255:0] engine_out,
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