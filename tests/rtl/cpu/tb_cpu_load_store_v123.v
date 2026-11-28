// =========================================================================
// GARUDA SEMESTA V12.3-R2.2 — CPU LOAD/STORE TRANSACTION ACCEPTANCE TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// FASE 8 Probe Testbench for L2 Cache and Memory Arbiter Request Chain
// =========================================================================

`timescale 1ns / 1ps

module tb_cpu_load_store_v123;

    reg clk;
    reg rst_n;

    wire [31:0] current_pc;
    wire        pipeline_halted;
    wire        illegal_instruction;
    wire        parity_error_detected;

    integer store_accepted_count = 0;
    integer load_accepted_count = 0;
    integer mem_ctrl_store_count = 0;
    integer mem_ctrl_load_count = 0;
    integer dbg_cycle = 0;
    integer timeout_cnt;

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

    // 1. Monitor Accepted CPU D-Cache Memory Transactions
    always @(posedge clk) begin
        if (rst_n) begin
            if (u_dut.u_memory_subsystem.u_dcache.req_valid &&
                u_dut.u_memory_subsystem.u_dcache.req_write_en &&
                !u_dut.u_memory_subsystem.u_dcache.stall &&
                (u_dut.u_memory_subsystem.u_dcache.req_addr == 32'h8000_0100)) begin
                store_accepted_count <= store_accepted_count + 1;
                $display("[RTL TRANSACTION ACCEPTED] STORE Accepted: Address=0x%h, Data=%d",
                         u_dut.u_memory_subsystem.u_dcache.req_addr,
                         u_dut.u_memory_subsystem.u_dcache.req_write_data);
                $fflush();
            end
            if (u_dut.u_memory_subsystem.u_dcache.req_valid &&
                !u_dut.u_memory_subsystem.u_dcache.req_write_en &&
                !u_dut.u_memory_subsystem.u_dcache.stall &&
                (u_dut.u_memory_subsystem.u_dcache.req_addr == 32'h8000_0100)) begin
                load_accepted_count <= load_accepted_count + 1;
                $display("[RTL TRANSACTION ACCEPTED] LOAD Accepted: Address=0x%h",
                         u_dut.u_memory_subsystem.u_dcache.req_addr);
                $fflush();
            end
        end
    end

    // 2. Monitor SRAM Memory Controller Execution Handshake
    always @(posedge clk) begin
        if (rst_n) begin
            if (u_dut.u_memory_subsystem.u_mem_controller.req_valid &&
                u_dut.u_memory_subsystem.u_mem_controller.req_write_en &&
                u_dut.u_memory_subsystem.u_mem_controller.resp_valid &&
                (u_dut.u_memory_subsystem.u_mem_controller.req_addr == 32'h8000_0100)) begin
                mem_ctrl_store_count <= mem_ctrl_store_count + 1;
                $display("[SRAM CONTROLLER HANDSHAKE] STORE Executed: Address=0x%h, Data=%d",
                         u_dut.u_memory_subsystem.u_mem_controller.req_addr,
                         u_dut.u_memory_subsystem.u_mem_controller.req_write_data);
                $fflush();
            end
            if (u_dut.u_memory_subsystem.u_mem_controller.req_valid &&
                !u_dut.u_memory_subsystem.u_mem_controller.req_write_en &&
                u_dut.u_memory_subsystem.u_mem_controller.resp_valid &&
                (u_dut.u_memory_subsystem.u_mem_controller.req_addr == 32'h8000_0100)) begin
                mem_ctrl_load_count <= mem_ctrl_load_count + 1;
                $display("[SRAM CONTROLLER HANDSHAKE] LOAD Executed: Address=0x%h, Returned Data=%d",
                         u_dut.u_memory_subsystem.u_mem_controller.req_addr,
                         u_dut.u_memory_subsystem.u_mem_controller.resp_read_data);
                $fflush();
            end
        end
    end

    reg [31:0] prev_if_id_pc;
    always @(posedge clk) begin
        if (rst_n) begin
            if (u_dut.u_cpu.if_id_pc !== prev_if_id_pc) begin
                $display("[PC_CHG] if_id_pc=%h if_id_inst=%h dec_opcode=%h", u_dut.u_cpu.if_id_pc, u_dut.u_cpu.if_id_inst, u_dut.u_cpu.dec_opcode);
                $fflush();
                prev_if_id_pc <= u_dut.u_cpu.if_id_pc;
            end
        end
        dbg_cycle = dbg_cycle + 1;
    end

    initial begin
        $dumpfile("tb_cpu_load_store.vcd");
        $dumpvars(0, tb_cpu_load_store_v123);
        $display("=========================================================================");
        $display("GARUDA SEMESTA V12.3-R2.2 — FASE 30 VCD WAVEFORM GENERATION TESTBENCH");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");
        $fflush();

        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;

        timeout_cnt = 0;
        while (pipeline_halted !== 1'b1 && timeout_cnt < 20000) begin
            @(posedge clk);
            timeout_cnt = timeout_cnt + 1;
        end

        if (pipeline_halted !== 1'b1) begin
            $display("[RESULT] TIMEOUT: CPU did not halt after %0d cycles.", timeout_cnt);
            $display("[RESULT] PC=0x%h halted=%b", u_dut.u_cpu.u_pc.pc_reg, pipeline_halted);
            $finish;
        end

        $display("[LOAD/STORE TEST] CPU Halted at Cycle %0d.", timeout_cnt);
        $display("  Accepted D-Cache STORE Transactions = %d", store_accepted_count);
        $display("  Accepted D-Cache LOAD Transactions  = %d", load_accepted_count);
        $display("  Executed SRAM Controller STORE Handshakes = %d", mem_ctrl_store_count);
        $display("  Executed SRAM Controller LOAD Handshakes  = %d", mem_ctrl_load_count);
        $display("  r3 (STORE val) = %d", u_dut.u_cpu.u_regfile.registers[3]);
        $display("  r4 (LOADED val) = %d", u_dut.u_cpu.u_regfile.registers[4]);
        $display("  r5 (ADD r4, r1) = %d", u_dut.u_cpu.u_regfile.registers[5]);
        $display("  illegal_instruction = %b", illegal_instruction);
        $display("  Physical SRAM[0x80000100] Mapping Array Word main_sram[64] = %d", u_dut.u_memory_subsystem.u_mem_controller.main_sram[64]);
        $fflush();

        if (store_accepted_count >= 1 &&
            load_accepted_count >= 1 &&
            mem_ctrl_store_count >= 1 &&
            mem_ctrl_load_count >= 1 &&
            u_dut.u_memory_subsystem.u_mem_controller.main_sram[64] === 32'd500 &&
            u_dut.u_cpu.u_regfile.registers[3] === 64'd500 &&
            u_dut.u_cpu.u_regfile.registers[4] === 64'd500 &&
            u_dut.u_cpu.u_regfile.registers[5] === 64'd650 &&
            illegal_instruction === 1'b0) begin
            $display("LOAD_STORE_ASSERTION_PASS: CPU STORE AND LOAD TRANSACTIONS ACCEPTED & VERIFIED IN HARDWARE RTL");
            $fflush();
            $finish;
        end else begin
            $display("FAIL: LOAD/STORE TRANSACTION HANDSHAKE OR SRAM MISMATCH");
            $fflush();
            $finish;
        end
    end

endmodule
