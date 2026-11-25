`timescale 1ns / 1ps
// NEG-03: Fault Injection Fixture — Deliberately Suppressed Response
module fixture_neg_3_missing_response;
    garuda_rv64i_core_tb tb ();

    initial begin
        // Force testbench backpressure mask to 1 so payload stability monitor is idle
        force tb.tb_resp_ready_mask = 1'b1;
        wait (tb.dmem_valid && tb.dmem_ready);
        @(posedge tb.clk);
        $display("[FAULT INJECTION] Suppressing response valid signal permanently...");
        // Suppress response valid permanently, triggering response timeout watchdog
        force tb.mem_model.dmem_resp_valid = 1'b0;
    end
endmodule
