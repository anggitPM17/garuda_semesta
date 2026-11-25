`timescale 1ns / 1ps
// NEG-02: Fault Injection Fixture — Genuine Duplicate Store Commit
module fixture_neg_2_duplicate_store;
    garuda_rv64i_core_tb tb ();

    initial begin
        // Wait until first store transaction response handshake is active
        wait (tb.dmem_valid && tb.dmem_wen && tb.dmem_resp_valid && tb.dmem_resp_ready_core);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Injecting duplicate store commit event into memory model...");
        // Re-enable commit logic for same request by forcing tx_committed low
        force tb.mem_model.tx_committed = 1'b0;
        @(posedge tb.clk);
        release tb.mem_model.tx_committed;
    end
endmodule
