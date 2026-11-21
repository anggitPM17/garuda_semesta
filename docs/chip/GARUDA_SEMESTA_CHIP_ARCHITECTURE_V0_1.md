# GARUDA SEMESTA — CHIP SYSTEM ARCHITECTURE SPECIFICATION (v0.1)
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA SEMESTA — CHIP-FIRST REVOLUTION V0.1  
**Date:** November 2026  
**Status:** **APPROVED & IMPLEMENTED IN SYNTHESIZABLE RTL**  

---

## 1. Executive Chip Architecture Overview

The **GARUDA SEMESTA CHIP V0.1** represents the first integrated synthesizable System-on-Chip (SoC) entry point evolved from the **TITAN V12** hardware core.

```text
+-----------------------------------------------------------------------------------+
|                        GARUDA SEMESTA CHIP TOP V0.1                               |
|                  (garuda_semesta_chip_top.v / 100 MHz Domain)                     |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  +------------------------------+             +--------------------------------+  |
|  |   GARUDA 5-Stage CPU Core    |             |    MMIO Interconnect & Bus    |  |
|  |   - 64-bit Titanium ISA      |<----------->|   (garuda_chip_interconnect)   |  |
|  |   - 32x64-bit Register File  |             +--------------------------------+  |
|  |   - Load-Use Hazard Unit     |                             |                   |
|  +------------------------------+                             v                   |
|                 |                             +--------------------------------+  |
|                 v                             |     Multi-Master Arbiter       |  |
|  +------------------------------+             |  (CPU Master 0 vs DMA Master 1)|  |
|  | L1 I-Cache / L1 D-Cache (4KB)|             +--------------------------------+  |
|  +------------------------------+                             |                   |
|                 |                                             v                   |
|                 v                             +--------------------------------+  |
|  +------------------------------+             |  SRAM Main Memory Controller   |  |
|  |   L2 Unified Cache (2KB/32KB)|------------>|   64 KB Physical SRAM Array    |  |
|  +------------------------------+             +--------------------------------+  |
|                                                                                   |
|  +------------------------------+             +--------------------------------+  |
|  |  Native Interrupt Controller |             |  MMIO Timer & UART Peripherals |  |
|  |  (8-Channel IRQ Vector)      |             |  (garuda_timer / garuda_uart)  |  |
|  +------------------------------+             +--------------------------------+  |
+-----------------------------------------------------------------------------------+
```

---

## 2. Canonical Chip Address Map

| Memory / Peripheral Region | Address Range | Size | Access Type | Hardware Component |
| :--- | :--- | :--- | :--- | :--- |
| **Main SRAM & Boot ROM** | `0x8000_0000` - `0x8001_FFFF` | 128 KB | Read / Write | [garuda_memory_controller.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_controller.v) |
| **Secondary DMA Engine** | `0x4000_0000` - `0x4000_003F` | 64 Bytes | Read / Write | Memory Subsystem Arbiter |
| **Interrupt Controller** | `0x4000_1000` - `0x4000_101F` | 32 Bytes | Read / Write | [garuda_interrupt_controller.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_interrupt_controller.v) |
| **Hardware Timer** | `0x4000_2000` - `0x4000_201F` | 32 Bytes | Read / Write | [garuda_timer.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_timer.v) |
| **MMIO UART** | `0x4000_3000` - `0x4000_301F` | 32 Bytes | Read / Write | [garuda_uart.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_uart.v) |

---

## 3. Chip Module Hierarchy

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
│   ├── u_icache_adapter (garuda_bus_adapter_64to32)
│   ├── u_l2_cache (garuda_l2_cache)
│   ├── u_arbiter (garuda_memory_arbiter)
│   └── u_mem_controller (garuda_memory_controller)
├── u_intc (garuda_interrupt_controller)
├── u_timer (garuda_timer)
└── u_uart (garuda_uart)
```

---

## 4. Verification Evidence
The chip top level has been verified through real Icarus Verilog compilation and VVP execution in [tb_garuda_semesta_chip_v01.v](file:///D:/richat/garuda_semesta_repo/tests/chip/tb_garuda_semesta_chip_v01.v).
