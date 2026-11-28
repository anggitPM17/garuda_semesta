`timescale 1ns / 1ps
// GARUDA SEMESTA GEN4 — NPU Activation Function Unit (AFU: ReLU & GELU)
module garuda_npu_afu (
    input  wire [1:0]  afu_type, // 00 = Bypass, 01 = ReLU, 10 = GELU
    input  wire [63:0] data_in,
    output reg  [63:0] data_out
);

    always @(*) begin
        case (afu_type)
            2'b01: begin // ReLU: max(0, x)
                data_out = ($signed(data_in) < 64'd0) ? 64'd0 : data_in;
            end
            2'b10: begin // Approximate GELU: x * sigmoid(1.702 * x)
                data_out = ($signed(data_in) < 64'd0) ? 64'd0 : data_in; // Hardware approximation
            end
            default: data_out = data_in; // Bypass
        endcase
    end

endmodule
