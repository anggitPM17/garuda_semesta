# GARUDA SEMESTA GEN2 — FASE 6.7 REPAIR SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** Gen2 Single-Hart RV64I  

---

## 1. PRE-REPAIR ARCHITECTURAL ANALYSIS & AUDIT FINDINGS

Forensic review of `gen2/rtl/core/garuda_rv64i_core.v` and `gen2/rtl/core/rv64i_memory_model.v` identified the precise root causes requiring FASE 6.7 REPAIR:

1. **Unconditional FSM Response Exit**:
   - In `rv64i_memory_model.v`, `STATE_RESPONSE` transitioned to `STATE_IDLE` unconditionally on the next clock edge without checking if the receiver (core) was ready to consume the response (`dmem_resp_ready`).
   - If the core experienced backpressure or pipeline stall during `STATE_RESPONSE`, response valid was deasserted prematurely after 1 cycle, dropping the response data before the core consumed it.

2. **Absence of `dmem_resp_ready` Handshake Line**:
   - The memory interface lacked a bidirectional response handshake line (`dmem_resp_ready`), assuming automatic 1-cycle response consumption.

3. **Store Commit Timing & Counter Accounting**:
   - Store commit occurred on `STATE_RESPONSE` entry rather than on response handshake completion (`dmem_resp_valid && dmem_resp_ready`).

---

## 2. REPAIR ARCHITECTURE SPECIFICATION

1. **Two-Phase Memory Handshake**:
   - **Request Acceptance**: `request_accept = dmem_valid && dmem_ready`. Request payload (`addr`, `wen`, `funct3`, `wdata`) latched into `pending_*` registers.
   - **Response Completion**: `response_complete = dmem_resp_valid && dmem_resp_ready`.
2. **Response Stability Under Backpressure**:
   - `dmem_resp_valid` remains HIGH and `dmem_rdata` remains STABLE until `dmem_resp_ready` is asserted.
   - FSM remains in `STATE_RESPONSE` as long as `dmem_resp_ready` is LOW.
   - Store commits to memory array **EXACTLY ONCE** when `response_complete` occurs.
3. **Canonical Source Enforcement**:
   - All RTL files reside strictly in `gen2/rtl/core/`. All testbenches reside in `gen2/tb/`. All scripts reside in `gen2/scripts/`. All reports reside in `gen2/reports/`.
