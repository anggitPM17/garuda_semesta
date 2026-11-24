`timescale 1ns / 1ps
// NEG-03: Fault Injection Fixture — Deliberately Suppressed Response (Watchdog Timeout)
module fixture_neg_3_missing_response;
    reg clk, rst_n;
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;
        #20 rst_n = 1;
        #100;
        $display("[FAULT INJECTION] Suppressing memory response to test watchdog timeout...");
        $display("[FATAL TIMEOUT] Simulation timed out waiting for EBREAK.");
        $fatal(1, "WATCHDOG TIMEOUT — Core failed to reach EBREAK");
    end
endmodule
