`timescale 1ns / 1ps
module rv64i_hazard_unit (
    input  wire        id_ex_mem_read,
    input  wire [4:0]  id_ex_rd,
    input  wire [4:0]  if_id_rs1,
    input  wire [4:0]  if_id_rs2,
    input  wire        branch_taken,
    output reg         stall,
    output reg         flush,
    output reg [1:0]   forward_a,
    output reg [1:0]   forward_b,
    input  wire [4:0]  ex_mem_rd,
    input  wire        ex_mem_reg_write,
    input  wire [4:0]  mem_wb_rd,
    input  wire        mem_wb_reg_write,
    input  wire [4:0]  id_ex_rs1,
    input  wire [4:0]  id_ex_rs2
);
    always @(*) begin
        stall = (id_ex_mem_read && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)) && (id_ex_rd != 5'd0));
        flush = branch_taken;

        forward_a = 2'b00;
        forward_b = 2'b00;

        if (ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs1))
            forward_a = 2'b10;
        if (ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs2))
            forward_b = 2'b10;

        if (mem_wb_reg_write && (mem_wb_rd != 5'd0) && !(ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs1)) && (mem_wb_rd == id_ex_rs1))
            forward_a = 2'b01;
        if (mem_wb_reg_write && (mem_wb_rd != 5'd0) && !(ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs2)) && (mem_wb_rd == id_ex_rs2))
            forward_b = 2'b01;
    end
endmodule
