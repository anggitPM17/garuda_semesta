`timescale 1ns / 1ps
module tb_rv64i_system_decode;
    reg [31:0] inst;
    wire is_ecall, is_ebreak, is_mret, is_fence;

    rv64i_system_decode uut (
        .inst(inst), .is_ecall(is_ecall), .is_ebreak(is_ebreak), .is_mret(is_mret), .is_fence(is_fence)
    );

    initial begin
        $display("=== START tb_rv64i_system_decode ===");
        inst = 32'h00000073; #10;
        if (!is_ecall) begin $display("FAIL: ecall decode"); $finish; end
        $display("PASS: tb_rv64i_system_decode passed.");
        $finish;
    end
endmodule
