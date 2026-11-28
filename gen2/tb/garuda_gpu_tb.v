`timescale 1ns / 1ps

module garuda_gpu_tb;
    reg clk;
    reg rst_n;
    reg v_valid;
    reg [2:0] vop;
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
        .vs1_addr(vs1_addr),
        .vs2_addr(vs2_addr),
        .vd_addr(vd_addr),
        .v_ready(v_ready),
        .v_done(v_done)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN3 — GPU / VPU SIMULATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;
        v_valid = 0;
        #20;
        rst_n = 1;

        // Preload Vector Register 1 and 2 directly for test verification
        uut.vrf_inst.vregs[1] = 128'h00000004_00000003_00000002_00000001; // [4, 3, 2, 1]
        uut.vrf_inst.vregs[2] = 128'h0000000a_00000009_00000008_00000007; // [10, 9, 8, 7]

        #10;
        // Test 1: VADD.VV -> v3 = v1 + v2
        v_valid  = 1'b1;
        vop      = 3'b000; // VADD
        vs1_addr = 4'd1;
        vs2_addr = 4'd2;
        vd_addr  = 4'd3;
        #10;
        v_valid  = 1'b0;
        #20;

        $display("VADD Result v3 = %h (Expected: 0000000e_0000000c_0000000a_00000008)", uut.vrf_inst.vregs[3]);

        if (uut.vrf_inst.vregs[3] === 128'h0000000e_0000000c_0000000a_00000008) begin
            $display("PASS: Vector Addition (VADD.VV) verified successfully.");
        end else begin
            $display("FAIL: Vector Addition mismatch!");
            $fatal(1, "VADD FAILED");
        end

        // Test 2: VMUL.VV -> v4 = v1 * v2
        v_valid  = 1'b1;
        vop      = 3'b001; // VMUL
        vs1_addr = 4'd1;
        vs2_addr = 4'd2;
        vd_addr  = 4'd4;
        #10;
        v_valid  = 1'b0;
        #20;

        $display("VMUL Result v4 = %h (Expected: 00000028_0000001b_00000010_00000007)", uut.vrf_inst.vregs[4]);

        if (uut.vrf_inst.vregs[4] === 128'h00000028_0000001b_00000010_00000007) begin
            $display("PASS: Vector Multiplication (VMUL.VV) verified successfully.");
        end else begin
            $display("FAIL: Vector Multiplication mismatch!");
            $fatal(1, "VMUL FAILED");
        end

        $display("\n=========================================================");
        $display(" >>> ALL GEN3 GPU / VPU TESTS PASSED — SUCCESS (PASS) <<<");
        $display("=========================================================");
        $finish;
    end
endmodule
