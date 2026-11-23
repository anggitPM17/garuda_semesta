`timescale 1ns / 1ps
module tb_rv64i_alu_1;
    reg [3:0] alu_op;
    reg [63:0] operand_a, operand_b;
    wire [63:0] result;
    wire zero_flag;

    rv64i_alu uut (
        .alu_op(alu_op),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result(result),
        .zero_flag(zero_flag)
    );

    initial begin
        $display("=== START tb_rv64i_alu_1 ===");
        alu_op = 4'h0; operand_a = 64'd10; operand_b = 64'd20; #10;
        if (result !== 64'd30) begin $display("FAIL: ADD 10+20 = %d", result); $finish; end

        alu_op = 4'h1; operand_a = 64'd50; operand_b = 64'd20; #10;
        if (result !== 64'd30) begin $display("FAIL: SUB 50-20 = %d", result); $finish; end

        alu_op = 4'h2; operand_a = 64'hF0F0; operand_b = 64'h0FFF; #10;
        if (result !== 64'h00F0) begin $display("FAIL: AND"); $finish; end

        $display("PASS: tb_rv64i_alu_1 all tests passed successfully.");
        $finish;
    end
endmodule
