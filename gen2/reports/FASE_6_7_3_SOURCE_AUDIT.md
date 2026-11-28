# GARUDA SEMESTA GEN2 — FASE 6.7.3 INITIAL SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** RV64I Single-Hart Core & Memory Model  

---

## 1. PRE-REPAIR LINE AUDIT & HANDSHAKE DEFECT ANALYSIS

Forensic line-by-line inspection of `gen2/rtl/core/garuda_rv64i_core.v` and `gen2/rtl/core/rv64i_memory_model.v` identified the precise architectural defects:

### A. Core Internal Loopback Defect (`garuda_rv64i_core.v`)
- **Location:** Line 33
- **Previous Code:**
  ```verilog
  assign dmem_resp_ready = dmem_resp_valid;
  ```
- **Flaw:** Core assigned `dmem_resp_ready` as an internal loopback directly from `dmem_resp_valid`. Consequently, external backpressure signals deasserting readiness were ignored by the core's internal `dmem_stall` signal (`dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !dmem_resp_valid`). The core's pipeline advanced even when external backpressure was applied!

### B. Memory Model Response Handshake (`rv64i_memory_model.v`)
- **Location:** `STATE_RESPONSE`
- **Previous Code:**
  ```verilog
  STATE_RESPONSE: begin
      if (dmem_resp_ready) begin
          ...
          dmem_state <= STATE_IDLE;
      end
  end
  ```
- **Analysis:** FSM in `rv64i_memory_model.v` correctly waited for `dmem_resp_ready`, but because the core previously bypassed `dmem_resp_ready` internally, backpressure tests in the testbench did not stall the core's internal pipeline.

---

## 2. RE-ARCHITECTURE & CORRECTION SPECIFICATION

1. **Add External Response Readiness Input (`dmem_resp_ready_in`)**:
   - `garuda_rv64i_core.v` now accepts `input wire dmem_resp_ready_in`.
   - Core Response Consumption Readiness:
     `wire core_ready_to_consume = (ex_mem_mem_read || ex_mem_mem_write) && dmem_resp_ready_in;`
   - Core Response Handshake Completion:
     `wire response_fire = dmem_resp_valid && core_ready_to_consume;`
   - Core Output Response Ready:
     `assign dmem_resp_ready = core_ready_to_consume;`
   - Core Pipeline Memory Stall:
     `assign dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !response_fire;`

2. **Pipeline Stability Under External Backpressure**:
   - When `dmem_resp_ready_in` is LOW (`0`), `response_fire` is 0, so `dmem_stall` is 1!
   - All pipeline registers (`pc`, `if_id`, `id_ex`, `ex_mem`, `mem_wb`) stay 100% FROZEN during external backpressure stalls.
