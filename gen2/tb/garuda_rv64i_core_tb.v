`timescale 1ns / 1ps

`ifndef BACKPRESSURE_CYCLES
  `define BACKPRESSURE_CYCLES 0
`endif

`ifndef MEM_LATENCY
  `define MEM_LATENCY 0
`endif

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

    // Independent backpressure injection control.
    // This signal must not depend on core response-ready output.
    reg         tb_resp_ready_mask = 1'b1;

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
        .dmem_resp_ready(dmem_resp_ready_core),
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
        .dmem_resp_ready_in(tb_resp_ready_mask), // Connect external backpressure input
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

    // ============================================================
    // FASE 6.7.4.7 — RESPONSE TIMEOUT WATCHDOG
    // ============================================================
    parameter integer RESPONSE_TIMEOUT_CYCLES = 40;

    integer response_watchdog_cycles = 0;
    reg     response_watchdog_armed = 0;

    always @(posedge clk) begin
        if (!rst_n) begin
            response_watchdog_cycles <= 0;
            response_watchdog_armed  <= 0;
        end else begin
            if (dmem_resp_valid && dmem_resp_ready_core) begin
                response_watchdog_armed  <= 1'b0;
                response_watchdog_cycles <= 0;
            end else if (dmem_valid && dmem_ready) begin
                if (!response_watchdog_armed) begin
                    response_watchdog_armed  <= 1'b1;
                    response_watchdog_cycles <= 0;
                end else begin
                    response_watchdog_cycles <= response_watchdog_cycles + 1;
                    if (response_watchdog_cycles >= RESPONSE_TIMEOUT_CYCLES - 1) begin
                        $display("FAIL: RESPONSE TIMEOUT FOR TRANSACTION %0d at T=%0t", tb_current_tx_id, $time);
                        $display("RESPONSE TIMEOUT FOR TRANSACTION");
                        $fatal(1, "RESPONSE TIMEOUT WATCHDOG DETECTED");
                    end
                end
            end else if (response_watchdog_armed) begin
                response_watchdog_cycles <= response_watchdog_cycles + 1;
                if (response_watchdog_cycles >= RESPONSE_TIMEOUT_CYCLES - 1) begin
                    $display("FAIL: RESPONSE TIMEOUT FOR TRANSACTION %0d at T=%0t", tb_current_tx_id, $time);
                    $display("RESPONSE TIMEOUT FOR TRANSACTION");
                    $fatal(1, "RESPONSE TIMEOUT WATCHDOG DETECTED");
                end
            end
        end
    end

    integer errors = 0;
    integer payload_stability_violations = 0;
    integer bp_count = `BACKPRESSURE_CYCLES;

    // ============================================================
    // INDEPENDENT REQUEST/RESPONSE TRANSACTION SCOREBOARD
    // Does not trust memory-model duplicate_tx_count.
    // ============================================================

    wire tb_request_accept =
        dmem_valid && dmem_ready;

    wire tb_response_accept =
        dmem_resp_valid && dmem_resp_ready_core;

    integer tb_accepted_count = 0;
    integer tb_completed_count = 0;
    integer tb_outstanding_count = 0;
    integer tb_duplicate_response_count = 0;
    integer tb_protocol_violation_count = 0;
    integer tb_max_outstanding_count = 0;

    integer tb_current_tx_id = 0;
    integer tb_last_committed_tx_id = -1;
    integer tb_duplicate_store_commit_count = 0;

    always @(posedge clk) begin
        if (!rst_n) begin
            tb_current_tx_id <= 0;
            tb_last_committed_tx_id <= -1;
            tb_duplicate_store_commit_count <= 0;
        end else begin
            if (tb_request_accept) begin
                tb_current_tx_id <= tb_current_tx_id + 1;
            end

            if (tb_response_accept && dmem_wen) begin
                if (tb_last_committed_tx_id == tb_current_tx_id && tb_current_tx_id != 0) begin
                    tb_duplicate_store_commit_count <= tb_duplicate_store_commit_count + 1;
                    $display("FAIL: Duplicate store commit detected for TX ID %0d at T=%0t", tb_current_tx_id, $time);
                    $display("DUPLICATE STORE COMMIT DETECTED");
                    $fatal(1, "DUPLICATE STORE COMMIT DETECTED");
                end else begin
                    tb_last_committed_tx_id <= tb_current_tx_id;
                end
            end
        end
    end

    // ============================================================
    // INDEPENDENT REQUEST/RESPONSE TRANSACTION SCOREBOARD
    // Mode-aware response provenance and outstanding tracking.
    // ============================================================

    always @(posedge clk) begin
        if (!rst_n) begin
            tb_accepted_count             = 0;
            tb_completed_count            = 0;
            tb_outstanding_count          = 0;
            tb_duplicate_response_count   = 0;
            tb_protocol_violation_count   = 0;
            tb_max_outstanding_count      = 0;
        end else begin

            // ----------------------------------------------------
            // 1. Detect unsolicited or duplicate responses.
            //
            // Same-cycle request + response is legal ONLY for
            // zero-latency atomic request/response mode.
            // ----------------------------------------------------

            if (tb_response_accept &&
                (tb_outstanding_count == 0)) begin

                if (!((`MEM_LATENCY == 0) && tb_request_accept)) begin
                    tb_duplicate_response_count =
                        tb_duplicate_response_count + 1;

                    tb_protocol_violation_count =
                        tb_protocol_violation_count + 1;

                    $display(
                        "FAIL: Unsolicited response at T=%0t",
                        $time
                    );
                end
            end

            // ----------------------------------------------------
            // 2. A non-zero-latency memory must not accept a new
            // request while an earlier request is outstanding.
            // ----------------------------------------------------

            if ((`MEM_LATENCY != 0) &&
                tb_request_accept &&
                (tb_outstanding_count != 0)) begin

                tb_protocol_violation_count =
                    tb_protocol_violation_count + 1;

                $display(
                    "FAIL: Multiple outstanding requests at T=%0t",
                    $time
                );
            end

            // ----------------------------------------------------
            // 3. Count accepted requests and consumed responses.
            // ----------------------------------------------------

            if (tb_request_accept)
                tb_accepted_count = tb_accepted_count + 1;

            if (tb_response_accept)
                tb_completed_count = tb_completed_count + 1;

            // ----------------------------------------------------
            // 4. Update outstanding transaction count.
            // ----------------------------------------------------

            tb_outstanding_count =
                tb_outstanding_count +
                (tb_request_accept ? 1 : 0) -
                (tb_response_accept ? 1 : 0);

            if (tb_outstanding_count < 0) begin

                tb_duplicate_response_count =
                    tb_duplicate_response_count + 1;

                tb_protocol_violation_count =
                    tb_protocol_violation_count + 1;

                $display(
                    "FAIL: Outstanding transaction count underflow at T=%0t",
                    $time
                );

                tb_outstanding_count = 0;
            end

            // ----------------------------------------------------
            // 5. Record maximum outstanding transaction depth.
            // ----------------------------------------------------

            if (tb_outstanding_count > tb_max_outstanding_count)
                tb_max_outstanding_count = tb_outstanding_count;

            if (tb_outstanding_count > 1) begin

                tb_protocol_violation_count =
                    tb_protocol_violation_count + 1;

                if (tb_protocol_violation_count <= 10) begin
                    $display(
                        "FAIL: More than one outstanding transaction at T=%0t",
                        $time
                    );
                end
            end
        end
    end

    // Payload Stability & Per-Transaction Backpressure Monitor
    reg [63:0] latched_addr;
    reg        latched_wen;
    reg [2:0]  latched_funct3;
    reg [63:0] latched_wdata;
    reg [63:0] latched_rdata;

    initial begin
        tb_resp_ready_mask = 1'b1;
        if (bp_count > 0) begin
            #100;
            // Wait until memory enters active RESPONSE phase (dmem_valid && dmem_resp_valid)
            wait (dmem_valid && dmem_resp_valid);

            // Capture payload at start of response backpressure stall
            latched_addr   = dmem_addr;
            latched_wen    = dmem_wen;
            latched_funct3 = dmem_funct3;
            latched_wdata  = dmem_wdata;
            latched_rdata  = dmem_rdata;

            tb_resp_ready_mask <= 1'b0; // Inject response backpressure stall for bp_count cycles

            repeat (bp_count) begin
                @(posedge clk);
                // Verify payload & response stability on every stalled clock edge
                if (dmem_addr !== latched_addr || dmem_wen !== latched_wen ||
                    dmem_funct3 !== latched_funct3 || dmem_wdata !== latched_wdata ||
                    (!dmem_wen && (dmem_rdata !== latched_rdata)) || !dmem_resp_valid) begin
                    $display("FAIL: Payload stability violation at T=%0t!", $time);
                    payload_stability_violations++;
                    $fatal(1, "PAYLOAD STABILITY VIOLATION DETECTED DURING BACKPRESSURE STALL");
                end

                if (dmem_resp_ready_core !== 1'b0) begin
                    $display(
                        "FAIL: Core response-ready was not LOW during backpressure at T=%0t!",
                        $time
                    );
                    payload_stability_violations++;
                    $fatal(
                        1,
                        "BACKPRESSURE INJECTION FAILED"
                    );
                end
            end

            $display("PASS: Response valid and payload held stable during %0d-cycle backpressure stall.", bp_count);
            tb_resp_ready_mask <= 1'b1; // Release backpressure
        end
    end

    initial begin
        $display("=========================================================");
        $display(" GARUDA SEMESTA GEN2 — FASE 6.7.4.1 HARDENING TEST");
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

        // 5. Scoreboard transaction accounting assertions
        $display("INFO: Read Accepted Transactions (LD)  = %0d", read_tx_count);
        $display("INFO: Write Accepted Transactions (ST) = %0d", write_tx_count);
        $display("INFO: Committed Store Count            = %0d", committed_store_count);
        $display("INFO: Total Responses Issued           = %0d", resp_tx_count);
        $display("INFO: Duplicate Transactions           = %0d", duplicate_tx_count);
        $display("INFO: Payload Stability Violations    = %0d", payload_stability_violations);

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
            $display("DUPLICATE STORE COMMIT DETECTED");
            errors++;
        end else begin
            $display("PASS: Committed store count matches write transaction count (4)");
        end

        if (resp_tx_count !== (read_tx_count + write_tx_count)) begin
            $display("FAIL: Response count mismatch (resp=%0d vs req=%0d)", resp_tx_count, read_tx_count + write_tx_count);
            errors++;
        end else begin
            $display("PASS: Response count matches accepted requests exactly (8)");
        end

        if (duplicate_tx_count !== 32'd0) begin
            $display("FAIL: Duplicate transaction count is %0d (expected 0)", duplicate_tx_count);
            errors++;
        end else begin
            $display("PASS: Zero duplicate transactions verified.");
        end

        if (payload_stability_violations !== 32'd0) begin
            $display("FAIL: Payload stability violations detected (%0d)", payload_stability_violations);
            errors++;
        end else begin
            $display("PASS: Zero payload stability violations verified.");
        end

        // 6. Independent transaction scoreboard verification
        $display("INFO: TB Accepted Requests       = %0d",
                 tb_accepted_count);
        $display("INFO: TB Completed Responses    = %0d",
                 tb_completed_count);
        $display("INFO: TB Outstanding Requests   = %0d",
                 tb_outstanding_count);
        $display("INFO: TB Duplicate Responses     = %0d",
                 tb_duplicate_response_count);

        if (tb_accepted_count !== tb_completed_count) begin
            $display("FAIL: Independent request/response count mismatch.");
            $display("TRANSACTION MISMATCH DETECTED");
            errors++;
        end else begin
            $display("PASS: Independent request/response counts match.");
        end

        if (tb_outstanding_count !== 0) begin
            $display("FAIL: Outstanding transactions remain.");
            errors++;
        end else begin
            $display("PASS: No outstanding transactions remain.");
        end

        if (tb_duplicate_response_count !== 0) begin
            $display("FAIL: Duplicate or unsolicited response detected.");
            errors++;
        end else begin
            $display("PASS: No duplicate or unsolicited responses detected.");
        end

        // 7. Protocol violation verification
        $display("INFO: TB Protocol Violations       = %0d",
                 tb_protocol_violation_count);

        $display("INFO: TB Maximum Outstanding       = %0d",
                 tb_max_outstanding_count);

        if (tb_protocol_violation_count !== 0) begin
            $display("FAIL: Memory protocol violations detected.");
            errors++;
        end else begin
            $display("PASS: No memory protocol violations.");
        end

        if (tb_max_outstanding_count > 1) begin
            $display("FAIL: More than one outstanding transaction detected.");
            errors++;
        end else begin
            $display("PASS: Outstanding transaction depth is valid.");
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
