`timescale 1ns / 1ps
module tb_rv64i_control_flow;
    reg [63:0] pc_current, rs1_val, rs2_val, imm;
    reg [2:0] funct3;
    reg [6:0] opcode;
    wire branch_taken;
    wire [63:0] target_pc;

    rv64i_control_flow uut (
        .pc_current(pc_current),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .imm(imm),
        .funct3(funct3),
        .opcode(opcode),
        .branch_taken(branch_taken),
        .target_pc(target_pc)
    );

    initial begin
        $display("=== START tb_rv64i_control_flow ===");
        pc_current = 64'h1000; rs1_val = 64'd10; rs2_val = 64'd10; imm = 64'd100;
        opcode = 7'b1100011; funct3 = 3'b000; #10;
        if (!branch_taken || target_pc !== 64'h1064) begin
            $display("FAIL: BEQ taken"); $finish; end

        $display("PASS: tb_rv64i_control_flow passed.");
        $finish;
    end
endmodule
