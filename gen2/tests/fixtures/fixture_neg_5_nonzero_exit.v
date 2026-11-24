`timescale 1ns / 1ps
// NEG-05: Fault Injection Fixture — Deliberate Non-Zero Simulator Exit
module fixture_neg_5_nonzero_exit;
    reg clk;
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        #50;
        $display("[FAULT INJECTION] Triggering $fatal in simulator fixture...");
        $fatal(1, "DELIBERATE SIMULATOR FATAL EXIT");
    end
endmodule
