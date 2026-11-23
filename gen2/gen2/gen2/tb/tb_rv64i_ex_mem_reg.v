`timescale 1ns / 1ps
module tb_rv64i_ex_mem_reg;
    reg clk, rst_n;
    reg [63:0] alu_res_in, rs2_in;
    reg [4:0] rd_in;
    reg reg_w_in, mem_r_in, mem_w_in;
    wire [63:0] alu_res_out, rs2_out;
    wire [4:0] rd_out;
    wire reg_w_out, mem_r_out, mem_w_out;

    rv64i_ex_mem_reg uut (
        .clk(clk), .rst_n(rst_n), .alu_result_in(alu_res_in), .rs2_val_in(rs2_in),
        .rd_in(rd_in), .reg_write_in(reg_w_in), .mem_read_in(mem_r_in), .mem_write_in(mem_w_in),
        .alu_result_out(alu_res_out), .rs2_val_out(rs2_out), .rd_out(rd_out),
        .reg_write_out(reg_w_out), .mem_read_out(mem_r_out), .mem_write_out(mem_w_out)
    );
    always #5 clk = ~clk;

    initial begin
        $display("=== START tb_rv64i_ex_mem_reg ===");
        clk = 0; rst_n = 0; alu_res_in = 64'd42; rs2_in = 64'd99; rd_in = 5; reg_w_in = 1; mem_r_in = 0; mem_w_in = 0;
        #12; rst_n = 1; #10;
        if (alu_res_out !== 64'd42 || rd_out !== 5'd5) begin $display("FAIL: ex_mem reg"); $finish; end
        $display("PASS: tb_rv64i_ex_mem_reg passed.");
        $finish;
    end
endmodule
