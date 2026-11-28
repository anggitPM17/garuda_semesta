`timescale 1ns / 1ps
module tb_rv64i_decode;
    reg [31:0] inst;
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [63:0] imm;

    rv64i_decode uut (
        .inst(inst),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm(imm)
    );

    initial begin
        $display("=== START tb_rv64i_decode ===");
        inst = 32'h02a00513; #10;
        if (opcode !== 7'b0010011 || rd !== 5'd10 || imm !== 64'd42) begin
            $display("FAIL: decode ADDI opcode=%b rd=%d imm=%d", opcode, rd, imm);
            $finish;
        end

        $display("PASS: tb_rv64i_decode passed.");
        $finish;
    end
endmodule
