// =========================================================================
// GARUDA MCU v1.0 ULTIMATE - 64-Core RISC-V IoT (Fully Unrolled Verilog RTL)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================================

`default_nettype none

module garuda_mcu_top (
    input wire clk_mcu, clk_mem, rst_n,
    input wire [15:0] adc_channels_p, adc_channels_n,
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
    output wire [15:0] mcu_status_flags, ble_baseband_status,
    inout wire [1199:0] VDD_MCU,
    inout wire [599:0] VDD_MEM,
    inout wire [279:0] VDD_IO,
    inout wire [799:0] VSS_GND
);

    // EXPLICIT WIRES FOR ALL 64 RISC-V MCU CORES
    wire [255:0] mcu_core_0_out;
    wire mcu_core_0_halt;

    wire [255:0] mcu_core_1_out;
    wire mcu_core_1_halt;

    wire [255:0] mcu_core_2_out;
    wire mcu_core_2_halt;

    wire [255:0] mcu_core_3_out;
    wire mcu_core_3_halt;

    wire [255:0] mcu_core_4_out;
    wire mcu_core_4_halt;

    wire [255:0] mcu_core_5_out;
    wire mcu_core_5_halt;

    wire [255:0] mcu_core_6_out;
    wire mcu_core_6_halt;

    wire [255:0] mcu_core_7_out;
    wire mcu_core_7_halt;

    wire [255:0] mcu_core_8_out;
    wire mcu_core_8_halt;

    wire [255:0] mcu_core_9_out;
    wire mcu_core_9_halt;

    wire [255:0] mcu_core_10_out;
    wire mcu_core_10_halt;

    wire [255:0] mcu_core_11_out;
    wire mcu_core_11_halt;

    wire [255:0] mcu_core_12_out;
    wire mcu_core_12_halt;

    wire [255:0] mcu_core_13_out;
    wire mcu_core_13_halt;

    wire [255:0] mcu_core_14_out;
    wire mcu_core_14_halt;

    wire [255:0] mcu_core_15_out;
    wire mcu_core_15_halt;

    wire [255:0] mcu_core_16_out;
    wire mcu_core_16_halt;

    wire [255:0] mcu_core_17_out;
    wire mcu_core_17_halt;

    wire [255:0] mcu_core_18_out;
    wire mcu_core_18_halt;

    wire [255:0] mcu_core_19_out;
    wire mcu_core_19_halt;

    wire [255:0] mcu_core_20_out;
    wire mcu_core_20_halt;

    wire [255:0] mcu_core_21_out;
    wire mcu_core_21_halt;

    wire [255:0] mcu_core_22_out;
    wire mcu_core_22_halt;

    wire [255:0] mcu_core_23_out;
    wire mcu_core_23_halt;

    wire [255:0] mcu_core_24_out;
    wire mcu_core_24_halt;

    wire [255:0] mcu_core_25_out;
    wire mcu_core_25_halt;

    wire [255:0] mcu_core_26_out;
    wire mcu_core_26_halt;

    wire [255:0] mcu_core_27_out;
    wire mcu_core_27_halt;

    wire [255:0] mcu_core_28_out;
    wire mcu_core_28_halt;

    wire [255:0] mcu_core_29_out;
    wire mcu_core_29_halt;

    wire [255:0] mcu_core_30_out;
    wire mcu_core_30_halt;

    wire [255:0] mcu_core_31_out;
    wire mcu_core_31_halt;

    wire [255:0] mcu_core_32_out;
    wire mcu_core_32_halt;

    wire [255:0] mcu_core_33_out;
    wire mcu_core_33_halt;

    wire [255:0] mcu_core_34_out;
    wire mcu_core_34_halt;

    wire [255:0] mcu_core_35_out;
    wire mcu_core_35_halt;

    wire [255:0] mcu_core_36_out;
    wire mcu_core_36_halt;

    wire [255:0] mcu_core_37_out;
    wire mcu_core_37_halt;

    wire [255:0] mcu_core_38_out;
    wire mcu_core_38_halt;

    wire [255:0] mcu_core_39_out;
    wire mcu_core_39_halt;

    wire [255:0] mcu_core_40_out;
    wire mcu_core_40_halt;

    wire [255:0] mcu_core_41_out;
    wire mcu_core_41_halt;

    wire [255:0] mcu_core_42_out;
    wire mcu_core_42_halt;

    wire [255:0] mcu_core_43_out;
    wire mcu_core_43_halt;

    wire [255:0] mcu_core_44_out;
    wire mcu_core_44_halt;

    wire [255:0] mcu_core_45_out;
    wire mcu_core_45_halt;

    wire [255:0] mcu_core_46_out;
    wire mcu_core_46_halt;

    wire [255:0] mcu_core_47_out;
    wire mcu_core_47_halt;

    wire [255:0] mcu_core_48_out;
    wire mcu_core_48_halt;

    wire [255:0] mcu_core_49_out;
    wire mcu_core_49_halt;

    wire [255:0] mcu_core_50_out;
    wire mcu_core_50_halt;

    wire [255:0] mcu_core_51_out;
    wire mcu_core_51_halt;

    wire [255:0] mcu_core_52_out;
    wire mcu_core_52_halt;

    wire [255:0] mcu_core_53_out;
    wire mcu_core_53_halt;

    wire [255:0] mcu_core_54_out;
    wire mcu_core_54_halt;

    wire [255:0] mcu_core_55_out;
    wire mcu_core_55_halt;

    wire [255:0] mcu_core_56_out;
    wire mcu_core_56_halt;

    wire [255:0] mcu_core_57_out;
    wire mcu_core_57_halt;

    wire [255:0] mcu_core_58_out;
    wire mcu_core_58_halt;

    wire [255:0] mcu_core_59_out;
    wire mcu_core_59_halt;

    wire [255:0] mcu_core_60_out;
    wire mcu_core_60_halt;

    wire [255:0] mcu_core_61_out;
    wire mcu_core_61_halt;

    wire [255:0] mcu_core_62_out;
    wire mcu_core_62_halt;

    wire [255:0] mcu_core_63_out;
    wire mcu_core_63_halt;

    // EXPLICIT INSTANTIATION OF ALL 64 RISC-V MCU CORES
    // ---------------------------------------------------------
    // MCU RISC-V CORE 0
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd0) ) mcu_core_0 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_0_out),
        .halted(mcu_core_0_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 1
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd1) ) mcu_core_1 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_1_out),
        .halted(mcu_core_1_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 2
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd2) ) mcu_core_2 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_2_out),
        .halted(mcu_core_2_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 3
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd3) ) mcu_core_3 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_3_out),
        .halted(mcu_core_3_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 4
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd4) ) mcu_core_4 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_4_out),
        .halted(mcu_core_4_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 5
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd5) ) mcu_core_5 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_5_out),
        .halted(mcu_core_5_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 6
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd6) ) mcu_core_6 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_6_out),
        .halted(mcu_core_6_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 7
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd7) ) mcu_core_7 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_7_out),
        .halted(mcu_core_7_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 8
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd8) ) mcu_core_8 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_8_out),
        .halted(mcu_core_8_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 9
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd9) ) mcu_core_9 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_9_out),
        .halted(mcu_core_9_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 10
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd10) ) mcu_core_10 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_10_out),
        .halted(mcu_core_10_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 11
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd11) ) mcu_core_11 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_11_out),
        .halted(mcu_core_11_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 12
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd12) ) mcu_core_12 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_12_out),
        .halted(mcu_core_12_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 13
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd13) ) mcu_core_13 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_13_out),
        .halted(mcu_core_13_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 14
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd14) ) mcu_core_14 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_14_out),
        .halted(mcu_core_14_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 15
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd15) ) mcu_core_15 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_15_out),
        .halted(mcu_core_15_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 16
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd16) ) mcu_core_16 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_16_out),
        .halted(mcu_core_16_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 17
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd17) ) mcu_core_17 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_17_out),
        .halted(mcu_core_17_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 18
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd18) ) mcu_core_18 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_18_out),
        .halted(mcu_core_18_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 19
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd19) ) mcu_core_19 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_19_out),
        .halted(mcu_core_19_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 20
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd20) ) mcu_core_20 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_20_out),
        .halted(mcu_core_20_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 21
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd21) ) mcu_core_21 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_21_out),
        .halted(mcu_core_21_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 22
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd22) ) mcu_core_22 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_22_out),
        .halted(mcu_core_22_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 23
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd23) ) mcu_core_23 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_23_out),
        .halted(mcu_core_23_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 24
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd24) ) mcu_core_24 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_24_out),
        .halted(mcu_core_24_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 25
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd25) ) mcu_core_25 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_25_out),
        .halted(mcu_core_25_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 26
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd26) ) mcu_core_26 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_26_out),
        .halted(mcu_core_26_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 27
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd27) ) mcu_core_27 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_27_out),
        .halted(mcu_core_27_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 28
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd28) ) mcu_core_28 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_28_out),
        .halted(mcu_core_28_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 29
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd29) ) mcu_core_29 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_29_out),
        .halted(mcu_core_29_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 30
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd30) ) mcu_core_30 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_30_out),
        .halted(mcu_core_30_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 31
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd31) ) mcu_core_31 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_31_out),
        .halted(mcu_core_31_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 32
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd32) ) mcu_core_32 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_32_out),
        .halted(mcu_core_32_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 33
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd33) ) mcu_core_33 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_33_out),
        .halted(mcu_core_33_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 34
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd34) ) mcu_core_34 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_34_out),
        .halted(mcu_core_34_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 35
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd35) ) mcu_core_35 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_35_out),
        .halted(mcu_core_35_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 36
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd36) ) mcu_core_36 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_36_out),
        .halted(mcu_core_36_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 37
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd37) ) mcu_core_37 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_37_out),
        .halted(mcu_core_37_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 38
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd38) ) mcu_core_38 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_38_out),
        .halted(mcu_core_38_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 39
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd39) ) mcu_core_39 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_39_out),
        .halted(mcu_core_39_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 40
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd40) ) mcu_core_40 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_40_out),
        .halted(mcu_core_40_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 41
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd41) ) mcu_core_41 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_41_out),
        .halted(mcu_core_41_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 42
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd42) ) mcu_core_42 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_42_out),
        .halted(mcu_core_42_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 43
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd43) ) mcu_core_43 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_43_out),
        .halted(mcu_core_43_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 44
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd44) ) mcu_core_44 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_44_out),
        .halted(mcu_core_44_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 45
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd45) ) mcu_core_45 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_45_out),
        .halted(mcu_core_45_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 46
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd46) ) mcu_core_46 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_46_out),
        .halted(mcu_core_46_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 47
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd47) ) mcu_core_47 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_47_out),
        .halted(mcu_core_47_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 48
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd48) ) mcu_core_48 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_48_out),
        .halted(mcu_core_48_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 49
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd49) ) mcu_core_49 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_49_out),
        .halted(mcu_core_49_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 50
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd50) ) mcu_core_50 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_50_out),
        .halted(mcu_core_50_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 51
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd51) ) mcu_core_51 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_51_out),
        .halted(mcu_core_51_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 52
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd52) ) mcu_core_52 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_52_out),
        .halted(mcu_core_52_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 53
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd53) ) mcu_core_53 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_53_out),
        .halted(mcu_core_53_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 54
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd54) ) mcu_core_54 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_54_out),
        .halted(mcu_core_54_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 55
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd55) ) mcu_core_55 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_55_out),
        .halted(mcu_core_55_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 56
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd56) ) mcu_core_56 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_56_out),
        .halted(mcu_core_56_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 57
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd57) ) mcu_core_57 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_57_out),
        .halted(mcu_core_57_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 58
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd58) ) mcu_core_58 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_58_out),
        .halted(mcu_core_58_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 59
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd59) ) mcu_core_59 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_59_out),
        .halted(mcu_core_59_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 60
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd60) ) mcu_core_60 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_60_out),
        .halted(mcu_core_60_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 61
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd61) ) mcu_core_61 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_61_out),
        .halted(mcu_core_61_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 62
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd62) ) mcu_core_62 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_62_out),
        .halted(mcu_core_62_halt)
    );

    // ---------------------------------------------------------
    // MCU RISC-V CORE 63
    // ---------------------------------------------------------
    garuda_mcu_riscv_core #( .CORE_ID(6'd63) ) mcu_core_63 (
        .clk(clk_mcu),
        .reset_n(rst_n),
        .core_out(mcu_core_63_out),
        .halted(mcu_core_63_halt)
    );

// =========================================================
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 0
// =========================================================
module garuda_explicit_mcu_core_0 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 1
// =========================================================
module garuda_explicit_mcu_core_1 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 2
// =========================================================
module garuda_explicit_mcu_core_2 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 3
// =========================================================
module garuda_explicit_mcu_core_3 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 4
// =========================================================
module garuda_explicit_mcu_core_4 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 5
// =========================================================
module garuda_explicit_mcu_core_5 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 6
// =========================================================
module garuda_explicit_mcu_core_6 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 7
// =========================================================
module garuda_explicit_mcu_core_7 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 8
// =========================================================
module garuda_explicit_mcu_core_8 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 9
// =========================================================
module garuda_explicit_mcu_core_9 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 10
// =========================================================
module garuda_explicit_mcu_core_10 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 11
// =========================================================
module garuda_explicit_mcu_core_11 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 12
// =========================================================
module garuda_explicit_mcu_core_12 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 13
// =========================================================
module garuda_explicit_mcu_core_13 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 14
// =========================================================
module garuda_explicit_mcu_core_14 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 15
// =========================================================
module garuda_explicit_mcu_core_15 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 16
// =========================================================
module garuda_explicit_mcu_core_16 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 17
// =========================================================
module garuda_explicit_mcu_core_17 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 18
// =========================================================
module garuda_explicit_mcu_core_18 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 19
// =========================================================
module garuda_explicit_mcu_core_19 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 20
// =========================================================
module garuda_explicit_mcu_core_20 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 21
// =========================================================
module garuda_explicit_mcu_core_21 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 22
// =========================================================
module garuda_explicit_mcu_core_22 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 23
// =========================================================
module garuda_explicit_mcu_core_23 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 24
// =========================================================
module garuda_explicit_mcu_core_24 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 25
// =========================================================
module garuda_explicit_mcu_core_25 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 26
// =========================================================
module garuda_explicit_mcu_core_26 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 27
// =========================================================
module garuda_explicit_mcu_core_27 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 28
// =========================================================
module garuda_explicit_mcu_core_28 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 29
// =========================================================
module garuda_explicit_mcu_core_29 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 30
// =========================================================
module garuda_explicit_mcu_core_30 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 31
// =========================================================
module garuda_explicit_mcu_core_31 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 32
// =========================================================
module garuda_explicit_mcu_core_32 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 33
// =========================================================
module garuda_explicit_mcu_core_33 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 34
// =========================================================
module garuda_explicit_mcu_core_34 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 35
// =========================================================
module garuda_explicit_mcu_core_35 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 36
// =========================================================
module garuda_explicit_mcu_core_36 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 37
// =========================================================
module garuda_explicit_mcu_core_37 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 38
// =========================================================
module garuda_explicit_mcu_core_38 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 39
// =========================================================
module garuda_explicit_mcu_core_39 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 40
// =========================================================
module garuda_explicit_mcu_core_40 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 41
// =========================================================
module garuda_explicit_mcu_core_41 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 42
// =========================================================
module garuda_explicit_mcu_core_42 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 43
// =========================================================
module garuda_explicit_mcu_core_43 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 44
// =========================================================
module garuda_explicit_mcu_core_44 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 45
// =========================================================
module garuda_explicit_mcu_core_45 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 46
// =========================================================
module garuda_explicit_mcu_core_46 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 47
// =========================================================
module garuda_explicit_mcu_core_47 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 48
// =========================================================
module garuda_explicit_mcu_core_48 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 49
// =========================================================
module garuda_explicit_mcu_core_49 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 50
// =========================================================
module garuda_explicit_mcu_core_50 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 51
// =========================================================
module garuda_explicit_mcu_core_51 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 52
// =========================================================
module garuda_explicit_mcu_core_52 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 53
// =========================================================
module garuda_explicit_mcu_core_53 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 54
// =========================================================
module garuda_explicit_mcu_core_54 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 55
// =========================================================
module garuda_explicit_mcu_core_55 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 56
// =========================================================
module garuda_explicit_mcu_core_56 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 57
// =========================================================
module garuda_explicit_mcu_core_57 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 58
// =========================================================
module garuda_explicit_mcu_core_58 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 59
// =========================================================
module garuda_explicit_mcu_core_59 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 60
// =========================================================
module garuda_explicit_mcu_core_60 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 61
// =========================================================
module garuda_explicit_mcu_core_61 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 62
// =========================================================
module garuda_explicit_mcu_core_62 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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
// EXPLICIT MCU RISC-V HARDWARE SUBSYSTEM: CORE 63
// =========================================================
module garuda_explicit_mcu_core_63 (
    input wire clk, reset_n,
    output reg [255:0] core_out,
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