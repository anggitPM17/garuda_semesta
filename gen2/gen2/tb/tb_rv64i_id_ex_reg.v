`timescale 1ns / 1ps
module tb_rv64i_id_ex_reg;
    reg clk, rst_n, flush;
    reg [63:0] pc_in, rs1_v, rs2_v, imm_in;
    reg [4:0] rs1_in, rs2_in, rd_in;
    reg [3:0] alu_op_in;
    reg alu_src_in, reg_write_in, mem_read_in, mem_write_in;
    wire [63:0] pc_out, rs1_v_out, rs2_v_out, imm_out;
    wire [4:0] rs1_out, rs2_out, rd_out;
    wire [3:0] alu_op_out;
    wire alu_src_out, reg_write_out, mem_read_out, mem_write_out;

    rv64i_id_ex_reg uut (
        .clk(clk), .rst_n(rst_n), .flush(flush),
        .pc_in(pc_in), .rs1_val_in(rs1_v), .rs2_val_in(rs2_v), .imm_in(imm_in),
        .rs1_in(rs1_in), .rs2_in(rs2_in), .rd_in(rd_in),
        .alu_op_in(alu_op_in), .alu_src_in(alu_src_in), .reg_write_in(reg_write_in),
        .mem_read_in(mem_read_in), .mem_write_in(mem_write_in),
        .pc_out(pc_out), .rs1_val_out(rs1_v_out), .rs2_val_out(rs2_v_out), .imm_out(imm_out),
        .rs1_out(rs1_out), .rs2_out(rs2_out), .rd_out(rd_out),
        .alu_op_out(alu_op_out), .alu_src_out(alu_src_out), .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out), .mem_write_out(mem_write_out)
    );
    always #5 clk = ~clk;

    initial begin
        $display("=== START tb_rv64i_id_ex_reg ===");
        clk = 0; rst_n = 0; flush = 0; pc_in = 64'h200; rs1_v = 64'd5; rs2_v = 64'd10; imm_in = 64'd2;
        rs1_in = 1; rs2_in = 2; rd_in = 3; alu_op_in = 1; alu_src_in = 1; reg_write_in = 1; mem_read_in = 0; mem_write_in = 0;
        #12; rst_n = 1; #10;
        if (rd_out !== 5'd3 || alu_op_out !== 4'd1) begin $display("FAIL: id_ex reg"); $finish; end
        $display("PASS: tb_rv64i_id_ex_reg passed.");
        $finish;
    end
endmodule
