`timescale 1ns / 1ps
// NEG-04: Fault Injection Fixture — Real Transaction Mismatch Fault
module fixture_neg_4_count_mismatch;
    garuda_rv64i_core_tb tb ();

    initial begin
        wait (tb.tb_accepted_count == 8);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Injecting transaction request count mismatch into independent scoreboard...");
        force tb.tb_accepted_count = 9;
    end
endmodule
