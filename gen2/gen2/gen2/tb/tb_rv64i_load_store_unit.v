`timescale 1ns / 1ps
module tb_rv64i_load_store_unit;
    reg clk, rst_n, mem_read, mem_write;
    reg [2:0] funct3;
    reg [63:0] addr, store_data;
    wire [63:0] load_data;
    wire misaligned;
    wire [63:0] mem_addr;
    wire mem_wen;
    wire [63:0] mem_wdata;
    reg [63:0] mem_rdata;

    rv64i_load_store_unit uut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .funct3(funct3),
        .addr(addr),
        .store_data(store_data),
        .load_data(load_data),
        .misaligned(misaligned),
        .mem_addr(mem_addr),
        .mem_wen(mem_wen),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

    initial begin
        $display("=== START tb_rv64i_load_store_unit ===");
        clk = 0; rst_n = 1; mem_read = 0; mem_write = 0; funct3 = 3'b011; addr = 64'h0; store_data = 64'h1234; mem_rdata = 64'h0000000012345678;
        #10;
        mem_read = 1; funct3 = 3'b011; addr = 64'd0; #10;
        if (load_data !== 64'h0000000012345678) begin $display("FAIL: LD load_data = %h", load_data); $finish; end

        $display("PASS: tb_rv64i_load_store_unit passed.");
        $finish;
    end
endmodule
