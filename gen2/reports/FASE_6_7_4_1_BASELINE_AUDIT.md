# GARUDA SEMESTA GEN2 — FASE 6.7.4.1 BASELINE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Commit SHA:** `a8dd1be23f27be6fcf594a1d848d5f409e5c4afe`  
**Parent Commit SHA:** `bdbc837ef307d9bf3e38f96457d097391d37bcf9`  

---

## 1. BASELINE INVENTORY & FORENSIC AUDIT MATRIX

| Item | Actual Status | Evidence / File Path |
| :--- | :--- | :--- |
| **RTL Core** | Verified (Loop-free valid-ready handshake) | `gen2/rtl/core/garuda_rv64i_core.v` |
| **Memory Model** | Verified (Wait-for-handshake FSM) | `gen2/rtl/core/rv64i_memory_model.v` |
| **Testbench** | Enhanced (Adding Scoreboard & Stability Monitor) | `gen2/tb/garuda_rv64i_core_tb.v` |
| **Regression Runner** | Enhanced (Stale protection, JSON output) | `gen2/scripts/run_latency_tests.py` |
| **Simulation Logs** | Verified (20 fresh matrix logs) | `gen2/reports/sim_latency_*_bp_*.log` |
| **Compile Logs** | Verified (20 fresh compile logs) | `gen2/reports/compile_latency_*_bp_*.log` |
| **Docker Environment** | Active | `garuda-goldenway:v1.0` (Icarus Verilog 12.0) |
| **Previous Signoff Report**| FASE 6.7.4 Final Report | `gen2/reports/FASE_6_7_4_FINAL_REPORT.md` |

---

## 2. RECONCILIATION OF PREVIOUS REPORT INCONSISTENCY

In an intermediate draft of FASE 6.7.4 (`FASE_6_7_4_TRANSACTION_RESULTS.md`), the configuration `LATENCY=1, BP=4` had been recorded with `Committed Stores = 8`.
- **Forensic Investigation:** This was caused by an early test run prior to setting `tx_committed` protection on LATENCY = 0 / 1 in `rv64i_memory_model.v` (Commit `a8dd1be23f27be6fcf594a1d848d5f409e5c4afe`).
- **Correction Proof:** All fresh Docker simulations across all 20 configurations confirm `Committed Stores = 4`, matching the exact instruction workload (`single_hart_program.hex`) containing 4 store instructions (`SD`, `SW`, `SH`, `SB`).
