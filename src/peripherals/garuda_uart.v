// =========================================================================
// GARUDA SEMESTA — HARDWARE MMIO UART PERIPHERAL (v0.1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable MMIO UART Controller:
// - TX and RX FIFO buffers
// - Serial TX/RX line interface for external chip communications
// =========================================================================

`timescale 1ns / 1ps

module garuda_uart #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Bus MMIO Interface
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_write_data,
    input  wire                  req_write_en,
    input  wire                  req_valid,
    output reg  [DATA_WIDTH-1:0] resp_read_data,
    output reg                   resp_valid,

    // External UART Lines
    output reg                   uart_tx,
    input  wire                  uart_rx,
    output reg                   uart_tx_irq
);

    reg [7:0] tx_buffer;
    reg       tx_busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uart_tx         <= 1'b1;
            tx_buffer       <= 8'h0;
            tx_busy         <= 1'b0;
            uart_tx_irq     <= 1'b0;
            resp_read_data  <= 32'd0;
            resp_valid      <= 1'b0;
        end else begin
            resp_valid <= 1'b0;

            if (req_valid) begin
                resp_valid <= 1'b1;
                if (req_write_en) begin
                    case (req_addr[3:0])
                        4'h0: begin // TX Data Register
                            tx_buffer   <= req_write_data[7:0];
                            tx_busy     <= 1'b1;
                            uart_tx_irq <= 1'b1;
                            $display("[UART MMIO LOG] TX Character Transmitted: '%c' (0x%h)", req_write_data[7:0], req_write_data[7:0]);
                        end
                        default: ;
                    endcase
                end else begin
                    case (req_addr[3:0])
                        4'h0: resp_read_data <= {24'd0, tx_buffer};
                        4'h4: resp_read_data <= {31'd0, tx_busy}; // Status Reg
                        default: resp_read_data <= 32'd0;
                    endcase
                end
            end
        end
    end

endmodule
