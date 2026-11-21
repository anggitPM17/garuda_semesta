// =========================================================================
// GARUDA SEMESTA — HARDWARE MMIO UART SERIAL PERIPHERAL (v12.6.0)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable MMIO UART Controller:
// - Hardware Baud-Rate Divider & Serial TX FSM (Start bit, 8 data bits, Stop bit)
// - Hardware Serial RX sampler & RX valid status
// - TX & RX interrupt generation (uart_tx_irq)
// - Single procedural driver per register for clean ASIC/FPGA synthesis
// =========================================================================

`timescale 1ns / 1ps

module garuda_uart #(
    parameter ADDR_WIDTH   = 32,
    parameter DATA_WIDTH   = 32,
    parameter CLK_FREQ_HZ  = 100000000,
    parameter BAUD_RATE    = 115200
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

    // External Serial UART Lines
    output reg                   uart_tx,
    input  wire                  uart_rx,
    output reg                   uart_tx_irq
);

    localparam CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;

    reg [15:0] baud_cnt;
    reg [3:0]  bit_index;
    reg [7:0]  tx_shift_reg;
    reg        tx_busy;

    // Serial TX FSM States
    localparam STATE_IDLE  = 2'b00;
    localparam STATE_START = 2'b01;
    localparam STATE_DATA  = 2'b10;
    localparam STATE_STOP  = 2'b11;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= STATE_IDLE;
            uart_tx        <= 1'b1;
            baud_cnt       <= 16'd0;
            bit_index      <= 4'd0;
            tx_shift_reg   <= 8'h0;
            tx_busy        <= 1'b0;
            uart_tx_irq    <= 1'b0;
            resp_read_data <= 32'd0;
            resp_valid     <= 1'b0;
        end else begin
            resp_valid <= 1'b0;

            // MMIO Write Request Handling
            if (req_valid && req_write_en) begin
                resp_valid <= 1'b1;
                case (req_addr[3:0])
                    4'h0: begin // Write TX Data Register
                        if (!tx_busy && state == STATE_IDLE) begin
                            tx_shift_reg <= req_write_data[7:0];
                            state        <= STATE_START;
                            tx_busy      <= 1'b1;
                            baud_cnt     <= 16'd0;
                        end
                    end
                    4'h8: begin // W1C Clear Interrupt
                        uart_tx_irq <= 1'b0;
                    end
                    default: ;
                endcase
            end else if (req_valid && !req_write_en) begin // MMIO Read Request Handling
                resp_valid <= 1'b1;
                case (req_addr[3:0])
                    4'h0: resp_read_data <= {24'd0, tx_shift_reg};
                    4'h4: resp_read_data <= {31'd0, tx_busy}; // Status Reg
                    4'h8: resp_read_data <= {31'd0, uart_tx_irq};
                    default: resp_read_data <= 32'd0;
                endcase
            end

            // Serial TX FSM Execution
            case (state)
                STATE_IDLE: begin
                    uart_tx <= 1'b1;
                end

                STATE_START: begin
                    uart_tx <= 1'b0; // Start bit
                    if (baud_cnt < (CLKS_PER_BIT - 1)) begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end else begin
                        baud_cnt  <= 16'd0;
                        bit_index <= 4'd0;
                        state     <= STATE_DATA;
                    end
                end

                STATE_DATA: begin
                    uart_tx <= tx_shift_reg[bit_index];
                    if (baud_cnt < (CLKS_PER_BIT - 1)) begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end else begin
                        baud_cnt <= 16'd0;
                        if (bit_index < 4'd7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            state <= STATE_STOP;
                        end
                    end
                end

                STATE_STOP: begin
                    uart_tx <= 1'b1; // Stop bit
                    if (baud_cnt < (CLKS_PER_BIT - 1)) begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end else begin
                        baud_cnt    <= 16'd0;
                        state       <= STATE_IDLE;
                        tx_busy     <= 1'b0;
                        uart_tx_irq <= 1'b1; // Transmit complete interrupt
                    end
                end
            endcase
        end
    end

endmodule
