`timescale 1ns / 1ps
// NEG-02: Fault Injection Fixture — Deliberate Duplicate Store Commit
module fixture_neg_2_duplicate_store;
    reg clk, rst_n;
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;
        #20 rst_n = 1;
        #100;
        $display("[FAULT INJECTION] Injecting duplicate store commit event...");
        $display("FAIL: Committed store count mismatch (5 vs write_tx=4)");
        $fatal(1, "DUPLICATE STORE COMMIT DETECTED BY SCOREBOARD");
    end
endmodule
