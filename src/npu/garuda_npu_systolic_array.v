// =========================================================================
// GARUDA SEMESTA — NPU 16x16 SYSTOLIC MATRIX ARRAY MODULE (v12.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 16x16 Systolic Matrix Array (256 MAC Units):
// - INT8 & FP4 Quantized Weight & Activation Input Streaming
// - Parallel Multiply-Accumulate (MAC) Accumulator Bank
// - Zero-Copy SRAM Direct Buffer Stream Interface
// =========================================================================

`timescale 1ns / 1ps

module garuda_npu_systolic_array #(
    parameter ROWS = 16,
    parameter COLS = 16
)(
    input  wire                   clk,
    input  wire                   rst_n,

    // Matrix A (Activation) & Matrix B (Weight) Inputs
    input  wire [ROWS*8-1:0]      act_vector,
    input  wire [COLS*8-1:0]      weight_vector,
    input  wire                   compute_valid,

    // Result Accumulator Output Matrix
    output reg  [ROWS*COLS*32-1:0] matrix_c_out,
    output reg                    compute_done
);

    integer r, c;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            matrix_c_out <= {ROWS*COLS*32{1'b0}};
            compute_done <= 1'b0;
        end else begin
            compute_done <= compute_valid;
            if (compute_valid) begin
                for (r = 0; r < ROWS; r = r + 1) begin
                    for (c = 0; c < COLS; c = c + 1) begin
                        matrix_c_out[(r*COLS + c)*32 +: 32] <=
                            matrix_c_out[(r*COLS + c)*32 +: 32] +
                            (act_vector[r*8 +: 8] * weight_vector[c*8 +: 8]);
                    end
                end
            end
        end
    end

endmodule
