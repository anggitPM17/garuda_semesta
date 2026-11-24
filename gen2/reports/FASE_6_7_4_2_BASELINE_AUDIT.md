# GARUDA SEMESTA GEN2 — FASE 6.7.4.2 BASELINE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Commit SHA:** `4fe8b05a1452eacd15b2efde576552b5e6c0828b`  
**Parent Commit SHA:** `a8dd1be23f27be6fcf594a1d848d5f409e5c4afe`  

---

## 1. BASELINE INVENTORY & AUDIT MATRIX

| Item | Actual Status | Evidence / File Path |
| :--- | :--- | :--- |
| **RTL Core** | Verified (Loop-free valid-ready handshake) | `gen2/rtl/core/garuda_rv64i_core.v` |
| **Memory Model** | Verified (Wait-for-handshake FSM) | `gen2/rtl/core/rv64i_memory_model.v` |
| **Testbench** | Enhanced (Adding Per-Transaction Sequence Scoreboard & Stability Monitor) | `gen2/tb/garuda_rv64i_core_tb.v` |
| **Regression Runner** | Enhanced (Stale protection, JSON output) | `gen2/scripts/run_latency_tests.py` |
| **Negative Test Suite** | Enhanced (6/6 Isolated Fault Injection) | `gen2/tests/run_negative_tests.py` |
| **Simulation Logs** | Verified (20 fresh matrix logs) | `gen2/reports/sim_latency_*_bp_*.log` |
| **Compile Logs** | Verified (20 fresh compile logs) | `gen2/reports/compile_latency_*_bp_*.log` |
| **Docker Environment** | Active | `garuda-goldenway:v1.0` (Icarus Verilog 12.0) |

---

## 2. RECONCILIATION & AUDIT FINDINGS

1. **Per-Transaction Sequence Tracking**:
   - Testbench in `garuda_rv64i_core_tb.v` has been upgraded to track unique transaction sequence IDs (`tx_seq_id`) on every accepted request and completed response.
2. **Payload Stability Monitor**:
   - The monitor captures a snapshot of `dmem_addr`, `dmem_wen`, `dmem_wdata`, `dmem_funct3`, `dmem_rdata`, and `dmem_resp_valid` at the start of a response stall and verifies on every `@(posedge clk)` that zero fields mutate while `dmem_resp_ready_effective == 0`.
3. **Negative Test Fixtures**:
   - A dedicated negative test runner (`gen2/tests/run_negative_tests.py`) executes 6 isolated negative test fixtures in Docker to prove that payload instability, duplicate store commits, missing responses, transaction count mismatches, non-zero exit codes, and stale logs are 100% detected and rejected by the verifier.
