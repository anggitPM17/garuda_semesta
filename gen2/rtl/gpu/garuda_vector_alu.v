`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — Advanced SIMD Vector ALU (Masking & Multiply-Accumulate)
module garuda_vector_alu (
    input  wire [2:0]  vop,          // Vector operation selector
    input  wire [3:0]  vmask,        // Lane mask (1 bit per 32-bit lane)
    input  wire [127:0] v_op_a,       // Vector operand A (4 x 32-bit elements)
    input  wire [127:0] v_op_b,       // Vector operand B (4 x 32-bit elements)
    input  wire [127:0] v_op_acc,     // Accumulator operand for VMACC
    output reg  [127:0] v_result      // Vector result (4 x 32-bit elements)
);

    always @(*) begin
        v_result = v_op_acc;
        case (vop)
            3'b000: begin // VADD.VV (4 x 32-bit addition with masking)
                if (vmask[0]) v_result[31:0]   = v_op_a[31:0]   + v_op_b[31:0];
                if (vmask[1]) v_result[63:32]  = v_op_a[63:32]  + v_op_b[63:32];
                if (vmask[2]) v_result[95:64]  = v_op_a[95:64]  + v_op_b[95:64];
                if (vmask[3]) v_result[127:96] = v_op_a[127:96] + v_op_b[127:96];
            end
            3'b001: begin // VMUL.VV (4 x 32-bit multiplication with masking)
                if (vmask[0]) v_result[31:0]   = v_op_a[31:0]   * v_op_b[31:0];
                if (vmask[1]) v_result[63:32]  = v_op_a[63:32]  * v_op_b[63:32];
                if (vmask[2]) v_result[95:64]  = v_op_a[95:64]  * v_op_b[95:64];
                if (vmask[3]) v_result[127:96] = v_op_a[127:96] * v_op_b[127:96];
            end
            3'b010: begin // VMACC.VV (Vector Multiply-Accumulate for AI/ML)
                if (vmask[0]) v_result[31:0]   = v_op_acc[31:0]   + (v_op_a[31:0]   * v_op_b[31:0]);
                if (vmask[1]) v_result[63:32]  = v_op_acc[63:32]  + (v_op_a[63:32]  * v_op_b[63:32]);
                if (vmask[2]) v_result[95:64]  = v_op_acc[95:64]  + (v_op_a[95:64]  * v_op_b[95:64]);
                if (vmask[3]) v_result[127:96] = v_op_acc[127:96] + (v_op_a[127:96] * v_op_b[127:96]);
            end
            default: v_result = v_op_acc;
        endcase
    end

endmodule
