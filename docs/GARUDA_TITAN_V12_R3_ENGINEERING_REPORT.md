# GARUDA SEMESTA — TITAN V12-R3 MASTER ENGINEERING REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Milestone:** TITAN V12-R3 REAL RTL STORE-TO-SRAM RECOVERY & VERIFICATION HARDENING  
**Status:** **PASSED (100% REAL RTL VERILOG SIMULATION & DMA SRAM ASSERTION VERIFIED)**  

---

## 1. Executive Summary

The **GARUDA SEMESTA TITAN V12-R3** hardware verification and store-to-SRAM recovery milestone has been successfully completed.

All physical Verilog RTL modules—spanning the 5-stage CPU pipeline, 64-bit ALU, 32x64-bit Register File, L1 Instruction Cache, L1 Data Cache, 4-Way L2 Cache, Bus Adapter, Multi-Master Arbiter, and SRAM Memory Controller—were compiled and executed through real Icarus Verilog (`iverilog`) and VVP simulation inside the Docker EDA workstation (`garuda-eda:v2.4.0`).

---

## 2. Root Cause Fixes Implemented

1. **STORE-to-SRAM Memory Fabric Path:**
   - Fixed `garuda_bus_adapter_64to32.v` FSM handshake (`ST_READ_L` $\rightarrow$ `ST_READ_H` $\rightarrow$ `ST_DONE`).
   - Fixed `garuda_l1_dcache.v` hybrid combinational & latched memory assignments so store address `0x80000100` and write value `500` reach `main_sram[64]`.
   - Fixed `garuda_l2_cache.v` zero-lag handshake (`l2_done <= 0` in `ST_IDLE`).
   - Fixed `garuda_cpu_pipeline_top.v` `dcache_done` latching preventing memory re-trigger loops.

2. **Negative Test Exception Verification:**
   - Isolated negative test execution using `build/neg_program.hex`.
   - Verified that invalid opcode `0xE` explicitly triggers the `illegal_instruction` hardware signal.

3. **Master Control Script:**
   - Created `scripts/garuda_v12_1_r3.sh` supporting all verification tasks.

---

## 3. Real RTL Simulation Trace Evidence

```text
=========================================================================
GARUDA SEMESTA — VERTICAL SLICE VERILOG RTL TESTBENCH v12.4.6
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================\n
[STAGE 1] Reset Released. 5-Stage CPU Fetching Compiled Instructions...
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[STAGE 2] Clock Cycles Executed: CPU HALTED at PC = 0x80000030
[STAGE 3] Performing Independent DMA Readback from SRAM 0x80000100...
[SRAM CONTROLLER LOG] READ addr=0x80000100, word_idx=   64, data=       500
[STAGE 4] Strict Assertion: Asserting SRAM[0x80000100] == 500...
PASS: REAL RTL SRAM READBACK VERIFIED (SRAM[0x80000100] == 500)
```

---

## 4. How to Execute

```bash
# Execute TITAN V12-R3 Master Script
bash scripts/garuda_v12_1_r3.sh environment
bash scripts/garuda_v12_1_r3.sh compile
bash scripts/garuda_v12_1_r3.sh simulate

# Push changes to GitHub
git push origin main
```
