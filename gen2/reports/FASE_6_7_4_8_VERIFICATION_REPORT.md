# GARUDA SEMESTA GEN2 — FASE 6.7.4.8 VERIFICATION & COMMIT-BOUND SIGN-OFF REPORT

**Date:** November 25, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  
**Compiler:** `Icarus Verilog 12.0 (stable)`  

---

## 1. EXECUTIVE SUMMARY & VERDICT

- **Verdict**: **`FASE 6.7.4.8 — PASS`**
- **Initial Baseline SHA**: `20d58dcdad2b48a0145abea4b118b742f6ca5e0a`
- **Final Tested Commit SHA**: `20d58dcdad2b48a0145abea4b118b742f6ca5e0a`
- **Regression Matrix Results**: **20 / 20 PASSED (100%)**
- **Negative Test Results**: **6 / 6 PASSED (100% Real Fault Injection)**

---

## 2. REAL FAULT INJECTION NEGATIVE TEST MATRIX (6/6 PASS)

| Scenario | Category | Fault Description | Expected Checker Signature | Result |
| :--- | :--- | :--- | :--- | :---: |
| **NEG-01** | RTL Checker | Mutate address payload mid-stall | `PAYLOAD STABILITY VIOLATION DETECTED DURING BACKPRESSURE STALL` | **PASS (Exit 1)** |
| **NEG-02** | RTL Checker | Inject duplicate store commit into memory model | `FAIL: Committed store count mismatch` | **PASS (Exit 1)** |
| **NEG-03** | RTL Checker | Suppress response valid permanently | `WATCHDOG TIMEOUT — Core failed to reach EBREAK` / `RESPONSE TIMEOUT WATCHDOG DETECTED` | **PASS (Exit 1)** |
| **NEG-04** | RTL Checker | Inject transaction request count mismatch | `Independent request/response count mismatch` | **PASS (Exit 1)** |
| **NEG-05** | Infrastructure | Force genuine simulator `$fatal` exit | `DELIBERATE SIMULATOR FATAL EXIT` | **PASS (Exit 1)** |
| **NEG-06** | Validator | Test evidence validator against invalid metadata | `COMMIT_SHA_MISMATCH`, `BRANCH_MISMATCH`, `EMPTY_RESULTS` | **PASS** |

---

## 3. MULTI-LATENCY x BACKPRESSURE REGRESSION MATRIX (20/20 PASS)

All 20 configurations passed with strict scoreboard criteria:
- Read Accepted Transactions: **4**
- Write Accepted Transactions: **4**
- Committed Stores: **4**
- Total Responses Issued: **8**
- TB Accepted Requests: **8**
- TB Completed Responses: **8**
- TB Outstanding Requests: **0**
- TB Duplicate Responses: **0**
- TB Protocol Violations: **0**
- Payload Stability Violations: **0**
- TB Max Outstanding: **0** (for Latency 0) / **1** (for Latency > 0)
