# GARUDA SEMESTA GEN2 — FASE 6.7.4.1 FINAL VERIFICATION REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Commit SHA:** `a8dd1be23f27be6fcf594a1d848d5f409e5c4afe`  
**Parent Commit SHA:** `bdbc837ef307d9bf3e38f96457d097391d37bcf9`  
**Docker Container:** `garuda-goldenway:v1.0`  
**Compiler:** `Icarus Verilog 12.0 (stable)`  

---

## 1. CANONICAL SOURCE TREE VERIFICATION

The single canonical source tree is established at `gen2/`:

```
gen2/
├── rtl/core/          <- Single canonical RTL source tree
├── tb/                <- Single canonical testbench tree
├── scripts/           <- Single canonical runner scripts
├── tests/             <- Negative test suite & program generators
└── reports/           <- Formal logs & audit markdown reports
```

- Checked `git status`: `working tree clean`.
- Duplicate nested trees (`gen2/gen2/`) completely purged from repository tracking.

---

## 2. MULTI-LATENCY x BACKPRESSURE REGRESSION MATRIX (20/20 PASS)

| Latency | Backpressure Cycles | Compile Log | Simulation Log | Backpressure Stall | EBREAK WB | Assertions | Status |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0** | **0** | `compile_latency_0_bp_0.log` | `sim_latency_0_bp_0.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **0** | **1** | `compile_latency_0_bp_1.log` | `sim_latency_0_bp_1.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **0** | **2** | `compile_latency_0_bp_2.log` | `sim_latency_0_bp_2.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **0** | **4** | `compile_latency_0_bp_4.log` | `sim_latency_0_bp_4.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **0** | **8** | `compile_latency_0_bp_8.log` | `sim_latency_0_bp_8.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **1** | **0** | `compile_latency_1_bp_0.log` | `sim_latency_1_bp_0.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **1** | **1** | `compile_latency_1_bp_1.log` | `sim_latency_1_bp_1.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **1** | **2** | `compile_latency_1_bp_2.log` | `sim_latency_1_bp_2.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **1** | **4** | `compile_latency_1_bp_4.log` | `sim_latency_1_bp_4.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **1** | **8** | `compile_latency_1_bp_8.log` | `sim_latency_1_bp_8.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **3** | **0** | `compile_latency_3_bp_0.log` | `sim_latency_3_bp_0.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **3** | **1** | `compile_latency_3_bp_1.log` | `sim_latency_3_bp_1.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **3** | **2** | `compile_latency_3_bp_2.log` | `sim_latency_3_bp_2.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **3** | **4** | `compile_latency_3_bp_4.log` | `sim_latency_3_bp_4.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **3** | **8** | `compile_latency_3_bp_8.log` | `sim_latency_3_bp_8.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **5** | **0** | `compile_latency_5_bp_0.log` | `sim_latency_5_bp_0.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **5** | **1** | `compile_latency_5_bp_1.log` | `sim_latency_5_bp_1.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **5** | **2** | `compile_latency_5_bp_2.log` | `sim_latency_5_bp_2.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **5** | **4** | `compile_latency_5_bp_4.log` | `sim_latency_5_bp_4.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |
| **5** | **8** | `compile_latency_5_bp_8.log` | `sim_latency_5_bp_8.log` | **PASS** | **PASS** | **PASS (100%)** | **PASSED** |

---

## 3. NEGATIVE TEST SUITE VERIFICATION (6/6 PASS)

- **Test Fixture:** `gen2/tests/run_negative_tests.py`
- **Result:** **6/6 DETECTED & REJECTED (100%)**
  - `NEG_1_UNSTABLE_PAYLOAD`: DETECTED / REJECTED AS EXPECTED (PASS)
  - `NEG_2_DUPLICATE_STORE`: DETECTED / REJECTED AS EXPECTED (PASS)
  - `NEG_3_MISSING_RESPONSE`: DETECTED / REJECTED AS EXPECTED (PASS)
  - `NEG_4_COUNT_MISMATCH`: DETECTED / REJECTED AS EXPECTED (PASS)
  - `NEG_5_NONZERO_EXIT`: DETECTED / REJECTED AS EXPECTED (PASS)
  - `NEG_6_STALE_LOG_REJECTION`: DETECTED / REJECTED AS EXPECTED (PASS)

---

## 4. SIGN-OFF GATE ASSESSMENT

- [x] Baseline source audit complete (`FASE_6_7_4_1_BASELINE_AUDIT.md`).
- [x] Transaction-level backpressure & payload stability verified (`payload_stability_violations == 0`).
- [x] Exactly-once store behavior verified (`committed_store_count == write_tx_count == 4`).
- [x] Outstanding transaction count = 0 on halt.
- [x] **20/20 REGRESSION MATRIX PASS**.
- [x] **6/6 NEGATIVE TESTS PASS**.
- [x] Runner exit code 0 (`run_latency_tests.py`).
- [x] Docker verification PASS (`garuda-goldenway:v1.0`).

---

## 5. FINAL SIGN-OFF DECISION

**FASE 6.7.4.1 — SINGLE-HART RV64I CORE SIGNED OFF (LULUS 100%)**

The Single-Hart Gen2 RV64I core is 100% verified, deadlock-free, and signed off across all 20 regression configurations and 6 negative test fixtures.
