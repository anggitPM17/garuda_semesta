# GARUDA SEMESTA GEN2 — FASE 6.7.3 SCOREBOARD & ASSERTION RESULTS

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. SCOREBOARD METRICS SUMMARY

For the baseline program (`single_hart_program.hex`):

- **Accepted Reads (`read_tx_count`)**: `4` (LD, LW, LH, LB)
- **Accepted Writes (`write_tx_count`)**: `4` (SD, SW, SH, SB)
- **Committed Stores (`committed_store_count`)**: `4`
- **Completed Responses (`resp_tx_count`)**: `8` (`read_tx_count + write_tx_count`)
- **Duplicate Transactions (`duplicate_tx_count`)**: `0`
- **Outstanding Transactions on Halt**: `0`

---

## 2. AUTOMATED SCOREBOARD ASSERTION MATRIX

- **x0 Protection:** `PASS` (`x0 == 0`)
- **Register Calculations:** $x1$–$x18$ `PASS (100%)`
- **Data Memory Byte Verification:** `dmem[0..24]` `PASS (100%)`
- **Transaction Accounting Assertions:** `PASS (100%)`
- **Backpressure Stall Stability:** `PASS (100%)` (1, 2, 4, 8 cycles)
- **EBREAK WB Stage Retirement:** `PASS`
- **Watchdog Status:** `PASS` (No timeout, exit code 0)
