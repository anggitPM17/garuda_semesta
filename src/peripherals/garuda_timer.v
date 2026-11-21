// =========================================================================
// GARUDA SEMESTA — HARDWARE MMIO TIMER PERIPHERAL (v0.1)
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
//
// Synthesizable 32-bit Timer/Counter Peripheral:
// - Free-running counter and compare match register
// - Generates timer_irq on compare match
// =========================================================================

`timescale 1ns / 1ps

module garuda_timer #(
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

    output reg                   timer_irq
);

    reg [31:0] timer_count;
    reg [31:0] timer_compare;
    reg        timer_control_enable;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_count          <= 32'd0;
            timer_compare        <= 32'hFFFF_FFFF;
            timer_control_enable <= 1'b1;
            timer_irq            <= 1'b0;
            resp_read_data       <= 32'd0;
            resp_valid           <= 1'b0;
        end else begin
            resp_valid <= 1'b0;

            if (timer_control_enable) begin
                timer_count <= timer_count + 1'b1;
                if (timer_count == timer_compare) begin
                    timer_irq <= 1'b1;
                end
            end

            if (req_valid) begin
                resp_valid <= 1'b1;
                if (req_write_en) begin
                    case (req_addr[3:0])
                        4'h0: timer_control_enable <= req_write_data[0];
                        4'h4: timer_count          <= req_write_data;
                        4'h8: timer_compare        <= req_write_data;
                        4'hC: timer_irq            <= 1'b0; // Clear IRQ
                        default: ;
                    endcase
                end else begin
                    case (req_addr[3:0])
                        4'h0: resp_read_data <= {31'd0, timer_control_enable};
                        4'h4: resp_read_data <= timer_count;
                        4'h8: resp_read_data <= timer_compare;
                        4'hC: resp_read_data <= {31'd0, timer_irq};
                        default: resp_read_data <= 32'd0;
                    endcase
                end
            end
        end
    end

endmodule
