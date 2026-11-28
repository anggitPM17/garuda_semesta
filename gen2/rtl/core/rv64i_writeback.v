`timescale 1ns / 1ps
module rv64i_writeback (
    input  wire [63:0] alu_result,
    input  wire [63:0] mem_data,
    input  wire [63:0] pc_plus_4,
    input  wire        mem_to_reg,
    input  wire        is_jump,
    input  wire [4:0]  rd_addr,
    output wire [63:0] wb_data,
    output wire        wb_write_en,
    input  wire        reg_write_in
);
    assign wb_data = is_jump ? pc_plus_4 : (mem_to_reg ? mem_data : alu_result);
    assign wb_write_en = reg_write_in && (rd_addr != 5'd0);
endmodule
