`timescale 1ns / 1ps
module rv64i_alu (
    input  wire [3:0]  alu_op,
    input  wire [63:0] operand_a,
    input  wire [63:0] operand_b,
    output reg  [63:0] result,
    output wire        zero_flag
);
    assign zero_flag = (result == 64'd0);

    always @(*) begin
        case (alu_op)
            4'h0: result = operand_a + operand_b;
            4'h1: result = operand_a - operand_b;
            4'h2: result = operand_a & operand_b;
            4'h3: result = operand_a | operand_b;
            4'h4: result = operand_a ^ operand_b;
            4'h5: result = operand_a << operand_b[5:0];
            4'h6: result = operand_a >> operand_b[5:0];
            4'h7: result = $signed(operand_a) >>> operand_b[5:0];
            4'h8: result = ($signed(operand_a) < $signed(operand_b)) ? 64'd1 : 64'd0;
            4'h9: result = (operand_a < operand_b) ? 64'd1 : 64'd0;
            4'hA: result = operand_b; // LUI pass-through
            default: result = 64'd0;
        endcase
    end
endmodule
