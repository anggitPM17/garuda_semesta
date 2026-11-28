`timescale 1ns / 1ps

module garuda_4core_sync_tb;
    reg clk;
    reg rst_n;
    wire [3:0] core_halted_out;
    wire [3:0] timer_interrupt_out;
    wire [3:0] software_interrupt_out;

    garuda_4core_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .core_halted_out(core_halted_out),
        .timer_interrupt_out(timer_interrupt_out),
        .software_interrupt_out(software_interrupt_out)
    );

    always #5 clk = ~clk;

    // Watchdog timer
    initial begin
        #3000000;
        $display("\n=========================================================");
        $display("[FATAL TIMEOUT] 4-Core Sync simulation timed out waiting for EBREAK.");
        $display(">>> TEST RESULT: FAILURE (FAIL) <<<");
        $display("=========================================================");
        $fatal(1, "4-CORE SYNC WATCHDOG TIMEOUT");
    end

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — 4-CORE MULTICORE SYNCHRONIZATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        #20;
        rst_n = 1;

        // Wait for all 4 harts to halt (EBREAK executed)
        wait (&core_halted_out);
        #50;

        $display("\n=== 4-CORE SYNCHRONIZATION ASSERTIONS ===");
        $display("Hart 0 Halted = %b (Timer IRQ = %b, SW IRQ = %b)", core_halted_out[0], timer_interrupt_out[0], software_interrupt_out[0]);
        $display("Hart 1 Halted = %b (Timer IRQ = %b, SW IRQ = %b)", core_halted_out[1], timer_interrupt_out[1], software_interrupt_out[1]);
        $display("Hart 2 Halted = %b (Timer IRQ = %b, SW IRQ = %b)", core_halted_out[2], timer_interrupt_out[2], software_interrupt_out[2]);
        $display("Hart 3 Halted = %b (Timer IRQ = %b, SW IRQ = %b)", core_halted_out[3], timer_interrupt_out[3], software_interrupt_out[3]);

        if (core_halted_out === 4'b1111) begin
            $display("\n=========================================================");
            $display(" >>> ALL 4 HARTS REACHED EBREAK & SYNC PASSED — SUCCESS (PASS) <<<");
            $display("=========================================================");
            $finish;
        end else begin
            $display("\n=========================================================");
            $display(" >>> 4-CORE SYNC EXECUTION FAILED — NOT ALL HARTS HALTED <<<");
            $display("=========================================================");
            $fatal(1, "4-CORE SYNC EXECUTION FAILED");
        end
    end
endmodule
