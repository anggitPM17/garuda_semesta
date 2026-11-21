// =========================================================================
// GARUDA SEMESTA V12.3 — HARDWARE ILLEGAL INSTRUCTION EXCEPTION TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// =========================================================================

`timescale 1ns / 1ps

module tb_illegal_instruction_v123;

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
        if (cycle_counter > 500) begin
            $display("FATAL: TIMEOUT IN ILLEGAL INSTRUCTION TESTBENCH!");
            $fatal(1, "Timeout");
        end
    end

    initial begin
        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;

        // Wait for CPU decoder to catch invalid opcode 0xE
        wait(illegal_instruction == 1'b1);

        $display("ILLEGAL_EXCEPTION_ASSERTION_PASS: HARDWARE ILLEGAL INSTRUCTION EXCEPTION SIGNAL ASSERTED (0xE)");
        #20;
        $finish;
    end

endmodule
