`timescale 1ns / 1ps
// GARUDA SEMESTA GEN4 — NPU (Neural Processing Unit) Top Module
module garuda_npu_top (
    input  wire        clk,
    input  wire        rst_n,

    // MMIO Interface from Interconnect / CPU Host
    input  wire [63:0] addr,
    input  wire        valid,
    input  wire        wen,
    input  wire [2:0]  funct3,
    input  wire [63:0] wdata,
    output reg         ready,
    output reg  [63:0] rdata,
    output reg         resp_valid,
    output reg         npu_done_irq
);

    reg [127:0] weight_buffer;
    reg [127:0] feature_buffer;
    reg [1:0]   afu_mode;
    reg         systolic_enable;
    reg         systolic_clear;

    wire [63:0] mac_raw_out;
    wire [63:0] afu_activated_out;

    garuda_systolic_array_8x8 systolic_inst (
        .clk(clk),
        .rst_n(rst_n),
        .enable(systolic_enable),
        .clear_acc(systolic_clear),
        .weight_vec(weight_buffer),
        .feature_vec(feature_buffer),
        .dot_product_out(mac_raw_out)
    );

    garuda_npu_afu afu_inst (
        .afu_type(afu_mode),
        .data_in(mac_raw_out),
        .data_out(afu_activated_out)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_buffer   <= 128'd0;
            feature_buffer  <= 128'd0;
            afu_mode        <= 2'b01; // Default ReLU
            systolic_enable <= 1'b0;
            systolic_clear  <= 1'b0;
            ready           <= 1'b1;
            rdata           <= 64'd0;
            resp_valid      <= 1'b0;
            npu_done_irq    <= 1'b0;
        end else begin
            resp_valid      <= 1'b0;
            ready           <= 1'b1;
            systolic_enable <= 1'b0;
            systolic_clear  <= 1'b0;
            npu_done_irq    <= 1'b0;

            if (valid) begin
                resp_valid <= 1'b1;
                if (wen) begin
                    case (addr[5:0])
                        6'h00: weight_buffer[63:0]    <= wdata;
                        6'h08: weight_buffer[127:64]  <= wdata;
                        6'h10: feature_buffer[63:0]   <= wdata;
                        6'h18: feature_buffer[127:64] <= wdata;
                        6'h20: begin
                            afu_mode        <= wdata[1:0];
                            systolic_enable <= 1'b1; // Trigger NPU MAC computation
                            npu_done_irq    <= 1'b1;
                        end
                        6'h28: systolic_clear <= 1'b1; // Clear accumulator
                        default: ;
                    endcase
                end else begin
                    case (addr[5:0])
                        6'h00: rdata <= weight_buffer[63:0];
                        6'h10: rdata <= feature_buffer[63:0];
                        6'h30: rdata <= afu_activated_out; // Read NPU tensor inference result
                        default: rdata <= 64'd0;
                    endcase
                end
            end
        end
    end

endmodule
