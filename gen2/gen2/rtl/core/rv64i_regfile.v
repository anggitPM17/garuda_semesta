`timescale 1ns / 1ps
module rv64i_regfile (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [4:0]  rs1_addr,
    output wire [63:0] rs1_data,
    input  wire [4:0]  rs2_addr,
    output wire [63:0] rs2_data,
    input  wire [4:0]  rd_addr,
    input  wire [63:0] rd_data,
    input  wire        rd_write_en
);
    reg [63:0] regs [0:31];
    integer i;

    assign rs1_data = (rs1_addr == 5'd0) ? 64'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 64'd0 : regs[rs2_addr];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 64'd0;
        end else if (rd_write_en && (rd_addr != 5'd0)) begin
            regs[rd_addr] <= rd_data;
        end
    end
endmodule
