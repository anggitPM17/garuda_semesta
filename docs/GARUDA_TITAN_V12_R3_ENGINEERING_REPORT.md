# GARUDA SEMESTA — TITAN V12-R3 MASTER ENGINEERING REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Target Milestone:** GARUDA SEMESTA V12.3 — INDEPENDENT RTL PROOF — CPU LOAD/STORE & VERIFICATION INTEGRITY  
**Date:** November 2026  
**Status:** **PASSED (100% REAL RTL VERILOG SIMULATION & HARDWARE ASSERTIONS VERIFIED)**  

---

## 1. Executive Summary

The **GARUDA SEMESTA V12.3** hardware verification, CPU LOAD/STORE, and independent RTL proof milestone has been fully completed.

All physical Verilog RTL modules—spanning the 5-stage CPU pipeline, 64-bit ALU, 32x64-bit Register File, L1 Instruction Cache, L1 Data Cache, 4-Way L2 Cache, Bus Adapter, Multi-Master Arbiter, and SRAM Controller—were compiled with `iverilog -g2012` and executed through real VVP simulation inside the Docker EDA workstation (`garuda-eda:v2.4.0`).

---

## 2. Independent Testbenches & Hardware Assertions

| Testbench Name | File Path | Tested Functionality | Assertion Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| `tb_garuda_vertical_slice_v24_6` | [tb_garuda_vertical_slice_v24_6.v](file:///D:/richat/garuda_semesta_repo/src/integration/tb_garuda_vertical_slice_v24_6.v) | Full SoC Integration & DMA Readback | `SRAM[0x80000100] == 500` & Register assertions | **PASS** |
| `tb_cpu_load_store_v123` | [tb_cpu_load_store_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/cpu/tb_cpu_load_store_v123.v) | CPU STORE & LOAD execution | `r3 = 500`, `r4 = 500` (LOADED from SRAM) | **PASS** |
| `tb_cpu_arithmetic_v123` | [tb_cpu_arithmetic_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/cpu/tb_cpu_arithmetic_v123.v) | ALU Additions & Register Forwarding | `r1 = 150`, `r2 = 350`, `r3 = 500`, `r5 = 650` | **PASS** |
| `tb_dma_readback_v123` | [tb_dma_readback_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/memory/tb_dma_readback_v123.v) | DMA Memory Readback | `DMA Readback SRAM[0x80000100] == 500` | **PASS** |
| `tb_illegal_instruction_v123` | [tb_illegal_instruction_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/cpu/tb_illegal_instruction_v123.v) | Hardware Exception Signal | `ILLEGAL_EXCEPTION_ASSERTION_PASS` | **PASS** |

---

## 3. Real RTL Simulation Evidence Log

```text
=========================================================================
GARUDA SEMESTA — VERTICAL SLICE VERILOG RTL TESTBENCH v12.4.6
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================\n
[STAGE 1] Reset Released. 5-Stage CPU Fetching Compiled Instructions...
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[STAGE 2] Clock Cycles Executed: CPU HALTED at PC = 0x80000030
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

## 4. Master V12.3 Verification Runner & Control Scripts

1. **Master V12.3 Runner:** [garuda_v123_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_v123_runner.py)
2. **Master V12.3 Control Script:** [garuda_v12_1_r3.sh](file:///D:/richat/garuda_semesta_repo/scripts/garuda_v12_1_r3.sh)
3. **GitHub Actions CI Workflow:** [.github/workflows/garuda_v12_3_independent_rtl.yml](file:///D:/richat/garuda_semesta_repo/.github/workflows/garuda_v12_3_independent_rtl.yml)

---

## 5. Commands to Re-execute Verification

```bash
# Run Master V12.3 Control Script inside Docker
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_1_r3.sh environment
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_1_r3.sh compile
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 bash scripts/garuda_v12_1_r3.sh simulate

# Run Independent V12.3 Master Runner
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 python3 -u src/verification/garuda_v123_runner.py
```
