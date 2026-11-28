`timescale 1ns / 1ps
module tb_rv64i_hazard_unit;
    reg id_ex_mem_read;
    reg [4:0] id_ex_rd, if_id_rs1, if_id_rs2;
    reg branch_taken;
    wire stall, flush;
    wire [1:0] forward_a, forward_b;
    reg [4:0] ex_mem_rd, mem_wb_rd, id_ex_rs1, id_ex_rs2;
    reg ex_mem_reg_write, mem_wb_reg_write;

    rv64i_hazard_unit uut (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .branch_taken(branch_taken),
        .stall(stall),
        .flush(flush),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2)
    );

    initial begin
        $display("=== START tb_rv64i_hazard_unit ===");
        id_ex_mem_read = 1; id_ex_rd = 5'd5; if_id_rs1 = 5'd5; if_id_rs2 = 5'd0; branch_taken = 0; #10;
        if (!stall) begin $display("FAIL: load-use stall"); $finish; end

        $display("PASS: tb_rv64i_hazard_unit passed.");
        $finish;
    end
endmodule
