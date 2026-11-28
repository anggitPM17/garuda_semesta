`timescale 1ns / 1ps
// NEG-01: Fault Injection Fixture — Deliberate Payload Mutation during Backpressure Stall
module fixture_neg_1_unstable_payload;
    // Instantiate the real testbench but inject a fault during backpressure
    garuda_rv64i_core_tb tb ();

    initial begin
        // Wait until core enters first memory transaction response (valid && ready_in == 0)
        wait (tb.dmem_valid && tb.dmem_resp_valid && !tb.tb_resp_ready_mask);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Mutating dmem_addr payload mid-transaction stall...");
        // Force the core's address output to mutate, which should be caught by tb stability monitor
        force tb.uut.dmem_addr = 64'hDEADBEEF;
        @(posedge tb.clk);
        release tb.uut.dmem_addr;
    end
endmodule
