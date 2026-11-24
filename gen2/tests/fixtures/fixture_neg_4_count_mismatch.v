`timescale 1ns / 1ps
// NEG-04: Fault Injection Fixture — Scoreboard Transaction Count Mismatch
module fixture_neg_4_count_mismatch;
    reg clk, rst_n;
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;
        #20 rst_n = 1;
        #100;
        $display("[FAULT INJECTION] Injecting transaction count expectation mismatch...");
        $display("FAIL: Read transaction count mismatch (0, expected 4)");
        $fatal(1, "TRANSACTION COUNT MISMATCH DETECTED BY SCOREBOARD");
    end
endmodule
