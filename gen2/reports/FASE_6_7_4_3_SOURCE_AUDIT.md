# GARUDA SEMESTA GEN2 — FASE 6.7.4.3 SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Target:** RV64I Single-Hart Core & Memory Model  

---

## 1. PRE-REPAIR LINE AUDIT & HANDSHAKE CONTRACT DEFECT ANALYSIS

Forensic line-by-line inspection of `gen2/rtl/core/garuda_rv64i_core.v` and `gen2/rtl/core/rv64i_memory_model.v` identified the precise handshake contract defect:

### A. Handshake Contract Disconnect (`garuda_rv64i_core.v`)
- **Location:** Lines 33-37
- **Previous Code:**
  ```verilog
  assign dmem_resp_ready = (ex_mem_mem_read || ex_mem_mem_write);
  wire response_fire     = dmem_resp_valid && dmem_resp_ready_in;
  wire dmem_stall        = (ex_mem_mem_read || ex_mem_mem_write) && !response_fire;
  ```
- **Flaw:** Core outputted `dmem_resp_ready` to memory model WITHOUT factoring in `dmem_resp_ready_in` (the external backpressure mask). As a result, memory model saw `dmem_resp_ready = 1` while testbench applied backpressure (`dmem_resp_ready_in = 0`).

### B. Unified Handshake Correction (`garuda_rv64i_core.v`)
- **Correction:**
  ```verilog
  assign dmem_resp_ready = (ex_mem_mem_read || ex_mem_mem_write) && dmem_resp_ready_in;
  wire response_fire     = dmem_resp_valid && dmem_resp_ready;
  wire dmem_stall        = (ex_mem_mem_read || ex_mem_mem_write) && !response_fire;
  ```
- **Benefit:** `dmem_resp_ready` outputted by the core to memory model now incorporates `dmem_resp_ready_in` (external backpressure). Both Core and Memory Model observe the EXACT SAME handshake completion signal `response_fire = dmem_resp_valid && dmem_resp_ready`.

---

## 2. CANONICAL FILE AUDIT MATRIX

| Module File Path | Responsibility | Audit Result | Action |
| :--- | :--- | :--- | :--- |
| `gen2/rtl/core/garuda_rv64i_core.v` | Core top & pipeline control | Unified `dmem_resp_ready` with `dmem_resp_ready_in` | **REPAIRED** |
| `gen2/rtl/core/rv64i_memory_model.v` | Memory FSM & transaction model | Verified wait-for-handshake FSM & `tx_committed` | **VERIFIED** |
| `gen2/tb/garuda_rv64i_core_tb.v` | Verification testbench | Stability monitor & per-transaction backpressure | **ENHANCED** |
| `gen2/tests/run_negative_tests.py` | Negative test runner | Fault-injected Verilog simulation fixtures (6/6) | **RE-ENGINEERED** |
| `gen2/scripts/run_latency_tests.py` | Multi-latency regression runner | Dynamic stdout JSON parser for scoreboard metrics | **ENHANCED** |
