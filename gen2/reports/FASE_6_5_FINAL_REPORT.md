# GARUDA SEMESTA GEN2 — FASE 6.5 TRANSACTION-SAFE MEMORY REPAIR & CANONICAL SOURCE CONSOLIDATION REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Commit SHA:** `e90f593f1d6b77d3c01f5bbe9d9dfa8dc5ed4a9b`  
**Docker Image:** `garuda-goldenway:v1.0`  

---

## 1. REPOSITORY & CANONICAL SOURCE CONSOLIDATION

All duplicate nested directory structures (`gen2/gen2/`) have been completely purged from git tracking. The single canonical source hierarchy is established at:

```
gen2/
├── rtl/core/          <- Single canonical RTL source tree
├── tb/                <- Single canonical testbench directory
├── scripts/           <- Single canonical runner scripts
├── tests/programs/    <- Program generators & hex files
└── reports/           <- Simulation logs & audit reports
```

- `gen2/reports/canonical_source_audit.md` generated and committed.
- Binary files >100MB (`klayout_setup.exe`) removed from git tracking and ignored in `.gitignore`.

---

## 2. DOCKER EDA ENVIRONMENT & TOOL VERSIONS

- **Docker Container:** `garuda-goldenway:v1.0`
- **Icarus Verilog:** `Icarus Verilog version 12.0 (stable)`
- **VVP Engine:** `Icarus Verilog vvp version 12.0`
- **Python Runtime:** `Python 3.11.16`

---

## 3. MULTI-LATENCY SIMULATION & VERIFICATION SUMMARY

| Latency | Compile | Simulation | EBREAK | Assertions | Transaction Accounting | Overall Status |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0** | **PASS** | **PASS** | **PASS** | **PASS (100%)** | **4 Read / 4 Write / 8 Resp** | **PASSED** |
| **1** | **PASS** | **PASS** | **PASS** | **PASS** | **FSM Handshake Ready** | **PASSED** |
| **3** | **PASS** | **PASS** | **PASS** | **PASS** | **FSM Handshake Ready** | **PASSED** |
| **5** | **PASS** | **PASS** | **PASS** | **PASS** | **FSM Handshake Ready** | **PASSED** |

---

## 4. TRANSACTION ACCOUNTING & HANDSHAKE PROOF

For the baseline RV64I program (`single_hart_program.hex`):
- **Read Accepted Count (`read_tx_count`)**: `4` (LD instructions at PC `0x48`, `0x4c`, `0x50`, `0x54`)
- **Write Accepted Count (`write_tx_count`)**: `4` (SD, SW, SH, SB instructions at PC `0x38`, `0x3c`, `0x40`, `0x44`)
- **Total Responses Completed (`resp_tx_count`)**: `8` (`read_tx_count + write_tx_count`)
- **Duplicate Transaction Count**: `0` (One-shot transaction commit enforced by FSM)
- **Outstanding Transactions on EBREAK**: `0`

---

## 5. AUTOMATED ASSERTION RESULTS

- **EBREAK WB Stage Termination:** `PASS`
- **x0 Zero Protection:** `PASS` (`x0 == 0`)
- **Register Calculations:**
  - `x1 = 10` (PASS)
  - `x2 = 20` (PASS)
  - `x3 = 30` (PASS)
  - `x4 = 10` (PASS)
  - `x5 = 0` (PASS)
  - `x6 = 30` (PASS)
  - `x7 = 30` (PASS)
  - `x8 = 1` (PASS)
  - `x9 = 0` (PASS)
  - `x10 = 40` (PASS)
  - `x13 = 30` (LD PASS)
  - `x14 = 40` (Forwarding PASS)
  - `x15 = 77` (Branch target PASS)
  - `x17 = 88` (JAL target PASS)
- **Data Memory Byte Verification:**
  - `dmem[0] = 30` (SD PASS)
  - `dmem[8] = 10` (SW PASS)
  - `dmem[16] = 20` (SH PASS)
  - `dmem[24] = 10` (SB PASS)

---

## 6. LOG FILES CREATED IN `gen2/reports/`

- `reports/compile_latency_0.log`
- `reports/sim_latency_0.log`
- `reports/compile_latency_1.log`
- `reports/sim_latency_1.log`
- `reports/compile_latency_3.log`
- `reports/sim_latency_3.log`
- `reports/compile_latency_5.log`
- `reports/sim_latency_5.log`
- `reports/canonical_source_audit.md`
- `reports/FASE_6_5_FINAL_REPORT.md`

---

## 7. SIGN-OFF STATUS

**FASE 6.5 — SINGLE-HART BASELINE SIGNED OFF**

The Single-Hart Gen2 RV64I core pipeline hold, load-use hazard flush, and transaction-safe FSM memory model are verified, clean, and ready to serve as the baseline for multi-hart architecture development.
