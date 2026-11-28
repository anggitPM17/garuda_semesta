# GARUDA SEMESTA GEN2 — FASE 6.7.2 INITIAL SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** RV64I Single-Hart Core & Memory Model  

---

## 1. LINE-BY-LINE SOURCE AUDIT & DEFECT IDENTIFICATION

Forensic inspection of `gen2/rtl/core/garuda_rv64i_core.v` and `gen2/rtl/core/rv64i_memory_model.v` identified the exact lines responsible for protocol and handshake limitations:

### A. Core Response Ready Assignment (`garuda_rv64i_core.v`)
- **Location:** Line 33
- **Previous Code:**
  ```verilog
  assign dmem_resp_ready = dmem_resp_valid;
  ```
- **Flaw:** Loopback assignment derived `dmem_resp_ready` directly from `dmem_resp_valid` inside the core, preventing external testbench or interconnect backpressure signals from independently deasserting response readiness when the receiver was stalled.

### B. Memory Model Response Handshake Condition (`rv64i_memory_model.v`)
- **Location:** Lines 201-203
- **Previous Code:**
  ```verilog
  STATE_RESPONSE: begin
      dmem_state <= STATE_IDLE;
  end
  ```
- **Flaw:** FSM transitioned from `STATE_RESPONSE` to `STATE_IDLE` after 1 cycle unconditionally, without verifying that response completion handshake `dmem_resp_valid && dmem_resp_ready` was active.

### C. Core Memory Stall Condition (`garuda_rv64i_core.v`)
- **Location:** Line 37
- **Previous Code:**
  ```verilog
  wire dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !dmem_resp_valid;
  ```
- **Correction Required:** Stall condition must be tied directly to response handshake completion:
  ```verilog
  wire dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !(dmem_resp_valid && dmem_resp_ready);
  ```

---

## 2. CANONICAL FILE AUDIT MATRIX

| Module File Path | Responsibility | Audit Result | Action |
| :--- | :--- | :--- | :--- |
| `gen2/rtl/core/garuda_rv64i_core.v` | Core top & pipeline control | Missing explicit `response_fire` stall condition | **REPAIRED** |
| `gen2/rtl/core/rv64i_memory_model.v` | Memory FSM & transaction model | FSM exited RESPONSE without handshake check | **REPAIRED** |
| `gen2/rtl/core/rv64i_ex_mem_reg.v` | EX/MEM pipeline register | Payload hold during stall verified | **VERIFIED** |
| `gen2/rtl/core/rv64i_mem_wb_reg.v` | MEM/WB pipeline register | Payload hold during stall verified | **VERIFIED** |
| `gen2/tb/garuda_rv64i_core_tb.v` | Verification testbench | Add 1, 2, 4, 8-cycle backpressure test harness | **ENHANCED** |
| `gen2/scripts/run_latency_tests.py` | Multi-latency regression runner | Verifies 0, 1, 3, 5 latencies & backpressure | **ENHANCED** |
