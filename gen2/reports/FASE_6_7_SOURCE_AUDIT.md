# GARUDA SEMESTA GEN2 — FASE 6.7 INITIAL SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. PRE-FASE 6.7 HANDSHAKE AUDIT FINDINGS

Prior audit of the memory interface and core stall logic identified the root causes for multi-cycle latency timeouts:

1. **Conflicting Stall Condition in Core (`garuda_rv64i_core.v`)**:
   - Core evaluated: `dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && (!dmem_ready || !dmem_resp_valid)`.
   - `dmem_ready` is active during `STATE_IDLE`. `dmem_resp_valid` is active during `STATE_RESPONSE`.
   - Since both signals are mutually exclusive in multi-cycle states, `(!dmem_ready || !dmem_resp_valid)` was ALWAYS true during transaction wait states, preventing proper pipeline release.

2. **Missing Explicit Response Acceptance (`dmem_resp_ready`)**:
   - `rv64i_memory_model.v` lacked a `dmem_resp_ready` consumption signal from the core.
   - Returning to `STATE_IDLE` on the cycle immediately following `STATE_RESPONSE` caused `dmem_ready = 1` while `dmem_valid` from the EX/MEM stage was still high for the active instruction, causing duplicate transaction acceptances.

3. **IMEM Response Driver**:
   - `imem_resp_valid` had combinational and sequential assignments across different blocks.

---

## 2. RE-ARCHITECTURE PLAN FOR FASE 6.7

1. **Add `dmem_resp_ready` Interface**:
   - Core asserts `dmem_resp_ready` when it consumes a valid response in MEM stage.
   - Memory model holds `dmem_resp_valid` and stable `dmem_rdata` until `dmem_resp_valid && dmem_resp_ready` completes the transaction.
2. **Explicit Two-Phase Handshake**:
   - Request Acceptance: `dmem_valid && dmem_ready`. Payload (`addr`, `wen`, `funct3`, `wdata`) latched.
   - Response Completion: `dmem_resp_valid && dmem_resp_ready`.
3. **Transaction Accounting**:
   - `read_tx_count`: Increment on read acceptance.
   - `write_tx_count`: Increment on write acceptance.
   - `committed_store_count`: Increment on store commit.
   - `resp_tx_count`: Increment on response completion.
   - Scoreboard check: `read_tx_count == 4`, `write_tx_count == 4`, `resp_tx_count == 8`, `committed_store_count == 4`, `duplicate_tx_count == 0`.
