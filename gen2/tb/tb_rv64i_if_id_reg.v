`timescale 1ns / 1ps
module tb_rv64i_if_id_reg;
    reg clk, rst_n, stall, flush;
    reg [63:0] pc_in;
    reg [31:0] inst_in;
    wire [63:0] pc_out;
    wire [31:0] inst_out;

    rv64i_if_id_reg uut (
        .clk(clk), .rst_n(rst_n), .stall(stall), .flush(flush),
        .pc_in(pc_in), .inst_in(inst_in), .pc_out(pc_out), .inst_out(inst_out)
    );
    always #5 clk = ~clk;

    initial begin
        $display("=== START tb_rv64i_if_id_reg ===");
        clk = 0; rst_n = 0; stall = 0; flush = 0; pc_in = 64'h100; inst_in = 32'h12345678; #12;
        rst_n = 1; #10;
        if (pc_out !== 64'h100 || inst_out !== 32'h12345678) begin $display("FAIL: if_id reg"); $finish; end
        $display("PASS: tb_rv64i_if_id_reg passed.");
        $finish;
    end
endmodule
