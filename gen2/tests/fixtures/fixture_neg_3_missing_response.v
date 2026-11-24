`timescale 1ns / 1ps
// NEG-03: Fault Injection Fixture — Deliberately Suppressed Response
module fixture_neg_3_missing_response;
    garuda_rv64i_core_tb tb ();

    initial begin
        wait (tb.dmem_valid);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Suppressing response valid signal permanently...");
        // Suppress response valid, this should trigger watchdog or outstanding tx mismatch
        force tb.mem_model.dmem_resp_valid = 1'b0;
        // Suppress payload stability checker to let the timeout occur
        force tb.tb_resp_ready_mask = 1'b1;
    end
endmodule
