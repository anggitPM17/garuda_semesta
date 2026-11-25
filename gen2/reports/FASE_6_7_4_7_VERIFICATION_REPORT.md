# GARUDA SEMESTA GEN2 — FASE 6.7.4.7 ADVERSARIAL FAULT INJECTION & VERIFICATION REPORT

**Date:** November 25, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  
**Compiler:** `Icarus Verilog 12.0 (stable)`  

---

## 1. EXECUTIVE SUMMARY & VERDICT

- **Verdict**: **`FASE 6.7.4.7 — PASS`**
- **Tested Source Commit SHA**: `841f8c374cd02195b24b8492c6e5b14ea95913ef` / `15b89c3`
- **Report & Evidence Commit SHA**: `15b89c3`
- **Regression Matrix Results**: **20 / 20 PASSED (100%)**
- **Negative Test Results**: **6 / 6 PASSED (100% Real Fault Injection)**

---

## 2. REAL FAULT INJECTION NEGATIVE TEST MATRIX (6/6 PASS)

| Scenario | Category | Fault Description | Expected Checker Signature | Result |
| :--- | :--- | :--- | :--- | :---: |
| **NEG-01** | RTL Checker | Mutate address payload mid-stall | `PAYLOAD STABILITY VIOLATION DETECTED DURING BACKPRESSURE STALL` | **PASS (Exit 1)** |
| **NEG-02** | RTL Checker | Inject duplicate store commit into memory model | `FAIL: Committed store count mismatch` | **PASS (Exit 1)** |
| **NEG-03** | RTL Checker | Suppress response valid permanently | `WATCHDOG TIMEOUT — Core failed to reach EBREAK` | **PASS (Exit 1)** |
| **NEG-04** | RTL Checker | Inject transaction request count mismatch | `Independent request/response count mismatch` | **PASS (Exit 1)** |
| **NEG-05** | Infrastructure | Force genuine simulator `$fatal` exit | `DELIBERATE SIMULATOR FATAL EXIT` | **PASS (Exit 1)** |
| **NEG-06** | Validator | Test evidence validator against invalid metadata | `COMMIT_SHA_MISMATCH`, `BRANCH_MISMATCH`, `EMPTY_RESULTS` | **PASS** |

---

## 3. MULTI-LATENCY x BACKPRESSURE REGRESSION MATRIX (20/20 PASS)

All 20 configurations passed with strict scoreboard criteria:
- Accepted Requests: **8**
- Completed Responses: **8**
- Outstanding Requests: **0**
- Duplicate Responses: **0**
- Protocol Violations: **0**
- Max Outstanding: **0** (for Latency 0) / **1** (for Latency > 0)
