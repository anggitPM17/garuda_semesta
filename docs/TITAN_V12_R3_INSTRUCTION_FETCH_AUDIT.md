# GARUDA SEMESTA — TITAN V12-R3 INSTRUCTION FETCH & WIDTH AUDIT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** **PASSED & VERIFIED**  

---

## 1. Executive Summary

This document verifies the 64-bit GARUDA ISA instruction fetch pipeline and alignment over the 32-bit L2 memory subsystem.

---

## 2. Bus Alignment & Instruction Fetch Architecture

- **ISA Format:** Full 64-bit instruction words (`inst_word[63:0]`).
- **Memory Bus Width:** 32-bit data interface (`DATA_WIDTH = 32`).
- **Bus Adapter (`garuda_bus_adapter_64to32.v`):** Fetches 64-bit instructions in twin 32-bit burst reads:
  - Burst Read #1: Address `addr + 0` (Lower 32 bits).
  - Burst Read #2: Address `addr + 4` (Upper 32 bits).
  - Assembly: Assembles `{upper_32, lower_32}` into the complete 64-bit instruction word for `garuda_l1_icache.v`.

---

## 3. Verification Trace
1. `garuda_compiler.py` emits `program.hex` containing twin 32-bit hex lines per instruction.
2. `garuda_memory_controller.v` loads `program.hex` into `main_sram`.
3. `garuda_cpu_pipeline_top.v` fetches instructions through I-Cache and decoder (`garuda_idecode.v`).
4. Pipeline executes `MOV r1, 150`, `MOV r2, 350`, `ADD r3, r1, r2`, `STORE r3, [r0 + 0x80000100]`, `HALT` with zero instruction truncation or format mismatch.
