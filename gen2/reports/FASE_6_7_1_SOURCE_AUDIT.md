# GARUDA SEMESTA GEN2 — FASE 6.7.1 SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** RV64I Single-Hart Core & Memory Model  

---

## 1. PRE-REPAIR LINE AUDIT & FINDINGS

Line-by-line audit of `gen2/rtl/core/rv64i_memory_model.v` and `gen2/rtl/core/garuda_rv64i_core.v` revealed two critical handshake defects:

### A. Memory FSM Response Exit Defect (`rv64i_memory_model.v`)
- **Location:** `STATE_RESPONSE` transition block.
- **Previous Code:**
  ```verilog
  STATE_RESPONSE: begin
      dmem_resp_valid <= 1'b0;
      dmem_state      <= STATE_IDLE;
  end
  ```
- **Flaw:** Transitioned out of `STATE_RESPONSE` back to `STATE_IDLE` after 1 cycle unconditionally, without waiting for the receiver (core) to assert `dmem_resp_ready`. If the core held pipeline stall during `STATE_RESPONSE`, response valid was deasserted prematurely.

### B. Store Commit Timing Defect
- **Previous Code:**
  ```verilog
  if (pending_wen) begin
      committed_store_count <= committed_store_count + 1'b1;
      case (pending_funct3[1:0]) ...
  ```
- **Flaw:** Committed store to array upon `STATE_RESPONSE` entry rather than waiting for `dmem_resp_valid && dmem_resp_ready` (response completion handshake).

---

## 2. RE-ARCHITECTURE & CORRECTION SPECIFICATION

1. **Strict Response Handshake (`STATE_RESPONSE`)**:
   - `dmem_resp_valid = (dmem_state == STATE_RESPONSE)`
   - FSM MUST stay in `STATE_RESPONSE` until `dmem_resp_ready` is asserted!
   - Transition to `STATE_IDLE` occurs ONLY when `dmem_resp_valid && dmem_resp_ready` is TRUE.
2. **Exactly-Once Store Commit**:
   - Store commits to memory array and `committed_store_count` increments **EXACTLY ONCE** upon `dmem_resp_valid && dmem_resp_ready`.
3. **Core Handshake Signals (`garuda_rv64i_core.v`)**:
   - `dmem_resp_ready = (ex_mem_mem_read || ex_mem_mem_write) && dmem_resp_valid`.
   - `dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !(dmem_resp_valid && dmem_resp_ready)`.
