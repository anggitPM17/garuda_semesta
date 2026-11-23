`timescale 1ns / 1ps
module tb_rv64i_writeback;
    reg [63:0] alu_result, mem_data, pc_plus_4;
    reg mem_to_reg, is_jump;
    reg [4:0] rd_addr;
    reg reg_write_in;
    wire [63:0] wb_data;
    wire wb_write_en;

    rv64i_writeback uut (
        .alu_result(alu_result), .mem_data(mem_data), .pc_plus_4(pc_plus_4),
        .mem_to_reg(mem_to_reg), .is_jump(is_jump), .rd_addr(rd_addr),
        .wb_data(wb_data), .wb_write_en(wb_write_en), .reg_write_in(reg_write_in)
    );

    initial begin
        $display("=== START tb_rv64i_writeback ===");
        alu_result = 64'd50; mem_data = 64'd100; pc_plus_4 = 64'h104;
        mem_to_reg = 0; is_jump = 0; rd_addr = 5'd5; reg_write_in = 1; #10;
        if (wb_data !== 64'd50 || !wb_write_en) begin $display("FAIL: writeback alu"); $finish; end

        rd_addr = 5'd0; reg_write_in = 1; #10;
        if (wb_write_en) begin $display("FAIL: x0 writeback protection"); $finish; end

        $display("PASS: tb_rv64i_writeback passed.");
        $finish;
    end
endmodule
