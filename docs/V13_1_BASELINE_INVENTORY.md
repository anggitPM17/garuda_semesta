# GARUDA TITAN V13.1 — BASELINE INVENTORY
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V13.1 — CHIP COMPLETION MISSION  
**Date:** November 2026  
**Status:** **INVENTORIED & VERIFIED**  

---

## 1. Active RTL Module Inventory

| Module Name | Source Path | Functionality | Status |
| :--- | :--- | :--- | :--- |
| `garuda_semesta_chip_top` | [src/chip/garuda_semesta_chip_top.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_semesta_chip_top.v) | Top-Level SoC Entry Point | **ACTIVE** |
| `garuda_chip_interconnect` | [src/chip/garuda_chip_interconnect.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_chip_interconnect.v) | MMIO Interconnect FSM | **ACTIVE** |
| `garuda_cpu_pipeline_top` | [src/cpu/garuda_cpu_pipeline_top.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_cpu_pipeline_top.v) | 5-Stage CPU Pipeline Core | **ACTIVE** |
| `garuda_memory_subsystem_top` | [src/memory/garuda_memory_subsystem_top.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_subsystem_top.v) | Cache & Memory Fabric | **ACTIVE** |
| `garuda_memory_controller` | [src/memory/garuda_memory_controller.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_controller.v) | 64 KB Main SRAM Controller | **ACTIVE** |
| `garuda_uart` | [src/peripherals/garuda_uart.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_uart.v) | Single-Driver UART Serial Engine | **ACTIVE** |
| `garuda_timer` | [src/peripherals/garuda_timer.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_timer.v) | MMIO Hardware Timer | **ACTIVE** |
| `garuda_interrupt_controller` | [src/peripherals/garuda_interrupt_controller.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_interrupt_controller.v) | 8-Channel INTC with W1C Priority | **ACTIVE** |
