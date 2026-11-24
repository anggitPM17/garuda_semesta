# GARUDA SEMESTA GEN2 — FASE 6.7.4.1 RUNNER INTEGRITY REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. REGRESSION RUNNER INTEGRITY & STALE ARTIFACT PROTECTION

The regression runner (`gen2/scripts/run_latency_tests.py`) was enhanced with multi-layered verification:

1. **Stale Log Cleanup**: Prior `.vvp` binaries and `.log` outputs are unlinked before each compile/simulation run.
2. **Compiler & Simulator Exit Code Inspection**: Asserts `returncode == 0` for both `iverilog` and `vvp`.
3. **Scoreboard Validation**: Verifies `Read Accepted == 4`, `Write Accepted == 4`, `Committed Stores == 4`, `Total Responses == 8`, `Duplicate Tx == 0`, and `Payload Stability Violations == 0`.
4. **Machine-Readable Summary Output**: Produces `reports/regression_summary.json` containing structured test metadata.
