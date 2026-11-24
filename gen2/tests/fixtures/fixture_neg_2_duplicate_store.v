`timescale 1ns / 1ps
// NEG-02: Fault Injection Fixture — Deliberate Duplicate Store Commit
module fixture_neg_2_duplicate_store;
    garuda_rv64i_core_tb tb ();

    initial begin
        // Wait until first store commit
        wait (tb.mem_model.tx_committed || (tb.mem_model.dmem_state == 2'b10 && tb.tb_resp_ready_mask));
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Forcing duplicate store commit on mem_model...");
        // Force the committed store counter to double-count
        force tb.mem_model.committed_store_count = tb.mem_model.committed_store_count + 1;
        @(posedge tb.clk);
        release tb.mem_model.committed_store_count;
    end
endmodule
