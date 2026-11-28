# GARUDA SEMESTA GEN2 — FASE 6.7.4 INITIAL SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** Single-Hart RV64I Memory Pipeline & Backpressure Matrix  

---

## 1. PRE-REPAIR ARCHITECTURAL ANALYSIS & AUDIT FINDINGS

Forensic review of `gen2/rtl/core/garuda_rv64i_core.v`, `gen2/rtl/core/rv64i_memory_model.v`, `gen2/tb/garuda_rv64i_core_tb.v`, and `gen2/scripts/run_latency_tests.py` identified the precise root causes requiring FASE 6.7.4 repair:

1. **Latency-0 Re-Commit Defect (`rv64i_memory_model.v`)**:
   - On `LATENCY = 0`, combinational memory evaluated `dmem_valid && dmem_ready && dmem_resp_ready`.
   - When external backpressure stalled a transaction for multiple cycles, `dmem_valid` remained high for the same instruction across consecutive clock edges.
   - Once backpressure was released, if `tx_committed` was cleared on `dmem_resp_ready = 1`, the same instruction in EX/MEM was accepted and committed a second time before `ex_mem_reg` advanced on `posedge clk`.
   - **Fix:** `tx_committed` register tracks commit state per instruction. `tx_committed` is cleared ONLY when `ex_mem_reg` advances or `dmem_valid` drops, preventing double-commit on LATENCY = 0.

2. **Store Count Mismatch Audit**:
   - The test workload (`single_hart_program.hex`) contains **4** store instructions (`SD`, `SW`, `SH`, `SB`).
   - The observed store count of 5 in previous runs was caused by LATENCY = 0 re-committing `sd x3, 0(x0)` when backpressure stall deasserted `tb_resp_ready_mask` mid-transaction.
   - **Fix:** Exactly-once store commit logic in `rv64i_memory_model.v` ensures `committed_store_count == write_tx_count == 4`.

3. **Arbitrary Time-Based Backpressure vs. Clock-Cycle Matrix**:
   - Testbench used `#10`, `#20` time delays instead of counting `@(posedge clk)` clock cycles.
   - **Fix:** Testbench parameter `BACKPRESSURE_CYCLES` and `@(posedge clk)` loop count exact 1, 2, 4, 8 clock cycles of backpressure stall.
