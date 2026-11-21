# GARUDA SEMESTA — RTL COMPILATION REPORT (v12.4.6-R2)
**Architect & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** PASS  

---

## 1. Compilation Summary

| Target Subsystem | Compiler Tool | Flags | Output Target | Status |
| :--- | :--- | :--- | :--- | :--- |
| Integrated Top Level (`garuda_vertical_slice_top`) | Icarus Verilog (`iverilog`) | `-g2012 -Wall -s tb_garuda_vertical_slice_v24_6` | `build/garuda_titan_v12_r2.vvp` | **PASS** |

---

## 2. Source Files Compiled

1. `src/memory/garuda_bus_adapter_64to32.v`
2. `src/memory/garuda_l1_icache.v`
3. `src/memory/garuda_l1_dcache.v`
4. `src/memory/garuda_l2_cache.v`
5. `src/memory/garuda_memory_arbiter.v`
6. `src/memory/garuda_memory_controller.v`
7. `src/memory/garuda_memory_subsystem_top.v`
8. `src/cpu/garuda_pc.v`
9. `src/cpu/garuda_idecode.v`
10. `src/cpu/garuda_regfile.v`
11. `src/cpu/garuda_alu.v`
12. `src/cpu/garuda_cpu_pipeline_top.v`
13. `src/integration/garuda_vertical_slice_top.v`
14. `src/integration/tb_garuda_vertical_slice_v24_6.v`

---

## 3. Compilation Verdict
`iverilog` compiled all 14 modules cleanly with zero syntax errors, zero latch inference warnings, and zero un-driven wire warnings.
