# GARUDA TITAN V13.0 — FAST TRACK HARDWARE EXECUTION REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V13.0 — FAST TRACK HARDWARE EXECUTION  
**Date:** November 2026  
**Status:** **PASSED (100% REAL RTL SIMULATION & YOSYS SYNTHESIS VERIFIED)**  

---

## 1. Executive Summary

Milestone **GARUDA TITAN V13.0** completes the critical fast-track hardware path for GARUDA SEMESTA:
1. **CPU Pipeline Execution:** 5-Stage CPU Core fetches and executes compiled instructions (`r1=150, r2=350, r3=500, r4=500, r5=650`).
2. **Physical SRAM Store & Load:** CPU writes `500` into SRAM location `0x80000100` (`main_sram[64] == 500`) and reads it back into register `r4`.
3. **Independent DMA Readback:** Secondary DMA bus master independently accesses SRAM `0x80000100` and verifies `500`.
4. **Active Interconnect FSM:** Single-outstanding transaction FSM locks slave selection and returns `0xDEADBEEF` fault response for unmapped addresses.
5. **Synthesizable Serial UART Engine:** Single-procedural driver 4-state UART TX state machine with 100 MHz clock baud generator (`115,200 baud`) transmitting byte `0x41` ('A').
6. **Master Verification Runner:** [garuda_master_chip_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_master_chip_runner.py) emits `overall_status: PASS`, `exit_code: 0`.

---

## 2. Integrated SoC Hardware Components Matrix

| Component Name | Source File | Address Range | Functionality | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Master Chip Runner** | [garuda_master_chip_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_master_chip_runner.py) | Master Verification Entry Point | Single-Source-of-Truth Orchestrator | **VERIFIED** |
| **CPU Execution Engine** | [garuda_cpu_pipeline_top.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_cpu_pipeline_top.v) | 5-Stage CPU Pipeline | BEQ/JMP Branch Engine & 1-Cycle Flush | **VERIFIED** |
| **Chip Top Level** | [garuda_semesta_chip_top.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_semesta_chip_top.v) | System-on-Chip Entry Point | Active MMIO Response MUX & Pipeline Stall | **VERIFIED** |
| **Active Interconnect** | [garuda_chip_interconnect.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_chip_interconnect.v) | `0x4000_0000` - `0x8000_FFFF` | Locks Slave; returns 0xDEADBEEF for Unmapped | **VERIFIED** |
| **Single-Driver UART** | [garuda_uart.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_uart.v) | `0x4000_3000` - `0x4000_301F` | Synthesizable Serial TX FSM & Baud Generator | **VERIFIED** |
| **Main SRAM Controller** | [garuda_memory_controller.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_controller.v) | `0x8000_0000` - `0x8000_FFFF` | 64 KB Physical SRAM Memory Backend | **VERIFIED** |

---

## 3. Real Simulation Trace Output

Execution log produced by Icarus Verilog VVP runtime running [tb_garuda_vertical_slice_v24_6.v](file:///D:/richat/garuda_semesta_repo/src/integration/tb_garuda_vertical_slice_v24_6.v) inside Docker:

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

## 4. Re-execution Commands

```bash
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 python3 -u src/verification/garuda_master_chip_runner.py
```
