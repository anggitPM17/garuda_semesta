# GARUDA SEMESTA V12.1 — BASELINE HARDWARE & REPOSITORY AUDIT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Target Milestone:** V12.1 REAL RTL EXECUTION & VERIFICATION RECOVERY  
**Date:** November 2026  
**Status:** **AUDITED & PASSED**  

---

## 1. Executive Baseline Summary

This audit establishes the baseline engineering inventory for the **GARUDA SEMESTA v12.0 TITAN-TITANIUM** repository prior to executing the V12.1 real RTL hardware verification pipeline.

All 14 physical Verilog hardware modules, bus adapters, multi-level cache subsystems, and memory controllers have been identified, preserved, and verified.

---

## 2. Active Git Repository Status

- **Repository Path:** `D:/richat/garuda_semesta_repo` (`anggitPM17/garuda_semesta`)
- **Active Branch:** `main`
- **Latest Commit Hash:** `99cf0dd` (*Compiler-to-Silicon Vertical Slice*)
- **Docker Image:** `garuda-eda:v2.4.0`

---

## 3. Discovered RTL Module Inventory

| Module Name | Source Path | Subsystem | RTL Type | Compilation Status |
| :--- | :--- | :--- | :--- | :--- |
| `garuda_pc` | `src/cpu/garuda_pc.v` | CPU Core | Synthesizable Verilog-2012 | **PASS** |
| `garuda_idecode` | `src/cpu/garuda_idecode.v` | CPU Core | Synthesizable Verilog-2012 | **PASS** |
| `garuda_regfile` | `src/cpu/garuda_regfile.v` | CPU Core | Synthesizable Verilog-2012 | **PASS** |
| `garuda_alu` | `src/cpu/garuda_alu.v` | CPU Core | Synthesizable Verilog-2012 | **PASS** |
| `garuda_cpu_pipeline_top` | `src/cpu/garuda_cpu_pipeline_top.v` | CPU Core Top | Synthesizable Verilog-2012 | **PASS** |
| `garuda_bus_adapter_64to32` | `src/memory/garuda_bus_adapter_64to32.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_l1_icache` | `src/memory/garuda_l1_icache.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_l1_dcache` | `src/memory/garuda_l1_dcache.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_l2_cache` | `src/memory/garuda_l2_cache.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_memory_arbiter` | `src/memory/garuda_memory_arbiter.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_memory_controller` | `src/memory/garuda_memory_controller.v` | Memory Subsystem | Synthesizable Verilog-2012 | **PASS** |
| `garuda_memory_subsystem_top` | `src/memory/garuda_memory_subsystem_top.v` | Memory Subsystem Top | Synthesizable Verilog-2012 | **PASS** |
| `garuda_vertical_slice_top` | `src/integration/garuda_vertical_slice_top.v` | System Top Level | Synthesizable Verilog-2012 | **PASS** |
| `tb_garuda_vertical_slice_v24_6` | `src/integration/tb_garuda_vertical_slice_v24_6.v` | Verification Testbench | Testbench Verilog-2012 | **PASS** |

---

## 4. Verification Baseline Findings

1. **Pure Hardware Path:** Replaced Python emulators with real Verilog RTL execution via Icarus Verilog (`iverilog`) and VVP (`vvp`).
2. **True 64-bit Instruction Alignment:** Re-architected `garuda_bus_adapter_64to32.v` into a 4-state deterministic FSM fetching full 64-bit instruction words in twin 32-bit bursts without zero-extension truncation.
3. **Strict Memory Readback Assertion:** `tb_garuda_vertical_slice_v24_6.v` issues an independent DMA readback access to SRAM address `0x80000100` and asserts `captured_readback_val === 500`.
4. **Real Negative Exception Testing:** Injected invalid opcode `0xE` into a compiled program bitstream and verified that the CPU pipeline raises an `illegal_instruction` hardware exception.
