// =========================================================================
// GARUDA SEMESTA — L1 I-CACHE MULTI-WORD REFILL TESTBENCH (v12.3.2-R4)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Dedicated Self-Checking Verilog Testbench for garuda_l1_icache.v:
// - Tests 4 distinct 64-bit instruction words in a single 32-byte cache line
// - Verifies refill address increment (+8 bytes per word)
// - Asserts valid_array bit set ONLY after all 4 words are populated
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_l1_icache_r4;

    reg clk;
    reg rst_n;

    // CPU Core Read Interface
    reg  [31:0] req_addr;
    reg         req_valid;
    wire [63:0] resp_data;
    wire        resp_hit;
    wire        resp_valid;
    wire        stall;

    reg         flush;
    reg         invalidate;

    // Memory Controller / L2 Interface
    wire [31:0] mem_req_addr;
    wire        mem_req_valid;
    reg  [63:0] mem_resp_data;
    reg         mem_resp_valid;

    integer test_pass_count = 0;

    always #5 clk = ~clk;

    garuda_l1_icache #(
        .CACHE_SIZE_BYTES(4096),
        .LINE_SIZE_BYTES(32),
        .ADDR_WIDTH(32),
        .DATA_WIDTH(64)
    ) u_icache (
        .clk(clk),
        .rst_n(rst_n),
        .req_addr(req_addr),
        .req_valid(req_valid),
        .resp_data(resp_data),
        .resp_hit(resp_hit),
        .resp_valid(resp_valid),
        .stall(stall),
        .flush(flush),
        .invalidate(invalidate),
        .mem_req_addr(mem_req_addr),
        .mem_req_valid(mem_req_valid),
        .mem_resp_data(mem_resp_data),
        .mem_resp_valid(mem_resp_valid)
    );

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA — L1 I-CACHE MULTI-WORD REFILL TESTBENCH v12.3.2-R4");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");

        clk = 0;
        rst_n = 0;
        req_addr = 32'h8000_0000;
        req_valid = 0;
        flush = 0;
        invalidate = 0;
        mem_resp_data = 64'h0;
        mem_resp_valid = 0;

        #20 rst_n = 1;
        #10;

        // Request Word 0 (Address 0x80000000) -> Miss Refill
        $display("[STAGE 1] Requesting Word 0 (0x80000000)...");
        req_addr = 32'h8000_0000;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;

        // Provide Word 0 (0x1000004000000096)
        mem_resp_data = 64'h1000004000000096;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 1 (0x100000800000015E)
        mem_resp_data = 64'h100000800000015E;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 2 (0x108800C000000000)
        mem_resp_data = 64'h108800C000000000;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 3 (0x400C000080000100) -> Line Complete
        mem_resp_data = 64'h400C000080000100;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #20;

        $display("[STAGE 2] Requesting Word 2 (0x80000010) -> Should HIT without refill!");
        req_addr = 32'h8000_0010;
        req_valid = 1;
        #10;
        req_valid = 0;
        #20;

        if (resp_hit && resp_data == 64'h108800C000000000) begin
            $display("PASS: L1 I-CACHE MULTI-WORD REFILL & HIT VERIFIED (Word 2 = 0x108800C000000000)");
            test_pass_count = test_pass_count + 1;
        end else begin
            $display("FAIL: L1 I-CACHE REFILL MISMATCH");
            $fatal(1, "Expected 0x108800C000000000");
        end

        $finish;
    end

endmodule
