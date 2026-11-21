// =========================================================================
// GARUDA SEMESTA — NATIVE INTERRUPT CONTROLLER MODULE (v0.3.3)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable Interrupt Controller:
// - 8-channel interrupt vector inputs (IRQ[7:0])
// - Single next-state combinational logic preventing IRQ loss during W1C clear
// - Interrupt Pending, Enable Mask, and Priority Registers
// - Emits irq_output to CPU core when unmasked interrupt occurs
// =========================================================================

`timescale 1ns / 1ps

module garuda_interrupt_controller #(
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

    // Hardware Interrupt Inputs
    input  wire [7:0]            irq_inputs,
    output wire                  irq_to_cpu,
    output reg  [7:0]            active_irq_vector
);

    reg [7:0] irq_enable_mask;
    reg [7:0] irq_pending_reg;

    assign irq_to_cpu = |(irq_pending_reg & irq_enable_mask);

    // Single Next-State Calculation for IRQ Capture & W1C Clear Priority
    wire [7:0] w1c_clear_mask = (req_valid && req_write_en && (req_addr[3:0] == 4'h4)) ? req_write_data[7:0] : 8'h0;
    wire [7:0] next_pending   = (irq_pending_reg & ~w1c_clear_mask) | irq_inputs;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            irq_enable_mask   <= 8'h0;
            irq_pending_reg   <= 8'h0;
            active_irq_vector <= 8'h0;
            resp_read_data    <= 32'h0;
            resp_valid        <= 1'b0;
        end else begin
            resp_valid      <= 1'b0;
            irq_pending_reg <= next_pending;

            if (req_valid) begin
                resp_valid <= 1'b1;
                if (req_write_en) begin
                    case (req_addr[3:0])
                        4'h0: irq_enable_mask <= req_write_data[7:0]; // Enable Mask
                        default: ;
                    endcase
                end else begin
                    case (req_addr[3:0])
                        4'h0: resp_read_data <= {24'd0, irq_enable_mask};
                        4'h4: resp_read_data <= {24'd0, irq_pending_reg};
                        4'h8: resp_read_data <= {31'd0, irq_to_cpu};
                        default: resp_read_data <= 32'd0;
                    endcase
                end
            end
        end
    end

endmodule
