`timescale 1ns / 1ps
module garuda_rv64i_core_tb;
    reg clk;
    reg rst_n;

    wire [63:0] imem_addr;
    wire        imem_valid;
    wire        imem_ready;
    wire [31:0] imem_rdata;
    wire        imem_resp_valid;

    wire [63:0] dmem_addr;
    wire        dmem_valid;
    wire        dmem_wen;
    wire [2:0]  dmem_funct3;
    wire [63:0] dmem_wdata;
    wire        dmem_ready;
    wire [63:0] dmem_rdata;
    wire        dmem_resp_valid;

    rv64i_memory_model mem_model (
        .clk(clk),
        .rst_n(rst_n),
        .imem_addr(imem_addr),
        .imem_valid(imem_valid),
        .imem_ready(imem_ready),
        .imem_rdata(imem_rdata),
        .imem_resp_valid(imem_resp_valid),
        .dmem_addr(dmem_addr),
        .dmem_valid(dmem_valid),
        .dmem_wen(dmem_wen),
        .dmem_funct3(dmem_funct3),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_resp_valid(dmem_resp_valid)
    );

    garuda_rv64i_core uut (
        .clk(clk),
        .rst_n(rst_n),
        .imem_addr(imem_addr),
        .imem_valid(imem_valid),
        .imem_ready(imem_ready),
        .imem_rdata(imem_rdata),
        .imem_resp_valid(imem_resp_valid),
        .dmem_addr(dmem_addr),
        .dmem_valid(dmem_valid),
        .dmem_wen(dmem_wen),
        .dmem_funct3(dmem_funct3),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_resp_valid(dmem_resp_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — SINGLE-HART RV64I INTEGRATION TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;

        mem_model.load_hex("reports/single_hart_program.hex");

        #20;
        rst_n = 1;

        #300;

        $display("\n=== PIPELINE TRACE & FINAL STATE ===");
        $display("PC = %0h, Inst = %0h", uut.pc, imem_rdata);
        $display("x1  = %0d", uut.regfile_inst.regs[1]);
        $display("x2  = %0d", uut.regfile_inst.regs[2]);
        $display("x3  = %0d", uut.regfile_inst.regs[3]);
        $display("x4  = %0d", uut.regfile_inst.regs[4]);
        $display("x5  = %0d", uut.regfile_inst.regs[5]);
        $display("x6  = %0d", uut.regfile_inst.regs[6]);
        $display("x7  = %0d", uut.regfile_inst.regs[7]);
        $display("x8  = %0d", uut.regfile_inst.regs[8]);
        $display("x9  = %0d", uut.regfile_inst.regs[9]);
        $display("x10 = %0d", uut.regfile_inst.regs[10]);
        $display("x11 = %0h", uut.regfile_inst.regs[11]);
        $display("x12 = %0h", uut.regfile_inst.regs[12]);
        $display("x13 = %0d", uut.regfile_inst.regs[13]);
        $display("x14 = %0d", uut.regfile_inst.regs[14]);
        $display("x15 = %0d", uut.regfile_inst.regs[15]);

        if (uut.regfile_inst.regs[3] == 64'd30) begin
            $display("\n>>> TEST RESULT: SUCCESS (PASS) <<<");
        end else begin
            $display("\n>>> TEST RESULT: FAILURE (FAIL) <<<");
        end

        $finish;
    end

    // Monitor each cycle
    always @(posedge clk) begin
        if (rst_n) begin
            $display("[T=%0t] PC=%0h | Inst=%0h | ALU_Res=%0h | WB_Data=%0h | x1=%0d, x2=%0d, x3=%0d",
                $time, uut.pc, imem_rdata, uut.alu_result_ex, uut.wb_data,
                uut.regfile_inst.regs[1], uut.regfile_inst.regs[2], uut.regfile_inst.regs[3]);
        end
    end

endmodule
