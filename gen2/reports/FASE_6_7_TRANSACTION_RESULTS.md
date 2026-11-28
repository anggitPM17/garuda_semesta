# GARUDA SEMESTA GEN2 — FASE 6.7 TRANSACTION RESULTS REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Image:** `garuda-goldenway:v1.0`  

---

## 1. TWO-PHASE MEMORY HANDSHAKE PROTOCOL DESIGN

1. **Request Acceptance Phase (`request_accept`)**:
   - Condition: `request_accept = dmem_valid && dmem_ready`
   - Memory model latches payload: `pending_addr`, `pending_wen`, `pending_funct3`, `pending_wdata`.
   - `dmem_ready` drops to `0` immediately after acceptance during multi-cycle states.
   - Request counters (`read_tx_count`, `write_tx_count`) increment **EXACTLY ONCE**.

2. **Response Completion Phase (`response_complete`)**:
   - Condition: `response_complete = dmem_resp_valid && dmem_resp_ready`
   - Core asserts `dmem_resp_ready = dmem_resp_valid` when consuming valid response data.
   - Memory model holds `dmem_resp_valid = 1` and stable `dmem_rdata` until `dmem_resp_ready` is high.
   - Store commits to memory array **EXACTLY ONCE** (`committed_store_count`).
   - `resp_tx_count` increments **EXACTLY ONCE**.
   - FSM transitions back to `STATE_IDLE` and resets `dmem_ready = 1`.

---

## 2. TRANSACTION ACCOUNTING SUMMARY

For the baseline program (`single_hart_program.hex`):

- **Read Accepted Count (`read_tx_count`)**: `4` (LD, LW, LH, LB)
- **Write Accepted Count (`write_tx_count`)**: `4` (SD, SW, SH, SB)
- **Committed Store Count (`committed_store_count`)**: `4`
- **Total Responses Completed (`resp_tx_count`)**: `8` (`read_tx_count + write_tx_count`)
- **Duplicate Transactions (`duplicate_tx_count`)**: `0`
- **Outstanding Transactions at Halt**: `0`

---

## 3. ASSERTION VERIFICATION MATRIX

- **x0 Protection:** `PASS` (`x0 == 0`)
- **ALU & Register Assertions ($x1$–$x18$):** `PASS (100%)`
- **Data Memory Byte Verification (`dmem[0..24]`):** `PASS (100%)`
- **Transaction Accounting Assertions:** `PASS (100%)`
- **EBREAK WB Retirement:** `PASS`
- **Runner Exit Code:** `0`
