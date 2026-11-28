# GARUDA SEMESTA GEN2 — FASE 6.7.4.1 TRANSACTION MONITOR REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  

---

## 1. INDEPENDENT TRANSACTION SCOREBOARD

An independent protocol monitor and scoreboard was integrated into `gen2/tb/garuda_rv64i_core_tb.v` to track memory transactions during simulation:

```text
INFO: Read Accepted Transactions (LD)  = 4
INFO: Write Accepted Transactions (ST) = 4
INFO: Committed Store Count            = 4
INFO: Total Responses Issued           = 8
INFO: Duplicate Transactions           = 0
INFO: Payload Stability Violations    = 0
```

---

## 2. AUTOMATED SCOREBOARD ASSERTION CHECKS

- **Read Transactions (`read_tx_count`)**: **4** (`LD`, `LW`, `LH`, `LB`)
- **Write Transactions (`write_tx_count`)**: **4** (`SD`, `SW`, `SH`, `SB`)
- **Committed Stores (`committed_store_count`)**: **4** (`committed_store_count == write_tx_count`)
- **Total Responses Issued (`resp_tx_count`)**: **8** (`read_tx_count + write_tx_count`)
- **Duplicate Transactions (`duplicate_tx_count`)**: **0**
- **Payload Stability Violations (`payload_stability_violations`)**: **0**
- **Outstanding Transactions on Halt**: **0**
