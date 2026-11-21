# GARUDA SEMESTA — AUTOMATED RTL REGRESSION REPORT (v12.4.6-R2)
**Architect & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** PASS  

---

## 1. Regression Suite Results

| Test Suite / Stage | Execution Command | Result | Details |
| :--- | :--- | :--- | :--- |
| **Compiler Pipeline** | `python3 src/verification/garuda_compiler_pipeline.py` | **PASS** | Compiled 5 instructions -> `program.hex` |
| **RTL Compilation** | `iverilog -g2012 -Wall ...` | **PASS** | 14 Verilog modules compiled with 0 errors |
| **RTL Simulation & SRAM Assertion** | `vvp build/garuda_titan_v12_r2.vvp` | **PASS** | SRAM[0x80000100] == 500 Verified |
| **Real Negative Exception Test** | Opcode `0xE` Injection | **PASS** | Exception caught and rejected by DUT |
| **Verilator Linting** | `verilator --lint-only` | **SKIPPED** | Verilator not installed in host image |
| **Yosys Logic Synthesis** | `yosys -p "synth"` | **SKIPPED** | Yosys not installed in host image |

---

## 2. Regression Status Classification
- **Mandatory Stages Passed:** 4/4 (**PASS**)
- **Optional Stages Skipped:** 2/2 (**SKIPPED**)
- **Overall Regression Status:** **PASS**
