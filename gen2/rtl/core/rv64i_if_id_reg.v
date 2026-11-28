`timescale 1ns / 1ps
module rv64i_if_id_reg (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire [63:0] pc_in,
    input  wire [31:0] inst_in,
    output reg  [63:0] pc_out,
    output reg  [31:0] inst_out,
    output reg         is_ebreak_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            pc_out        <= 64'd0;
            inst_out      <= 32'h00000013; // NOP
            is_ebreak_out <= 1'b0;
        end else if (!stall) begin
            pc_out        <= pc_in;
            inst_out      <= inst_in;
            is_ebreak_out <= (inst_in == 32'h00100073);
        end
    end
endmodule
