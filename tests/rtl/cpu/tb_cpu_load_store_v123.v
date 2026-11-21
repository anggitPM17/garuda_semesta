// =========================================================================
// GARUDA SEMESTA V12.3-R2 — INDEPENDENT CPU LOAD/STORE & TRANSACTION TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Strict Hardware Testbench verifying CPU STORE & LOAD transactions:
// - Monitors CPU D-Cache Memory Interface (req_valid, req_write_en, req_addr, req_write_data)
// - Verifies STORE transaction to SRAM address 0x80000100
// - Verifies LOAD transaction returning 500 into r4
// - Verifies physical SRAM array storage (main_sram[64] == 500)
// =========================================================================

`timescale 1ns / 1ps

module tb_cpu_load_store_v123;

    reg clk;
    reg rst_n;

    wire [31:0] current_pc;
    wire        pipeline_halted;
    wire        illegal_instruction;
    wire        parity_error_detected;

    integer cycle_counter = 0;
    integer store_tx_count = 0;
    integer load_tx_count = 0;

    always #5 clk = ~clk;

    garuda_vertical_slice_top #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32)
    ) u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .ext_dma_addr(32'h0),
        .ext_dma_write_val(64'h0),
        .ext_dma_byte_en(4'h0),
        .ext_dma_write_en(1'b0),
        .ext_dma_req_valid(1'b0),
        .ext_dma_read_val(),
        .ext_dma_grant(),
        .ext_dma_resp_valid(),
        .current_pc(current_pc),
        .pipeline_halted(pipeline_halted),
        .illegal_instruction(illegal_instruction),
        .parity_error_detected(parity_error_detected)
    );

    // Monitor CPU D-Cache Memory Transactions
    always @(posedge clk) begin
        if (rst_n) begin
            if (u_dut.u_memory_subsystem.u_dcache.req_valid && u_dut.u_memory_subsystem.u_dcache.req_write_en && (u_dut.u_memory_subsystem.u_dcache.req_addr == 32'h8000_0100)) begin
                store_tx_count <= store_tx_count + 1;
                $display("[RTL TRANSACTION LOG] STORE Transaction Detected: Address=0x%h, Data=%d", u_dut.u_memory_subsystem.u_dcache.req_addr, u_dut.u_memory_subsystem.u_dcache.req_write_data);
            end
            if (u_dut.u_memory_subsystem.u_dcache.req_valid && !u_dut.u_memory_subsystem.u_dcache.req_write_en && (u_dut.u_memory_subsystem.u_dcache.req_addr == 32'h8000_0100)) begin
                load_tx_count <= load_tx_count + 1;
                $display("[RTL TRANSACTION LOG] LOAD Transaction Detected: Address=0x%h", u_dut.u_memory_subsystem.u_dcache.req_addr);
            end
        end
    end

    // Timeout Protection Watchdog (2000 cycles max)
    always @(posedge clk) begin
        cycle_counter <= cycle_counter + 1;
        if (cycle_counter > 2000) begin
            $display("FATAL: TIMEOUT IN CPU LOAD/STORE TESTBENCH!");
            $fatal(1, "Timeout");
        end
    end

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA V12.3-R2 — CPU LOAD/STORE TRANSACTION TESTBENCH");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");

        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;

        wait(pipeline_halted == 1'b1);

        $display("[LOAD/STORE TEST] CPU Halted. Checking Transactions, RegFile, and Physical SRAM...");
        $display("  STORE Transactions Captured = %d", store_tx_count);
        $display("  LOAD Transactions Captured  = %d", load_tx_count);
        $display("  r3 (STORE val) = %d", u_dut.u_cpu.u_regfile.registers[3]);
        $display("  r4 (LOADED val) = %d", u_dut.u_cpu.u_regfile.registers[4]);
        $display("  Physical SRAM[0x80000100] Array Word = %d", u_dut.u_memory_subsystem.u_mem_controller.main_sram[64]);

        if (store_tx_count >= 1 &&
            load_tx_count >= 1 &&
            u_dut.u_memory_subsystem.u_mem_controller.main_sram[64] === 32'd500 &&
            u_dut.u_cpu.u_regfile.registers[3] === 64'd500 &&
            u_dut.u_cpu.u_regfile.registers[4] === 64'd500) begin
            $display("LOAD_STORE_ASSERTION_PASS: CPU STORE AND LOAD VERIFIED IN HARDWARE RTL");
            $finish;
        end else begin
            $display("FAIL: LOAD/STORE TRANSACTION OR SRAM MISMATCH");
            $fatal(1, "Mismatch");
        end
    end

endmodule
