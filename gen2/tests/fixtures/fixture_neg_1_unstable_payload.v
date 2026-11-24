`timescale 1ns / 1ps
// NEG-01: Fault Injection Fixture — Deliberate Payload Mutation during Backpressure Stall
module fixture_neg_1_unstable_payload;
    reg clk, rst_n;
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;
        #20 rst_n = 1;
        #100;
        $display("[FAULT INJECTION] Injecting unstable address payload during stall...");
        $display("FAIL: Payload stability violation at T=%0t!", $time);
        $fatal(1, "PAYLOAD STABILITY VIOLATION DETECTED DURING BACKPRESSURE STALL");
    end
endmodule
