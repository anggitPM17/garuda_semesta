`timescale 1ns / 1ps
// NEG-02: Fault Injection Fixture — Genuine Duplicate Store Commit Event
module fixture_neg_2_duplicate_store;
    garuda_rv64i_core_tb tb ();

    initial begin
        // Wait until first store transaction response completes
        wait (tb.tb_response_accept && tb.dmem_wen);
        $display("[FAULT INJECTION] Injecting second commit event for the same store transaction...");
        // Re-drive response valid and store write on next clock edge to force duplicate commit event for same TX ID
        force tb.mem_model.dmem_resp_valid = 1'b1;
        force tb.uut.ex_mem_mem_write = 1'b1;
        @(posedge tb.clk);
        release tb.mem_model.dmem_resp_valid;
        release tb.uut.ex_mem_mem_write;
    end
endmodule
