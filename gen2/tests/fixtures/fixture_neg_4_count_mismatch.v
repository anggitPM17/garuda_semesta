`timescale 1ns / 1ps
// NEG-04: Fault Injection Fixture — Scoreboard Transaction Count Mismatch
module fixture_neg_4_count_mismatch;
    garuda_rv64i_core_tb tb ();

    initial begin
        wait (tb.tb_accepted_count == 2);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Corrupting independent scoreboard accepted count...");
        force tb.tb_accepted_count = 99; // Corrupt independent scoreboard count
        @(posedge tb.clk);
        release tb.tb_accepted_count;
    end
endmodule
