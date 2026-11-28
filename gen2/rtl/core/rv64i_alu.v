`timescale 1ns / 1ps
module rv64i_alu (
    input  wire [4:0]  alu_op,
    input  wire [63:0] operand_a,
    input  wire [63:0] operand_b,
    output reg  [63:0] result,
    output wire        zero_flag
);
    assign zero_flag = (result == 64'd0);

    reg [127:0] signed_prod;
    reg [127:0] unsigned_prod;

    always @(*) begin
        signed_prod   = $signed(operand_a) * $signed(operand_b);
        unsigned_prod = {64'd0, operand_a} * {64'd0, operand_b};

        case (alu_op)
            5'h0: result = operand_a + operand_b;
            5'h1: result = operand_a - operand_b;
            5'h2: result = operand_a & operand_b;
            5'h3: result = operand_a | operand_b;
            5'h4: result = operand_a ^ operand_b;
            5'h5: result = operand_a << operand_b[5:0];
            5'h6: result = operand_a >> operand_b[5:0];
            5'h7: result = $signed(operand_a) >>> operand_b[5:0];
            5'h8: result = ($signed(operand_a) < $signed(operand_b)) ? 64'd1 : 64'd0;
            5'h9: result = (operand_a < operand_b) ? 64'd1 : 64'd0;
            5'hA: result = operand_b; // LUI pass-through
            // RV64IM M-Extension Operations
            5'hB: result = operand_a * operand_b; // MUL (lower 64 bits)
            5'hC: result = signed_prod[127:64];     // MULH (signed x signed high)
            5'hD: result = unsigned_prod[127:64];   // MULHU (unsigned x unsigned high)
            5'hE: result = (operand_b == 64'd0) ? ~64'd0 : ($signed(operand_a) / $signed(operand_b)); // DIV
            5'hF: result = (operand_b == 64'd0) ? ~64'd0 : (operand_a / operand_b);                   // DIVU
            5'h10: result = (operand_b == 64'd0) ? operand_a : ($signed(operand_a) % $signed(operand_b)); // REM
            5'h11: result = (operand_b == 64'd0) ? operand_a : (operand_a % operand_b);                   // REMU
            default: result = 64'd0;
        endcase
    end
endmodule
