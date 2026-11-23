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
        #1500000;
        $display("[TIMEOUT] Simulation timed out waiting for program completion.");
        $display(">>> TEST RESULT: FAILURE (FAIL) <<<");
        $finish;
    end

    integer errors = 0;

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — COMPREHENSIVE RV64I INTEGRATION");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;

        mem_model.load_hex("reports/single_hart_program.hex");

        #20;
        rst_n = 1;

        #500000;

        $display("\n=== COMPREHENSIVE AUTOMATED ASSERTION CHECKS ===");

        if (uut.regfile_inst.regs[0] !== 64'd0) begin
            $display("ASSERTION FAILED: x0 is not zero (%0d)", uut.regfile_inst.regs[0]);
            errors = errors + 1;
        end else $display("PASS: x0 zero protection verified.");

        if (uut.regfile_inst.regs[1] !== 64'd10) begin $display("FAIL: x1 = %0d (expected 10)", uut.regfile_inst.regs[1]); errors++; end
        else $display("PASS: x1 (ADDI 10) = 10");

        if (uut.regfile_inst.regs[2] !== 64'd20) begin $display("FAIL: x2 = %0d (expected 20)", uut.regfile_inst.regs[2]); errors++; end
        else $display("PASS: x2 (ADDI 20) = 20");

        if (uut.regfile_inst.regs[3] !== 64'd30) begin $display("FAIL: x3 = %0d (expected 30)", uut.regfile_inst.regs[3]); errors++; end
        else $display("PASS: x3 (ADD 30) = 30");

        if (uut.regfile_inst.regs[4] !== 64'd10) begin $display("FAIL: x4 = %0d (expected 10)", uut.regfile_inst.regs[4]); errors++; end
        else $display("PASS: x4 (SUB 10) = 10");

        if (uut.regfile_inst.regs[6] !== 64'd30) begin $display("FAIL: x6 = %0d (expected 30)", uut.regfile_inst.regs[6]); errors++; end
        else $display("PASS: x6 (OR 30) = 30");

        if (uut.regfile_inst.regs[7] !== 64'd30) begin $display("FAIL: x7 = %0d (expected 30)", uut.regfile_inst.regs[7]); errors++; end
        else $display("PASS: x7 (XOR 30) = 30");

        if (uut.regfile_inst.regs[8] !== 64'd1) begin $display("FAIL: x8 = %0d (expected 1)", uut.regfile_inst.regs[8]); errors++; end
        else $display("PASS: x8 (SLT 1) = 1");

        if (uut.regfile_inst.regs[10] !== 64'd40) begin $display("FAIL: x10 = %0d (expected 40)", uut.regfile_inst.regs[10]); errors++; end
        else $display("PASS: x10 (SLLI 40) = 40");

        if (uut.regfile_inst.regs[13] !== 64'd30) begin $display("FAIL: x13 = %0d (expected 30)", uut.regfile_inst.regs[13]); errors++; end
        else $display("PASS: x13 (LD 30) = 30");

        if (uut.regfile_inst.regs[14] !== 64'd40) begin $display("FAIL: x14 = %0d (expected 40)", uut.regfile_inst.regs[14]); errors++; end
        else $display("PASS: x14 (Forwarding x13+x1 = 40) = 40");

        if (uut.regfile_inst.regs[15] !== 64'd77) begin $display("FAIL: x15 = %0d (expected 77)", uut.regfile_inst.regs[15]); errors++; end
        else $display("PASS: x15 (Branch target 77) = 77");

        if (uut.regfile_inst.regs[17] !== 64'd88) begin $display("FAIL: x17 = %0d (expected 88)", uut.regfile_inst.regs[17]); errors++; end
        else $display("PASS: x17 (JAL target 88) = 88");

        $display("\n=========================================================");
        if (errors == 0) begin
            $display(" >>> ALL ASSERTIONS PASSED — TEST RESULT: SUCCESS (PASS) <<<");
        end else begin
            $display(" >>> TOTAL ERRORS: %0d — TEST RESULT: FAILURE (FAIL) <<<", errors);
        end
        $display("=========================================================");
        $finish;
    end

endmodule
