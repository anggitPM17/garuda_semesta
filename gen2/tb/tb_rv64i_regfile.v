`timescale 1ns / 1ps
module tb_rv64i_regfile;
    reg clk, rst_n;
    reg [4:0] rs1_addr, rs2_addr, rd_addr;
    reg [63:0] rd_data;
    reg rd_write_en;
    wire [63:0] rs1_data, rs2_data;

    rv64i_regfile uut (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data),
        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rd_write_en(rd_write_en)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=== START tb_rv64i_regfile ===");
        clk = 0; rst_n = 0; rs1_addr = 0; rs2_addr = 0; rd_addr = 0; rd_data = 0; rd_write_en = 0;
        #12;
        rst_n = 1; #10;

        rd_addr = 5'd0; rd_data = 64'd123; rd_write_en = 1; #10;
        rd_write_en = 0; rs1_addr = 5'd0; #5;
        if (rs1_data !== 64'd0) begin $display("FAIL: x0 protection"); $finish; end

        rd_addr = 5'd5; rd_data = 64'd999; rd_write_en = 1; #10;
        rd_write_en = 0; rs1_addr = 5'd5; #5;
        if (rs1_data !== 64'd999) begin $display("FAIL: reg write x5 = %d", rs1_data); $finish; end

        $display("PASS: tb_rv64i_regfile passed.");
        $finish;
    end
endmodule
