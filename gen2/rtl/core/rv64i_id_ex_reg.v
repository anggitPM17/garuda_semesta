`timescale 1ns / 1ps
module rv64i_id_ex_reg (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        is_ebreak_in,
    input  wire [63:0] pc_in,
    input  wire [63:0] rs1_val_in,
    input  wire [63:0] rs2_val_in,
    input  wire [63:0] imm_in,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire [3:0]  alu_op_in,
    input  wire        alu_src_in,
    input  wire        reg_write_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    output reg         is_ebreak_out,
    output reg  [63:0] pc_out,
    output reg  [63:0] rs1_val_out,
    output reg  [63:0] rs2_val_out,
    output reg  [63:0] imm_out,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg  [3:0]  alu_op_out,
    output reg         alu_src_out,
    output reg         reg_write_out,
    output reg         mem_read_out,
    output reg         mem_write_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            is_ebreak_out <= 1'b0;
            pc_out        <= 64'd0;
            rs1_val_out   <= 64'd0;
            rs2_val_out   <= 64'd0;
            imm_out       <= 64'd0;
            rs1_out       <= 5'd0;
            rs2_out       <= 5'd0;
            rd_out        <= 5'd0;
            alu_op_out    <= 4'd0;
            alu_src_out   <= 1'b0;
            reg_write_out <= 1'b0;
            mem_read_out  <= 1'b0;
            mem_write_out <= 1'b0;
        end else if (!stall) begin
            is_ebreak_out <= is_ebreak_in;
            pc_out        <= pc_in;
            rs1_val_out   <= rs1_val_in;
            rs2_val_out   <= rs2_val_in;
            imm_out       <= imm_in;
            rs1_out       <= rs1_in;
            rs2_out       <= rs2_in;
            rd_out        <= rd_in;
            alu_op_out    <= alu_op_in;
            alu_src_out   <= alu_src_in;
            reg_write_out <= reg_write_in;
            mem_read_out  <= mem_read_in;
            mem_write_out <= mem_write_in;
        end
    end
endmodule
