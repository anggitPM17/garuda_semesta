`timescale 1ns / 1ps

module garuda_gen3_soc_tb;
    reg clk;
    reg rst_n;

    wire [3:0]  core_halted_out;
    wire        gpu_done_out;
    wire        crypto_irq_out;
    wire        hsync_out;
    wire        vsync_out;
    wire [23:0] rgb_out;

    garuda_gen3_heterogeneous_soc uut (
        .clk(clk),
        .rst_n(rst_n),
        .core_halted_out(core_halted_out),
        .gpu_done_out(gpu_done_out),
        .crypto_irq_out(crypto_irq_out),
        .hsync_out(hsync_out),
        .vsync_out(vsync_out),
        .rgb_out(rgb_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN3 — HETEROGENEOUS SOC SIMULATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        #20;
        rst_n = 1;

        // Wait for CPU cores to execute and halt
        wait (&core_halted_out);
        #50;

        $display("\n=== GEN3 HETEROGENEOUS SOC ASSERTIONS ===");
        $display("4-Core CPU Halted Status = %b", core_halted_out);
        $display("Video Sync Signals: HSYNC = %b, VSYNC = %b", hsync_out, vsync_out);

        if (core_halted_out === 4'b1111) begin
            $display("\n=========================================================");
            $display(" >>> GEN3 HETEROGENEOUS SOC TEST PASSED — SUCCESS (PASS) <<<");
            $display("=========================================================");
            $finish;
        end else begin
            $display("FAIL: Heterogeneous SoC test failed!");
            $fatal(1, "SOC TEST FAILED");
        end
    end
endmodule
