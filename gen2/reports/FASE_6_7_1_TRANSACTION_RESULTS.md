# GARUDA SEMESTA GEN2 — FASE 6.7.1 TRANSACTION RESULTS

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  

---

## 1. MULTI-LATENCY SUMMARY REPORT

```text
=========================================
      MULTI-LATENCY SUMMARY REPORT       
=========================================
  LATENCY = 0: PASS
  LATENCY = 1: PASS
  LATENCY = 3: PASS
  LATENCY = 5: PASS
=========================================
```

---

## 2. TRANSACTION ACCOUNTING MATRIX

| Latency | Accepted Reads | Accepted Writes | Committed Stores | Completed Responses | Duplicate Tx | Outstanding Tx on Halt | Status |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0** | **4** | **4** | **4** | **8** | **0** | **0** | **PASSED** |
| **1** | **4** | **4** | **4** | **8** | **0** | **0** | **PASSED** |
| **3** | **4** | **4** | **4** | **8** | **0** | **0** | **PASSED** |
| **5** | **4** | **4** | **4** | **8** | **0** | **0** | **PASSED** |

---

## 3. ASSERTION VERIFICATION MATRIX (ALL LATENCIES)

- **x0 Protection:** `PASS` (`x0 == 0`)
- **Register Calculations:** $x1$–$x18$ `PASS (100%)` across all 4 latencies
- **Data Memory Byte Verification:** `dmem[0..24]` `PASS (100%)` across all 4 latencies
- **Transaction Accounting Assertions:** `PASS (100%)` (`read_tx == 4`, `write_tx == 4`, `resp_tx == 8`, `committed_stores == 4`, `duplicate_tx == 0`)
- **Backpressure Stall Stability:** `PASS (100%)`
- **EBREAK WB Stage Retirement:** `PASS`
- **Runner Exit Code:** `0`
