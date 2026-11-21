// =========================================================================
// GARUDA SEMESTA V12.3 — INDEPENDENT CPU LOAD/STORE TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
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

    always @(posedge clk) begin
        cycle_counter <= cycle_counter + 1;
        if (cycle_counter > 2000) begin
            $display("FATAL: TIMEOUT IN CPU LOAD/STORE TESTBENCH!");
            $fatal(1, "Timeout");
        end
    end

    initial begin
        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;

        wait(pipeline_halted == 1'b1);

        $display("[LOAD/STORE TEST] CPU Halted. Checking Register File and Cache Writeback...");
        $display("  r3 (STORE val) = %d", u_dut.u_cpu.u_regfile.registers[3]);
        $display("  r4 (LOADED val) = %d", u_dut.u_cpu.u_regfile.registers[4]);

        if (u_dut.u_cpu.u_regfile.registers[3] === 64'd500 &&
            u_dut.u_cpu.u_regfile.registers[4] === 64'd500) begin
            $display("LOAD_STORE_ASSERTION_PASS: CPU STORE AND LOAD VERIFIED IN HARDWARE RTL");
            $finish;
        end else begin
            $display("FAIL: LOAD/STORE REGFILE MISMATCH (r3=%d, r4=%d)", u_dut.u_cpu.u_regfile.registers[3], u_dut.u_cpu.u_regfile.registers[4]);
            $fatal(1, "Mismatch");
        end
    end

endmodule
