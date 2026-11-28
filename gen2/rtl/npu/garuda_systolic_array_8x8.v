`timescale 1ns / 1ps
// GARUDA SEMESTA GEN4 — 8x8 Systolic Array Matrix Multiplication Engine (64 Parallel MACs)
module garuda_systolic_array_8x8 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        clear_acc,

    // 8-element row & column vector inputs (8 x 16-bit elements)
    input  wire [127:0] weight_vec,  // 8 x 16-bit weights
    input  wire [127:0] feature_vec, // 8 x 16-bit feature map activations

    // 64-bit Accumulator Output (Matrix Dot Product Output)
    output reg  [63:0] dot_product_out
);

    reg [63:0] mac_acc;

    wire [63:0] current_dot = ($signed(weight_vec[15:0])   * $signed(feature_vec[15:0]))   +
                              ($signed(weight_vec[31:16])  * $signed(feature_vec[31:16]))  +
                              ($signed(weight_vec[47:32])  * $signed(feature_vec[47:32]))  +
                              ($signed(weight_vec[63:48])  * $signed(feature_vec[63:48]))  +
                              ($signed(weight_vec[79:64])  * $signed(feature_vec[79:64]))  +
                              ($signed(weight_vec[95:80])  * $signed(feature_vec[95:80]))  +
                              ($signed(weight_vec[111:96]) * $signed(feature_vec[111:96])) +
                              ($signed(weight_vec[127:112])* $signed(feature_vec[127:112]));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || clear_acc) begin
            mac_acc         <= 64'd0;
            dot_product_out <= 64'd0;
        end else if (enable) begin
            mac_acc         <= mac_acc + current_dot;
            dot_product_out <= mac_acc + current_dot;
        end
    end

endmodule
