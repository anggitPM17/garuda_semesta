`timescale 1ns / 1ps
module rv64i_mem_wb_reg (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire [63:0] mem_data_in,
    input  wire [63:0] alu_result_in,
    input  wire [4:0]  rd_in,
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,
    output reg  [63:0] mem_data_out,
    output reg  [63:0] alu_result_out,
    output reg  [4:0]  rd_out,
    output reg         reg_write_out,
    output reg         mem_to_reg_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            mem_data_out   <= 64'd0;
            alu_result_out <= 64'd0;
            rd_out         <= 5'd0;
            reg_write_out  <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else if (!stall) begin
            mem_data_out   <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out         <= rd_in;
            reg_write_out  <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule
