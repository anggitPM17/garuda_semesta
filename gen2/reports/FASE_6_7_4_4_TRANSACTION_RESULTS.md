# GARUDA SEMESTA GEN2 — FASE 6.7.4.4 TRANSACTION RESULTS REPORT

**Date:** November 24, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  

---

## 1. 20-CONFIGURATION REGRESSION MATRIX SUMMARY

| Configuration | Latency | Backpressure Cycles | Read Tx | Write Tx | Committed Stores | Completed Responses | Status |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `LATENCY=0_BP=0` | 0 | 0 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=0_BP=1` | 0 | 1 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=0_BP=2` | 0 | 2 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=0_BP=4` | 0 | 4 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=0_BP=8` | 0 | 8 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=1_BP=0` | 1 | 0 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=1_BP=1` | 1 | 1 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=1_BP=2` | 1 | 2 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=1_BP=4` | 1 | 4 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=1_BP=8` | 1 | 8 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=3_BP=0` | 3 | 0 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=3_BP=1` | 3 | 1 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=3_BP=2` | 3 | 2 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=3_BP=4` | 3 | 4 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=3_BP=8` | 3 | 8 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=5_BP=0` | 5 | 0 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=5_BP=1` | 5 | 1 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=5_BP=2` | 5 | 2 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=5_BP=4` | 5 | 4 | 4 | 4 | 4 | 8 | **PASSED** |
| `LATENCY=5_BP=8` | 5 | 8 | 4 | 4 | 4 | 8 | **PASSED** |

---

## 2. ASSERTION & SCOREBOARD VERIFICATION MATRIX

- **x0 Protection:** `PASS` (`x0 == 0`)
- **Register Calculations:** $x1$–$x18$ `PASS (100%)` across all 20 configurations
- **Data Memory Byte Verification:** `dmem[0..24]` `PASS (100%)` across all 20 configurations
- **Transaction Accounting Assertions:** `PASS (100%)` (`read_tx == 4`, `write_tx == 4`, `resp_tx == 8`, `committed_stores == 4`, `duplicate_tx == 0`)
- **Backpressure Stall Stability:** `PASS (100%)` (1, 2, 4, 8 clock cycles)
- **EBREAK WB Stage Retirement:** `PASS`
- **Runner Exit Code:** `0`
