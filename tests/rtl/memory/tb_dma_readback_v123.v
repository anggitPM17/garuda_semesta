// =========================================================================
// GARUDA SEMESTA V12.3 — INDEPENDENT DMA READBACK TESTBENCH
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// =========================================================================

`timescale 1ns / 1ps

module tb_dma_readback_v123;

    reg clk;
    reg rst_n;

    reg  [31:0] ext_dma_addr;
    reg  [63:0] ext_dma_write_val;
    reg  [3:0]  ext_dma_byte_en;
    reg         ext_dma_write_en;
    reg         ext_dma_req_valid;
    wire [63:0] ext_dma_read_val;
    wire        ext_dma_grant;
    wire        ext_dma_resp_valid;

    wire [31:0] current_pc;
    wire        pipeline_halted;
    wire        illegal_instruction;
    wire        parity_error_detected;

    integer cycle_counter = 0;
    reg [31:0] captured_readback_val = 0;

    always #5 clk = ~clk;

    garuda_vertical_slice_top #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32)
    ) u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .ext_dma_addr(ext_dma_addr),
        .ext_dma_write_val(ext_dma_write_val),
        .ext_dma_byte_en(ext_dma_byte_en),
        .ext_dma_write_en(ext_dma_write_en),
        .ext_dma_req_valid(ext_dma_req_valid),
        .ext_dma_read_val(ext_dma_read_val),
        .ext_dma_grant(ext_dma_grant),
        .ext_dma_resp_valid(ext_dma_resp_valid),
        .current_pc(current_pc),
        .pipeline_halted(pipeline_halted),
        .illegal_instruction(illegal_instruction),
        .parity_error_detected(parity_error_detected)
    );

    always @(posedge clk) begin
        if (ext_dma_resp_valid) begin
            captured_readback_val <= ext_dma_read_val[31:0];
        end
        cycle_counter <= cycle_counter + 1;
        if (cycle_counter > 2000) begin
            $display("FATAL: TIMEOUT IN DMA TESTBENCH!");
            $fatal(1, "Timeout");
        end
    end

    initial begin
        clk = 0;
        rst_n = 0;
        ext_dma_addr = 32'h0;
        ext_dma_write_val = 64'h0;
        ext_dma_byte_en = 4'h0;
        ext_dma_write_en = 0;
        ext_dma_req_valid = 0;

        #20 rst_n = 1;

        wait(pipeline_halted == 1'b1);
        #100;

        // Perform DMA Readback Verification from SRAM location 0x80000100
        @(posedge clk);
        ext_dma_addr = 32'h8000_0100;
        ext_dma_req_valid = 1;

        wait(ext_dma_resp_valid == 1'b1);
        @(posedge clk);
        ext_dma_req_valid = 0;
        #1;

        if (captured_readback_val === 32'd500) begin
            $display("DMA_READBACK_ASSERTION_PASS: SRAM[0x80000100] == 500 VERIFIED VIA DMA");
            $finish;
        end else begin
            $display("FAIL: DMA SRAM READBACK MISMATCH (Got %d, Expected 500)", captured_readback_val);
            $fatal(1, "Mismatch");
        end
    end

endmodule
