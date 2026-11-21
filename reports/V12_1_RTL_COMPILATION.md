# GARUDA SEMESTA V12.1 — RTL COMPILATION REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Compiler:** Icarus Verilog (`iverilog`) v11.0  
**Flags:** `-g2012 -Wall -s tb_garuda_vertical_slice_v24_6`  
**Status:** **PASS (0 Errors, 0 Warnings)**  

---

## 1. Compiled Hardware Modules

```bash
iverilog -g2012 -Wall -s tb_garuda_vertical_slice_v24_6 -o build/garuda_titan_v12_r2.vvp \
  src/memory/garuda_bus_adapter_64to32.v \
  src/memory/garuda_l1_icache.v \
  src/memory/garuda_l1_dcache.v \
  src/memory/garuda_l2_cache.v \
  src/memory/garuda_memory_arbiter.v \
  src/memory/garuda_memory_controller.v \
  src/memory/garuda_memory_subsystem_top.v \
  src/cpu/garuda_pc.v \
  src/cpu/garuda_idecode.v \
  src/cpu/garuda_regfile.v \
  src/cpu/garuda_alu.v \
  src/cpu/garuda_cpu_pipeline_top.v \
  src/integration/garuda_vertical_slice_top.v \
  src/integration/tb_garuda_vertical_slice_v24_6.v
```

---

## 2. Compilation Log Summary
- **Target Output Binary:** `build/garuda_titan_v12_r2.vvp`
- **Compiler Exit Code:** `0`
- **Syntax Errors:** `0`
- **Latch Warnings:** `0`
- **Status:** **PASS**
