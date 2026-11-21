// =========================================================================
// GARUDA SEMESTA — TITAN V12.5.1 REAL BRANCH & JUMP EXECUTION TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Strict Hardware Testbench verifying BEQ & JMP Execution & 1-Cycle Flush:
// Drives real 64-bit GARUDA ISA instructions based on icache_addr:
// 0x8000_0000: MOV r1, 10           -> r1 = 10
// 0x8000_0008: MOV r2, 10           -> r2 = 10
// 0x8000_0010: BEQ r1, r2, 0x80000028-> Branch Taken -> PC = 0x80000028!
// 0x8000_0018: MOV r3, 99           -> FLUSHED & SKIPPED (r3 != 99)
// 0x8000_0020: MOV r3, 88           -> FLUSHED & SKIPPED (r3 != 88)
// 0x8000_0028: MOV r4, 500          -> EXECUTED (r4 = 500)
// 0x8000_0030: JMP 0x80000040       -> Jump Taken -> PC = 0x80000040!
// 0x8000_0038: MOV r5, 77           -> FLUSHED & SKIPPED (r5 != 77)
// 0x8000_0040: HALT                 -> Pipeline Halted
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_v125_branch_jump;

    reg clk;
    reg rst_n;

    wire [31:0] icache_addr;
    wire        icache_req_valid;
    reg  [63:0] icache_inst_data;
    reg         icache_valid;

    wire [31:0] current_pc;
    wire        pipeline_halted;
    wire        illegal_instruction;

    integer cycle_counter = 0;

    always #5 clk = ~clk;

    // Real Instruction Memory Array Lookup
    always @(*) begin
        icache_valid = 1'b1;
        case (icache_addr)
            32'h8000_0000: icache_inst_data = 64'h1000_0040_0000_000A; // MOV r1, 10 (rd=1)
            32'h8000_0008: icache_inst_data = 64'h1000_0080_0000_000A; // MOV r2, 10 (rd=2)
            32'h8000_0010: icache_inst_data = 64'h5088_0000_8000_0028; // BEQ r1, r2, 0x80000028 (rs1=1, rs2=2)
            32'h8000_0018: icache_inst_data = 64'h1000_00C0_0000_0063; // MOV r3, 99 (rd=3, Wrong path)
            32'h8000_0020: icache_inst_data = 64'h1000_00C0_0000_0058; // MOV r3, 88 (rd=3, Wrong path)
            32'h8000_0028: icache_inst_data = 64'h1000_0100_0000_01F4; // MOV r4, 500 (rd=4, Branch target)
            32'h8000_0030: icache_inst_data = 64'h6000_0000_8000_0040; // JMP 0x80000040
            32'h8000_0038: icache_inst_data = 64'h1000_0140_0000_004D; // MOV r5, 77 (rd=5, Wrong path)
            32'h8000_0040: icache_inst_data = 64'hF000_0000_0000_0000; // HALT
            default:       icache_inst_data = 64'h0;                    // NOP
        endcase
    end

    garuda_cpu_pipeline_top #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32)
    ) u_dut_cpu (
        .clk(clk),
        .rst_n(rst_n),
        .irq_req(1'b0),
        .icache_addr(icache_addr),
        .icache_req_valid(icache_req_valid),
        .icache_inst_data(icache_inst_data),
        .icache_valid(icache_valid),
        .icache_stall(1'b0),
        .dcache_addr(),
        .dcache_write_val(),
        .dcache_byte_en(),
        .dcache_write_en(),
        .dcache_req_valid(),
        .dcache_read_val(64'd0),
        .dcache_valid(1'b1),
        .dcache_stall(1'b0),
        .current_pc(current_pc),
        .pipeline_halted(pipeline_halted),
        .illegal_instruction(illegal_instruction)
    );

    // Timeout Protection Watchdog (500 cycles max)
    always @(posedge clk) begin
        cycle_counter <= cycle_counter + 1;
        if (cycle_counter > 500) begin
            $display("FATAL: TIMEOUT IN TITAN V12.5.1 BRANCH/JUMP TESTBENCH!");
            $fflush();
            $fatal(1, "Timeout");
        end
    end

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA V12.5.1 — REAL BRANCH & JUMP EXECUTION TESTBENCH");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");
        $fflush();

        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;

        $display("[BRANCH/JUMP TEST] Reset Released. Fetching Real Instructions from Memory Array...");
        $fflush();

        wait(pipeline_halted == 1'b1);

        $display("[BRANCH/JUMP TEST] CPU Halted at PC = 0x%h. Verifying Register File Statements...", current_pc);
        $display("  r1 = %d (Expected 10)", u_dut_cpu.u_regfile.registers[1]);
        $display("  r2 = %d (Expected 10)", u_dut_cpu.u_regfile.registers[2]);
        $display("  r3 = %d (Expected 0  - Flushed wrong-path instructions 99 and 88!)", u_dut_cpu.u_regfile.registers[3]);
        $display("  r4 = %d (Expected 500 - Executed Branch Target instruction!)", u_dut_cpu.u_regfile.registers[4]);
        $display("  r5 = %d (Expected 0  - Flushed Jump wrong-path instruction 77!)", u_dut_cpu.u_regfile.registers[5]);
        $fflush();

        if (u_dut_cpu.u_regfile.registers[1] === 64'd10 &&
            u_dut_cpu.u_regfile.registers[2] === 64'd10 &&
            u_dut_cpu.u_regfile.registers[3] === 64'd0  &&
            u_dut_cpu.u_regfile.registers[4] === 64'd500 &&
            u_dut_cpu.u_regfile.registers[5] === 64'd0) begin
            $display("BRANCH_JUMP_ASSERTION_PASS: REAL BEQ, JMP & PIPELINE FLUSH 100%% VERIFIED!");
            $fflush();
            $finish;
        end else begin
            $display("FAIL: REAL BRANCH/JUMP OR PIPELINE FLUSH ASSERTION MISMATCH");
            $fflush();
            $fatal(1, "Branch/Jump Mismatch");
        end
    end

endmodule
