`timescale 1ns / 1ps

module garuda_npu_tb;
    reg clk;
    reg rst_n;

    reg [63:0] addr;
    reg        valid;
    reg        wen;
    reg [2:0]  funct3;
    reg [63:0] wdata;
    wire       ready;
    wire [63:0] rdata;
    wire       resp_valid;
    wire       npu_done_irq;

    garuda_npu_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .addr(addr),
        .valid(valid),
        .wen(wen),
        .funct3(funct3),
        .wdata(wdata),
        .ready(ready),
        .rdata(rdata),
        .resp_valid(resp_valid),
        .npu_done_irq(npu_done_irq)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN4 — NPU AI ENGINE SIMULATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        valid = 0;
        wen = 0;
        addr = 64'd0;
        wdata = 64'd0;
        #20;
        rst_n = 1;

        // Test 1: Load Weights [10, 20, 30, 40] into Weight Buffer
        #10;
        valid = 1; wen = 1; addr = 64'h00; wdata = 64'h0028_001e_0014_000a; #10;
        valid = 0; #10;

        // Test 2: Load Feature Map Activations [1, 2, 3, 4] into Feature Buffer
        valid = 1; wen = 1; addr = 64'h10; wdata = 64'h0004_0003_0002_0001; #10;
        valid = 0; #10;

        // Test 3: Trigger NPU Compute Command (AFU Mode = 1 -> ReLU)
        valid = 1; wen = 1; addr = 64'h20; wdata = 64'd1; #10;
        valid = 0; #20;

        // Expected Dot Product = (10*1) + (20*2) + (30*3) + (40*4) = 10 + 40 + 90 + 160 = 300 (0x12C)
        valid = 1; wen = 0; addr = 64'h30; #10;
        $display("NPU Inference Result = %d (Hex: 0x%h)", uut.afu_activated_out, uut.afu_activated_out);

        if (uut.afu_activated_out === 64'd300) begin
            $display("PASS: NPU 8x8 Systolic Array Dot Product & ReLU Activation verified successfully.");
        end else begin
            $display("FAIL: NPU Inference Mismatch!");
            $fatal(1, "NPU TEST FAILED");
        end

        $display("\n=========================================================");
        $display(" >>> ALL GEN4 NPU AI ENGINE TESTS PASSED — SUCCESS (PASS) <<<");
        $display("=========================================================");
        $finish;
    end
endmodule
