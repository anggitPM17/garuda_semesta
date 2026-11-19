// =========================================================================
// GARUDA SEMESTA — Ultimate 5-Chip Master Hardware Testbench & Waveform Dump
// Module: tb_garuda_ultimate
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Generates VCD (Value Change Dump) Digital Oscilloscope Logic Waveforms
// (garuda_ultimate_simulation.vcd) for GTKWave / ModelSim / VCS / QuestaSim.
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_ultimate;

    // ---------------------------------------------------------
    // 1. TESTBENCH CLOCK & RESET SIGNALS
    // ---------------------------------------------------------
    reg clk_sys;
    reg clk_mem;
    reg rst_n;
    reg power_on_reset_n;
    reg tamper_mesh_trig;

    // ---------------------------------------------------------
    // 2. MONITORED HARDWARE OUTPUT BUSES
    // ---------------------------------------------------------
    wire [223:0] ddr5_ca;
    wire [15:0]  ddr5_cs_n;
    wire [31:0]  ddr5_ck_p;
    wire [31:0]  ddr5_ck_n;
    wire [1023:0] ddr5_dq;
    wire         uart_tx;
    wire [31:0]  snn_spike_array_out;
    wire [15:0]  diagnostic_leds;
    wire [15:0]  sys_halted_flags;

    // ---------------------------------------------------------
    // 3. INSTANTIATE GARUDA CPU SoC v12.0 TITAN-TITANIUM TOP MODULE
    // ---------------------------------------------------------
    garuda_titanium_top uut (
        .clk_sys(clk_sys),
        .clk_mem(clk_mem),
        .rst_n(rst_n),
        .power_on_reset_n(power_on_reset_n),
        .jtag_tck(1'b0),
        .jtag_tms(1'b0),
        .jtag_tdi(1'b0),
        .jtag_tdo(),
        .pll_ref_clks(25'd0),
        .ddr5_ca(ddr5_ca),
        .ddr5_cs_n(ddr5_cs_n),
        .ddr5_ck_p(ddr5_ck_p),
        .ddr5_ck_n(ddr5_ck_n),
        .ddr5_dq(ddr5_dq),
        .ddr5_dqs_p(),
        .ddr5_dqs_n(),
        .pcie_refclk_p(8'd0),
        .pcie_refclk_n(8'd0),
        .pcie_tx_p(),
        .pcie_tx_n(),
        .pcie_rx_p(128'd0),
        .pcie_rx_n(128'd0),
        .ucie_die_to_die_link(),
        .uart_tx(uart_tx),
        .uart_rx(1'b1),
        .general_purpose_io(),
        .snn_spike_array_out(snn_spike_array_out),
        .diagnostic_leds(diagnostic_leds),
        .sys_halted_flags(sys_halted_flags),
        .VDD_CORE(),
        .VDD_MEM(),
        .VDD_IO(),
        .VSS_GND()
    );

    // ---------------------------------------------------------
    // 4. 3.5 GHz CLOCK GENERATOR PIPELINE
    // ---------------------------------------------------------
    initial begin
        clk_sys = 0;
        forever #0.143 clk_sys = ~clk_sys; // 3.5 GHz Clock Period (0.286 ns)
    end

    initial begin
        clk_mem = 0;
        forever #0.100 clk_mem = ~clk_mem; // 5.0 GHz DDR5/HBM3e Memory Clock
    end

    // ---------------------------------------------------------
    // 5. TESTBENCH STIMULUS & VCD WAVEFORM DUMP GENERATION
    // ---------------------------------------------------------
    initial begin
        // Dump VCD file for GTKWave
        $dumpfile("garuda_ultimate_simulation.vcd");
        $dumpvars(0, tb_garuda_ultimate);

        $display("=========================================================================");
        $display("GARUDA SEMESTA — ULTIMATE 3.5 GHz HARDWARE WAVEFORM SIMULATION");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================");

        // Power-On Reset Sequence
        rst_n = 0;
        power_on_reset_n = 0;
        tamper_mesh_trig = 0;
        #2.0;

        $display(" [TIME %0t ns] Releasing Power-On Reset (POR)...", $time);
        power_on_reset_n = 1;
        #1.0;

        $display(" [TIME %0t ns] Releasing Global System Reset (rst_n)...", $time);
        rst_n = 1;

        // Simulate 32-Core Execution & Memory Bus Traffic
        #50.0;
        $display(" [TIME %0t ns] 32-Core Ultra-SMP Executing AI Tensor & SNN Synapse Spikes...", $time);

        #100.0;
        $display(" [TIME %0t ns] VCD Digital Oscilloscope Waveform Dump Complete: garuda_ultimate_simulation.vcd", $time);
        $finish;
    end

endmodule
