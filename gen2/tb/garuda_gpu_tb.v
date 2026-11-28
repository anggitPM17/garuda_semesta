`timescale 1ns / 1ps

module garuda_gpu_tb;
    reg clk;
    reg rst_n;
    reg v_valid;
    reg [2:0] vop;
    reg [3:0] vmask;
    reg [3:0] vs1_addr;
    reg [3:0] vs2_addr;
    reg [3:0] vd_addr;
    wire v_ready;
    wire v_done;

    garuda_vpu_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .v_valid(v_valid),
        .vop(vop),
        .vmask(vmask),
        .vs1_addr(vs1_addr),
        .vs2_addr(vs2_addr),
        .vd_addr(vd_addr),
        .v_ready(v_ready),
        .v_done(v_done)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN3 — ADVANCED GPU / VPU SIMULATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        v_valid = 0;
        vmask = 4'b1111;
        #20;
        rst_n = 1;

        // Preload Vector Registers
        uut.vrf_inst.vregs[1] = 128'h00000004_00000003_00000002_00000001; // [4, 3, 2, 1]
        uut.vrf_inst.vregs[2] = 128'h0000000a_00000009_00000008_00000007; // [10, 9, 8, 7]
        uut.vrf_inst.vregs[5] = 128'h00000064_00000064_00000064_00000064; // [100, 100, 100, 100]

        #10;
        // Test 1: VMACC.VV -> v5 = v5 + (v1 * v2) [Tensor MAC operation]
        v_valid  = 1'b1;
        vop      = 3'b010; // VMACC
        vmask    = 4'b1111;
        vs1_addr = 4'd1;
        vs2_addr = 4'd2;
        vd_addr  = 4'd5;
        #10;
        v_valid  = 1'b0;
        #20;

        $display("VMACC Result v5 = %h (Expected: 0000008c_0000007f_00000074_0000006b)", uut.vrf_inst.vregs[5]);

        if (uut.vrf_inst.vregs[5] === 128'h0000008c_0000007f_00000074_0000006b) begin
            $display("PASS: Vector Multiply-Accumulate (VMACC.VV) verified successfully.");
        end else begin
            $display("FAIL: Vector MAC mismatch!");
            $fatal(1, "VMACC FAILED");
        end

        $display("\n=========================================================");
        $display(" >>> ALL GEN3 GPU / VPU TESTS PASSED — SUCCESS (PASS) <<<");
        $display("=========================================================");
        $finish;
    end
endmodule
