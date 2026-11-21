# GARUDA TITAN V13.1 — RTL DEPENDENCY MAP
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V13.1 — CHIP COMPLETION MISSION  
**Date:** November 2026  
**Status:** **MAPPED & VERIFIED**  

---

## 1. Top-Level Dependency Hierarchy

```text
garuda_semesta_chip_top
├── u_cpu (garuda_cpu_pipeline_top)
│   ├── u_pc (garuda_pc)
│   ├── u_decoder (garuda_idecode)
│   ├── u_regfile (garuda_regfile)
│   └── u_alu (garuda_alu)
├── u_memory_subsystem (garuda_memory_subsystem_top)
│   ├── u_icache (garuda_l1_icache)
│   ├── u_dcache (garuda_l1_dcache)
│   ├── u_l2_cache (garuda_l2_cache)
│   ├── u_arbiter (garuda_memory_arbiter)
│   ├── u_bus_adapter (garuda_bus_adapter_64to32)
│   └── u_mem_controller (garuda_memory_controller)
├── u_interconnect (garuda_chip_interconnect)
├── u_intc (garuda_interrupt_controller)
├── u_timer (garuda_timer)
└── u_uart (garuda_uart)
```
