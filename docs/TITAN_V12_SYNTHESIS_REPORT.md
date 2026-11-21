# GARUDA SEMESTA — TITAN V12 SYNTHESIS & STRUCTURAL AUDIT REPORT

**Document Revision**: 12.0-SYNTHESIS-AUDIT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/titan-v12-real-chip-integration`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Yosys & Verilator Integration Status

- **Verilator Linting**: Supported via `verilator --lint-only -Wall --top-module garuda_vertical_slice_top`.
- **Yosys Synthesis**: Supported via `yosys -p "read_verilog ...; hierarchy -top garuda_vertical_slice_top; proc; opt; check"`.
- **Target Technology**: SkyWater 130nm PDK (`sky130_fd_sc_hd`).

---

## 2. Gate-Level Hierarchy Breakdown (`garuda_vertical_slice_top`)

```text
=========================================================================
YOSYS TOP-LEVEL HIERARCHY SUMMARY: garuda_vertical_slice_top
=========================================================================
- u_cpu (garuda_cpu_pipeline_top)
  - u_pc (garuda_pc)
  - u_decoder (garuda_idecode)
  - u_regfile (garuda_regfile) [32 x 64-bit Registers]
  - u_alu (garuda_alu) [64-bit Adder/Subtractor/Logic Unit]
- u_memory_subsystem (garuda_memory_subsystem_top)
  - u_icache (garuda_l1_icache)
  - u_icache_adapter (garuda_bus_adapter_64to32)
  - u_dcache (garuda_l1_dcache)
  - u_l2_cache (garuda_l2_cache)
  - u_arbiter (garuda_memory_arbiter)
  - u_mem_controller (garuda_memory_controller) [64KB SRAM Model]
=========================================================================
```
