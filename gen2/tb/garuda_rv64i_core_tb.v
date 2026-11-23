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
    wire        dmem_resp_ready_core;
    reg         tb_resp_ready_mask = 1'b1; // Backpressure Injection Control
    wire        dmem_resp_ready_effective = dmem_resp_ready_core && tb_resp_ready_mask;

    wire        core_halted;
    wire [31:0] read_tx_count;
    wire [31:0] write_tx_count;
    wire [31:0] committed_store_count;
    wire [31:0] resp_tx_count;
    wire [31:0] duplicate_tx_count;

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
        .dmem_resp_valid(dmem_resp_valid),
        .dmem_resp_ready(dmem_resp_ready_effective),
        .read_tx_count(read_tx_count),
        .write_tx_count(write_tx_count),
        .committed_store_count(committed_store_count),
        .resp_tx_count(resp_tx_count),
        .duplicate_tx_count(duplicate_tx_count)
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
        .dmem_resp_valid(dmem_resp_valid),
        .dmem_resp_ready(dmem_resp_ready_core),
        .core_halted(core_halted)
    );

    always #5 clk = ~clk;

    // Watchdog timer with $fatal to guarantee non-zero exit code on failure
    initial begin
        #5000000;
        $display("\n=========================================================");
        $display("[FATAL TIMEOUT] Simulation timed out waiting for EBREAK.");
        $display(">>> TEST RESULT: FAILURE (FAIL) <<<");
        $display("=========================================================");
        $fatal(1, "WATCHDOG TIMEOUT — Core failed to reach EBREAK");
    end

    integer errors = 0;

    // Backpressure Injection Monitor
    initial begin
        tb_resp_ready_mask = 1'b1;
        #100;
        // Wait until core enters first store or load transaction
        wait (dmem_valid && dmem_resp_valid);
        tb_resp_ready_mask = 1'b0; // Inject backpressure stall for 1 cycle (10ns)
        #10;
        if (!dmem_resp_valid) begin
            $display("FAIL: dmem_resp_valid dropped during response backpressure stall!");
            errors++;
        end else begin
            $display("PASS: Response valid held stable during backpressure stall.");
        end
        tb_resp_ready_mask = 1'b1; // Release backpressure
    end

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — FASE 6.7.1 HANDSHAKE REPAIR TEST");
        $display("=========================================================");

        clk = 0;
        rst_n = 0;

        mem_model.load_hex("reports/single_hart_program.hex");

        #20;
        rst_n = 1;

        // Event-driven wait for core_halted (EBREAK reaching WB stage)
        wait (uut.core_halted);
        #100; // Allow full pipeline drain

        $display("\n=== COMPREHENSIVE AUTOMATED ASSERTION CHECKS ===");

        // 1. EBREAK termination verification
        if (!uut.core_halted) begin
            $display("FAIL: Program did not reach EBREAK (core_halted = 0)");
            errors = errors + 1;
        end else begin
            $display("PASS: Program reached EBREAK / HALT successfully.");
        end

        // 2. x0 zero protection
        if (uut.regfile_inst.regs[0] !== 64'd0) begin
            $display("FAIL: x0 is not zero (%0d)", uut.regfile_inst.regs[0]);
            errors = errors + 1;
        end else begin
            $display("PASS: x0 zero protection verified.");
        end

        // 3. Register checks (x1 to x18)
        if (uut.regfile_inst.regs[1] !== 64'd10) begin $display("FAIL: x1 = %0d", uut.regfile_inst.regs[1]); errors++; end
        else $display("PASS: x1 = 10");

        if (uut.regfile_inst.regs[2] !== 64'd20) begin $display("FAIL: x2 = %0d", uut.regfile_inst.regs[2]); errors++; end
        else $display("PASS: x2 = 20");

        if (uut.regfile_inst.regs[3] !== 64'd30) begin $display("FAIL: x3 = %0d", uut.regfile_inst.regs[3]); errors++; end
        else $display("PASS: x3 = 30");

        if (uut.regfile_inst.regs[4] !== 64'd10) begin $display("FAIL: x4 = %0d", uut.regfile_inst.regs[4]); errors++; end
        else $display("PASS: x4 = 10");

        if (uut.regfile_inst.regs[5] !== 64'd0) begin $display("FAIL: x5 = %0d", uut.regfile_inst.regs[5]); errors++; end
        else $display("PASS: x5 = 0");

        if (uut.regfile_inst.regs[6] !== 64'd30) begin $display("FAIL: x6 = %0d", uut.regfile_inst.regs[6]); errors++; end
        else $display("PASS: x6 = 30");

        if (uut.regfile_inst.regs[7] !== 64'd30) begin $display("FAIL: x7 = %0d", uut.regfile_inst.regs[7]); errors++; end
        else $display("PASS: x7 = 30");

        if (uut.regfile_inst.regs[8] !== 64'd1) begin $display("FAIL: x8 = %0d", uut.regfile_inst.regs[8]); errors++; end
        else $display("PASS: x8 = 1");

        if (uut.regfile_inst.regs[9] !== 64'd0) begin $display("FAIL: x9 = %0d", uut.regfile_inst.regs[9]); errors++; end
        else $display("PASS: x9 = 0");

        if (uut.regfile_inst.regs[10] !== 64'd40) begin $display("FAIL: x10 = %0d", uut.regfile_inst.regs[10]); errors++; end
        else $display("PASS: x10 = 40");

        if (uut.regfile_inst.regs[13] !== 64'd30) begin $display("FAIL: x13 = %0d", uut.regfile_inst.regs[13]); errors++; end
        else $display("PASS: x13 (LD 30) = 30");

        if (uut.regfile_inst.regs[14] !== 64'd40) begin $display("FAIL: x14 = %0d", uut.regfile_inst.regs[14]); errors++; end
        else $display("PASS: x14 (Forwarding) = 40");

        if (uut.regfile_inst.regs[15] !== 64'd77) begin $display("FAIL: x15 = %0d", uut.regfile_inst.regs[15]); errors++; end
        else $display("PASS: x15 (Branch target) = 77");

        if (uut.regfile_inst.regs[17] !== 64'd88) begin $display("FAIL: x17 = %0d", uut.regfile_inst.regs[17]); errors++; end
        else $display("PASS: x17 (JAL target) = 88");

        // 4. Memory content verification (SD, SW, SH, SB at bytes 0, 8, 16, 24)
        if (mem_model.dmem[0] !== 8'd30) begin $display("FAIL: dmem[0] = %0d", mem_model.dmem[0]); errors++; end
        else $display("PASS: dmem[0] store verified (30)");

        if (mem_model.dmem[8] !== 8'd10) begin $display("FAIL: dmem[8] = %0d", mem_model.dmem[8]); errors++; end
        else $display("PASS: dmem[8] store verified (10)");

        if (mem_model.dmem[16] !== 8'd20) begin $display("FAIL: dmem[16] = %0d", mem_model.dmem[16]); errors++; end
        else $display("PASS: dmem[16] store verified (20)");

        if (mem_model.dmem[24] !== 8'd10) begin $display("FAIL: dmem[24] = %0d", mem_model.dmem[24]); errors++; end
        else $display("PASS: dmem[24] store verified (10)");

        // 5. Transaction accounting assertions
        $display("INFO: Read Accepted Transactions (LD)  = %0d", read_tx_count);
        $display("INFO: Write Accepted Transactions (ST) = %0d", write_tx_count);
        $display("INFO: Committed Store Count            = %0d", committed_store_count);
        $display("INFO: Total Responses Issued           = %0d", resp_tx_count);
        $display("INFO: Duplicate Transactions           = %0d", duplicate_tx_count);

        if (read_tx_count !== 32'd4) begin
            $display("FAIL: Read transaction count mismatch (%0d, expected 4)", read_tx_count);
            errors++;
        end else begin
            $display("PASS: Read transaction count verified (4)");
        end

        if (write_tx_count !== 32'd4) begin
            $display("FAIL: Write transaction count mismatch (%0d, expected 4)", write_tx_count);
            errors++;
        end else begin
            $display("PASS: Write transaction count verified (4)");
        end

        if (committed_store_count !== write_tx_count) begin
            $display("FAIL: Committed store count mismatch (%0d vs write_tx=%0d)", committed_store_count, write_tx_count);
            errors++;
        end else begin
            $display("PASS: Committed store count matches write transaction count (%0d)", committed_store_count);
        end

        if (resp_tx_count !== (read_tx_count + write_tx_count)) begin
            $display("FAIL: Response count mismatch (resp=%0d vs req=%0d)", resp_tx_count, read_tx_count + write_tx_count);
            errors++;
        end else begin
            $display("PASS: Response count matches accepted requests exactly (%0d)", resp_tx_count);
        end

        if (duplicate_tx_count !== 32'd0) begin
            $display("FAIL: Duplicate transaction count is %0d (expected 0)", duplicate_tx_count);
            errors++;
        end else begin
            $display("PASS: Zero duplicate transactions verified.");
        end

        $display("\n=========================================================");
        if (errors == 0) begin
            $display(" >>> ALL ASSERTIONS PASSED — TEST RESULT: SUCCESS (PASS) <<<");
            $display("=========================================================");
            $finish;
        end else begin
            $display(" >>> TOTAL ERRORS: %0d — TEST RESULT: FAILURE (FAIL) <<<", errors);
            $display("=========================================================");
            $fatal(1, "ASSERTION FAILURE IN TESTBENCH");
        end
    end

endmodule
