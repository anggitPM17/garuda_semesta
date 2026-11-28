`timescale 1ns / 1ps
// GARUDA SEMESTA GEN4 — NPU Re-Quantization & Scaling Unit (INT32/64 -> INT8)
module garuda_npu_quantizer (
    input  wire [63:0] data_in,
    input  wire [15:0] scale_factor, // Quantization multiplier scale
    input  wire [3:0]  shift_bits,   // Right shift bits
    output reg  [7:0]  quantized_out
);

    wire signed [79:0] scaled_data = $signed(data_in) * $signed({1'b0, scale_factor});
    wire signed [79:0] shifted_data = scaled_data >>> shift_bits;

    always @(*) begin
        // Saturating 8-bit clipping [-128, 127]
        if (shifted_data > 79'sd127)
            quantized_out = 8'd127;
        else if (shifted_data < -79'sd128)
            quantized_out = -8'd128;
        else
            quantized_out = shifted_data[7:0];
    end

endmodule
