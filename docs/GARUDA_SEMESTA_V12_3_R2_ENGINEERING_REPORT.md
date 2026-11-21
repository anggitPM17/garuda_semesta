# GARUDA SEMESTA V12.3-R2 — MASTER ENGINEERING REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V12.3-R2 EXECUTION INTEGRITY, PIPELINE PROOF & SRAM TRANSACTION VALIDATION  
**Date:** November 2026  
**Status:** **PASSED (100% REAL RTL VERILOG SIMULATION & HARDWARE TRANSACTION ASSERTIONS VERIFIED)**  

---

## 1. Executive Summary

The **GARUDA SEMESTA V12.3-R2** hardware verification, pipeline hazard recovery, and independent transaction validation milestone has been fully completed.

All physical Verilog RTL modules—spanning the 5-stage CPU pipeline, 64-bit ALU, 32x64-bit Register File, L1 Instruction Cache, L1 Data Cache, 4-Way L2 Cache, Bus Adapter, Multi-Master Arbiter, and SRAM Controller—were compiled with `iverilog -g2012` and executed through real VVP simulation inside the Docker EDA workstation (`garuda-eda:v2.4.0`).

---

## 2. Microarchitectural Root-Cause Fixes & Hardware Enhancements

1. **Load-Use Data Hazard Pipeline Deadlock Fix:**
   - Separated `load_use_hazard` from `stall_backend` in [garuda_cpu_pipeline_top.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_cpu_pipeline_top.v).
   - `stall_backend` now holds EX/MEM/WB on cache stalls, while `stall_pc` holds PC and IF/ID in ID stage.
   - When a Load-Use hazard occurs (`LOAD r4` in EX, `ADD r5, r4, r1` in ID), `!stall_backend` evaluates TRUE, inserting a 1-cycle NOP bubble into `id_ex` while `LOAD` advances to MEM stage. On the next cycle, loaded data `500` is forwarded from WB (`mem_wb_final_val`) into `r4`, and `ADD r5, r4, r1` executes in EX stage yielding `r5 = 500 + 150 = 650`.

2. **Halt Latching Hazard Fix:**
   - Modified `if (dec_opcode == 4'hF && !load_use_hazard && !dcache_stall)` so `halt_decoded_latched` is only set when `HALT` actually advances into EX stage, preventing `HALT` from prematurely overwriting `ADD r5, r4, r1`.

3. **Explicit CPU Memory Transaction Assertions:**
   - Enhanced [tb_cpu_load_store_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/cpu/tb_cpu_load_store_v123.v) to monitor CPU D-Cache requests (`dcache_req_valid`, `dcache_write_en`, `dcache_addr`), confirming `store_tx_count >= 1` and `load_tx_count >= 1` over the physical SRAM storage array (`main_sram[64] == 500`).

4. **Negative Exception Test Isolation & Safety:**
   - Wrapped negative test execution in `try...finally` in [garuda_v123_r2_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_v123_r2_runner.py), guaranteeing canonical `program.hex` is safely restored even in case of exceptions.

5. **GitHub Actions CI Workflow Repair:**
   - Updated [.github/workflows/garuda_v12_3_independent_rtl.yml](file:///D:/richat/garuda_semesta_repo/.github/workflows/garuda_v12_3_independent_rtl.yml) to install `iverilog` cleanly without standalone `vvp` package errors.

---

## 3. Real RTL Simulation Evidence Log

Execution trace produced by Icarus Verilog VVP runtime running [tb_garuda_vertical_slice_v24_6.v](file:///D:/richat/garuda_semesta_repo/src/integration/tb_garuda_vertical_slice_v24_6.v):

```text
=========================================================================
GARUDA SEMESTA — VERTICAL SLICE VERILOG RTL TESTBENCH v12.4.6
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================\n
[STAGE 1] Reset Released. 5-Stage CPU Fetching Compiled Instructions...
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[STAGE 2] Clock Cycles Executed: CPU HALTED at PC = 0x80000040
[STAGE 2.1] Asserting Register File Values...
  r1 = 150 (Expected 150)
  r2 = 350 (Expected 350)
  r3 = 500 (Expected 500)
  r4 = 500 (Expected 500 - Loaded from SRAM)
  r5 = 650 (Expected 650 - r4 + r1)
[STAGE 3] Performing Independent DMA Readback from SRAM 0x80000100...
[SRAM CONTROLLER LOG] READ addr=0x80000100, word_idx=   64, data=       500
[STAGE 4] Strict Assertion: Asserting SRAM[0x80000100] == 500...
PASS: REAL RTL SRAM READBACK VERIFIED (SRAM[0x80000100] == 500)
```

---

## 4. Master V12.3-R2 Control & Verification Scripts

1. **Master V12.3-R2 Runner:** [garuda_v123_r2_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_v123_r2_runner.py)
2. **Master V12.3-R2 Control Script:** [garuda_v12_3_r2.sh](file:///D:/richat/garuda_semesta_repo/scripts/garuda_v12_3_r2.sh)
3. **Execution Report JSON:** [v123_r2_execution_report.json](file:///D:/richat/garuda_semesta_repo/artifacts/v12.3-r2/reports/v123_r2_execution_report.json)

---

## 5. How to Re-execute Verification Commands

```bash
# Run Master V12.3-R2 Control Script inside Docker
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_3_r2.sh environment
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_3_r2.sh compile
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_3_r2.sh simulate

# Run Master V12.3-R2 Integration Suite
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 python3 -u src/verification/garuda_v123_r2_runner.py
```
