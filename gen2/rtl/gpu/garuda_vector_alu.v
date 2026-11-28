`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — SIMD Vector ALU (4 Parallel 32-bit Lanes)
module garuda_vector_alu (
    input  wire [2:0]  vop,          // Vector operation selector
    input  wire [127:0] v_op_a,       // Vector operand A (4 x 32-bit elements)
    input  wire [127:0] v_op_b,       // Vector operand B (4 x 32-bit elements)
    output reg  [127:0] v_result      // Vector result (4 x 32-bit elements)
);

    always @(*) begin
        case (vop)
            3'b000: begin // VADD.VV (4 x 32-bit addition)
                v_result[31:0]    = v_op_a[31:0]    + v_op_b[31:0];
                v_result[63:32]   = v_op_a[63:32]   + v_op_b[63:32];
                v_result[95:64]   = v_op_a[95:64]   + v_op_b[95:64];
                v_result[127:96]  = v_op_a[127:96]  + v_op_b[127:96];
            end
            3'b001: begin // VMUL.VV (4 x 32-bit multiplication)
                v_result[31:0]    = v_op_a[31:0]    * v_op_b[31:0];
                v_result[63:32]   = v_op_a[63:32]   * v_op_b[63:32];
                v_result[95:64]   = v_op_a[95:64]   * v_op_b[95:64];
                v_result[127:96]  = v_op_a[127:96]  * v_op_b[127:96];
            end
            default: v_result = 128'd0;
        endcase
    end

endmodule
