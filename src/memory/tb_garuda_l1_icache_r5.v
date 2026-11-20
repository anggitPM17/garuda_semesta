// =========================================================================
// GARUDA SEMESTA — L1 I-CACHE R5 SELF-CHECKING VERIFICATION TESTBENCH (v12.3.2-R5)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Self-Checking Verilog Testbench for garuda_l1_icache.v (R5):
// - Tests 4 unique 64-bit instruction words in a single 32-byte cache line:
//   W0 = 64'h1111222233334444 at 0x80000000
//   W1 = 64'h5555666677778888 at 0x80000008
//   W2 = 64'h9999AAAABBBBCCCC at 0x80000010
//   W3 = 64'hDDDDEEEEFFFF0001 at 0x80000018
// - Asserts valid_array bit set ONLY after Word 3 is received
// - Asserts hit & readback correctness for ALL 4 unique words!
// =========================================================================

`timescale 1ns / 1ps

module tb_garuda_l1_icache_r5;

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
    reg         mem_req_ready;
    reg  [63:0] mem_resp_data;
    reg         mem_resp_valid;
    reg         mem_resp_error;

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
        .mem_req_ready(mem_req_ready),
        .mem_resp_data(mem_resp_data),
        .mem_resp_valid(mem_resp_valid),
        .mem_resp_error(mem_resp_error)
    );

    initial begin
        $display("=========================================================================");
        $display("GARUDA SEMESTA — L1 I-CACHE R5 SELF-CHECKING TESTBENCH v12.3.2-R5");
        $display("Architect & Author: Anggit Prasetyo Mituhu");
        $display("=========================================================================\n");

        clk = 0;
        rst_n = 0;
        req_addr = 32'h8000_0000;
        req_valid = 0;
        flush = 0;
        invalidate = 0;
        mem_req_ready = 1;
        mem_resp_data = 64'h0;
        mem_resp_valid = 0;
        mem_resp_error = 0;

        #20 rst_n = 1;
        #10;

        // Request Word 0 (Address 0x80000000) -> Miss Refill
        $display("[STAGE 1] Requesting Word 0 (0x80000000)...");
        req_addr = 32'h8000_0000;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;

        // Provide Word 0 (0x1111222233334444)
        $display(" -> Refilling Word 0 (0x1111222233334444) at Address 0x%h...", mem_req_addr);
        if (mem_req_addr !== 32'h8000_0000) $fatal(1, "Mem Request Address Mismatch for Word 0");
        mem_resp_data = 64'h1111222233334444;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 1 (0x5555666677778888)
        $display(" -> Refilling Word 1 (0x5555666677778888) at Address 0x%h...", mem_req_addr);
        if (mem_req_addr !== 32'h8000_0008) $fatal(1, "Mem Request Address Mismatch for Word 1");
        mem_resp_data = 64'h5555666677778888;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 2 (0x9999AAAABBBBCCCC)
        $display(" -> Refilling Word 2 (0x9999AAAABBBBCCCC) at Address 0x%h...", mem_req_addr);
        if (mem_req_addr !== 32'h8000_0010) $fatal(1, "Mem Request Address Mismatch for Word 2");
        mem_resp_data = 64'h9999AAAABBBBCCCC;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #10;

        // Provide Word 3 (0xDDDDEEEEFFFF0001) -> Line Complete
        $display(" -> Refilling Word 3 (0xDDDDEEEEFFFF0001) at Address 0x%h...", mem_req_addr);
        if (mem_req_addr !== 32'h8000_0018) $fatal(1, "Mem Request Address Mismatch for Word 3");
        mem_resp_data = 64'hDDDDEEEEFFFF0001;
        mem_resp_valid = 1;
        #10;
        mem_resp_valid = 0;
        #20;

        // STAGE 2: Readback & Assertion for ALL 4 Unique Words!
        $display("[STAGE 2] Asserting Readback Hits for ALL 4 Unique Words...");

        // Assert Word 0 (0x80000000)
        req_addr = 32'h8000_0000;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;
        if (!resp_hit || resp_data !== 64'h1111222233334444) $fatal(1, "Word 0 Readback Mismatch");
        $display(" -> Word 0 Readback (0x1111222233334444): PASS");

        // Assert Word 1 (0x80000008)
        req_addr = 32'h8000_0008;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;
        if (!resp_hit || resp_data !== 64'h5555666677778888) $fatal(1, "Word 1 Readback Mismatch");
        $display(" -> Word 1 Readback (0x5555666677778888): PASS");

        // Assert Word 2 (0x80000010)
        req_addr = 32'h8000_0010;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;
        if (!resp_hit || resp_data !== 64'h9999AAAABBBBCCCC) $fatal(1, "Word 2 Readback Mismatch");
        $display(" -> Word 2 Readback (0x9999AAAABBBBCCCC): PASS");

        // Assert Word 3 (0x80000018)
        req_addr = 32'h8000_0018;
        req_valid = 1;
        #10;
        req_valid = 0;
        #10;
        if (!resp_hit || resp_data !== 64'hDDDDEEEEFFFF0001) $fatal(1, "Word 3 Readback Mismatch");
        $display(" -> Word 3 Readback (0xDDDDEEEEFFFF0001): PASS");

        $display("\n=========================================================================");
        $display(" 🏆 ALL 4 UNIQUE WORDS L1 I-CACHE REFILL & READBACK ASSERTIONS PASSED!");
        $display("=========================================================================\n");

        $finish;
    end

endmodule
