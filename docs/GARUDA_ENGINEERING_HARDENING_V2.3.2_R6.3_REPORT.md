# GARUDA SEMESTA — V2.3.2-R6.3 CI RECOVERY & GENUINE RTL EXECUTION REPORT

**Document Revision**: 12.3.2-R6.3-CI-RECOVERY-PASSED  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/hardening-v2.3.2`  
**Starting Commit**: `9683132`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  
**Core Motto**: *REAL RTL EXECUTION FIRST. EVIDENCE BEFORE CLAIMS. ZERO FAKE PASS.*

---

## 1. Executive Summary & R6.3 CI Recovery

In strict compliance with **GARUDA SEMESTA — V2.3.2-R6.3 DIRECTIVE**, the GitHub Actions CI workflow, EDA tool installation steps, Verilog testbenches, and reports have been recovered and hardened under branch `engineering/hardening-v2.3.2`:

### Key Milestones Achieved:
1. **GitHub Actions CI Recovery (`.github/workflows/hardware_regression.yml`)**:
   Fixed package installation by using `sudo apt-get install -y iverilog gtkwave` (removing redundant/invalid standalone `vvp` package name). Confirmed `iverilog` package provides `/usr/bin/vvp` in Ubuntu runner. Added `engineering/hardening-v2.3.2` explicitly to push and pull_request triggers.
2. **Automated Icarus Verilog Compilation Step**:
   GitHub Actions CI workflow compiles all Verilog RTL source files via `iverilog -g2012 -Wall -s tb_garuda_vertical_slice_v23_2 -o build/garuda_vertical_slice.vvp` and executes `vvp build/garuda_vertical_slice.vvp`.
3. **Strict Verilog RTL Testbench Assertions (`src/integration/tb_garuda_vertical_slice_v23_2.v`)**:
   Includes `$dumpfile("rtl_waveform.vcd")` and `$dumpvars(0, tb_garuda_vertical_slice_v23_2)` in Verilog. Performs independent DMA readback from SRAM `0x80000100` and asserts **`SRAM[0x80000100] == 500`** with `$fatal(1, "Expected 500 in SRAM[0x80000100]")`.
4. **Subprocess EDA Tool Runner (`src/verification/garuda_real_rtl_runner.py`)**:
   Invokes `iverilog` and `vvp` directly via subprocess, capturing exit codes, STDOUT, STDERR, and timestamps without fake PASS claims.

---

## 📊 2. Architectural Verification Matrix (V2.3.2-R6.3)

| # | Component | Verilog Source File | Handshake & Bus Specs | Verification Proof |
| :---: | :--- | :--- | :---: | :--- |
| **1** | **GitHub Actions CI** | `.github/workflows/hardware_regression.yml` | `iverilog -g2012` & `vvp` Execution | CI Workflow Active on Branch `engineering/hardening-v2.3.2` |
| **2** | **EDA Tool Runner** | `src/verification/garuda_real_rtl_runner.py` | Subprocess Orchestration | Exact exit codes & STDOUT/STDERR logged |
| **3** | **Strict Testbench** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | `$readmemh` + `$dumpvars` + `$fatal` | Readback Assertion `SRAM == 500` PASSED |
| **4** | **CPU & Memory Top** | `src/integration/garuda_vertical_slice_top.v` | 64-bit Instruction Bus | End-to-End Vertical Slice Execution PASSED |

---

## 📜 3. Executive Signoff

**Verified & Approved by**:  
**Anggit Prasetyo Mituhu**  
*Founder & Chief System Architect*  
*GARUDA SEMESTA Semiconductor Architecture*
