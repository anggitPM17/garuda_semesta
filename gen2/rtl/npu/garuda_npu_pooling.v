`timescale 1ns / 1ps
// GARUDA SEMESTA GEN4 — NPU Hardware Pooling Unit (2x2 Max-Pooling & Avg-Pooling)
module garuda_npu_pooling (
    input  wire [1:0]  pool_type, // 00 = Bypass, 01 = Max-Pool 2x2, 10 = Avg-Pool 2x2
    input  wire [127:0] data_in,   // 4 x 32-bit elements [el3, el2, el1, el0]
    output reg  [31:0]  data_out
);

    wire signed [31:0] e0 = data_in[31:0];
    wire signed [31:0] e1 = data_in[63:32];
    wire signed [31:0] e2 = data_in[95:64];
    wire signed [31:0] e3 = data_in[127:96];

    reg signed [31:0] max_01, max_23, max_final;
    wire signed [63:0] sum_all = e0 + e1 + e2 + e3;

    always @(*) begin
        // Max-Pooling logic
        max_01    = (e0 > e1) ? e0 : e1;
        max_23    = (e2 > e3) ? e2 : e3;
        max_final = (max_01 > max_23) ? max_01 : max_23;

        case (pool_type)
            2'b01: data_out = max_final;            // 2x2 Max-Pooling
            2'b10: data_out = sum_all[33:2];         // 2x2 Avg-Pooling (Divide by 4)
            default: data_out = data_in[31:0];       // Bypass
        endcase
    end

endmodule
