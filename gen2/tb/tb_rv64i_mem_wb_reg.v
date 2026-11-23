`timescale 1ns / 1ps
module tb_rv64i_mem_wb_reg;
    reg clk, rst_n;
    reg [63:0] mem_data_in, alu_res_in;
    reg [4:0] rd_in;
    reg reg_w_in, mem_to_reg_in;
    wire [63:0] mem_data_out, alu_res_out;
    wire [4:0] rd_out;
    wire reg_w_out, mem_to_reg_out;

    rv64i_mem_wb_reg uut (
        .clk(clk), .rst_n(rst_n), .mem_data_in(mem_data_in), .alu_result_in(alu_res_in),
        .rd_in(rd_in), .reg_write_in(reg_w_in), .mem_to_reg_in(mem_to_reg_in),
        .mem_data_out(mem_data_out), .alu_result_out(alu_res_out), .rd_out(rd_out),
        .reg_write_out(reg_w_out), .mem_to_reg_out(mem_to_reg_out)
    );
    always #5 clk = ~clk;

    initial begin
        $display("=== START tb_rv64i_mem_wb_reg ===");
        clk = 0; rst_n = 0; mem_data_in = 64'd100; alu_res_in = 64'd200; rd_in = 4; reg_w_in = 1; mem_to_reg_in = 1;
        #12; rst_n = 1; #10;
        if (mem_data_out !== 64'd100 || rd_out !== 5'd4) begin $display("FAIL: mem_wb reg"); $finish; end
        $display("PASS: tb_rv64i_mem_wb_reg passed.");
        $finish;
    end
endmodule
