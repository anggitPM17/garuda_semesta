`timescale 1ns / 1ps
module tb_rv64i_alu_2;
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
        $display("=== START tb_rv64i_alu_2 ===");
        alu_op = 4'h3; operand_a = 64'hF000; operand_b = 64'h000F; #10;
        if (result !== 64'hF00F) begin $display("FAIL: OR"); $finish; end

        alu_op = 4'h4; operand_a = 64'hFFFF; operand_b = 64'h0FF0; #10;
        if (result !== 64'hF00F) begin $display("FAIL: XOR"); $finish; end

        alu_op = 4'h5; operand_a = 64'd1; operand_b = 64'd4; #10;
        if (result !== 64'd16) begin $display("FAIL: SLL"); $finish; end

        $display("PASS: tb_rv64i_alu_2 all tests passed successfully.");
        $finish;
    end
endmodule
