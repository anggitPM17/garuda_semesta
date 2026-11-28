`timescale 1ns / 1ps
module rv64i_ex_mem_reg (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        is_ebreak_in,
    input  wire [63:0] alu_result_in,
    input  wire [63:0] rs2_val_in,
    input  wire [4:0]  rd_in,
    input  wire        reg_write_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    output reg         is_ebreak_out,
    output reg  [63:0] alu_result_out,
    output reg  [63:0] rs2_val_out,
    output reg  [4:0]  rd_out,
    output reg         reg_write_out,
    output reg         mem_read_out,
    output reg         mem_write_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            is_ebreak_out  <= 1'b0;
            alu_result_out <= 64'd0;
            rs2_val_out    <= 64'd0;
            rd_out         <= 5'd0;
            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
        end else if (!stall) begin
            is_ebreak_out  <= is_ebreak_in;
            alu_result_out <= alu_result_in;
            rs2_val_out    <= rs2_val_in;
            rd_out         <= rd_in;
            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
        end
    end
endmodule
