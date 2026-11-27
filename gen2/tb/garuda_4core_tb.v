`timescale 1ns / 1ps

module garuda_4core_tb;
    reg clk;
    reg rst_n;
    wire [3:0] core_halted_out;

    garuda_4core_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .core_halted_out(core_halted_out)
    );

    always #5 clk = ~clk;

    // Watchdog timer
    initial begin
        #2000000;
        $display("\n=========================================================");
        $display("[FATAL TIMEOUT] 4-Core simulation timed out waiting for EBREAK.");
        $display(">>> TEST RESULT: FAILURE (FAIL) <<<");
        $display("=========================================================");
        $fatal(1, "4-CORE WATCHDOG TIMEOUT");
    end

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — 4-CORE MULTICORE SIMULATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        #20;
        rst_n = 1;

        // Wait for all 4 harts to halt (EBREAK executed)
        wait (&core_halted_out);
        #50;

        $display("\n=== 4-CORE EXECUTION ASSERTIONS ===");
        $display("Hart 0 Halted = %b", core_halted_out[0]);
        $display("Hart 1 Halted = %b", core_halted_out[1]);
        $display("Hart 2 Halted = %b", core_halted_out[2]);
        $display("Hart 3 Halted = %b", core_halted_out[3]);

        if (core_halted_out === 4'b1111) begin
            $display("\n=========================================================");
            $display(" >>> ALL 4 HARTS REACHED EBREAK — SUCCESS (PASS) <<<");
            $display("=========================================================");
            $finish;
        end else begin
            $display("\n=========================================================");
            $display(" >>> 4-CORE EXECUTION FAILED — NOT ALL HARTS HALTED <<<");
            $display("=========================================================");
            $fatal(1, "4-CORE EXECUTION FAILED");
        end
    end
endmodule
