# GARUDA SEMESTA V0.3.3 — CANONICAL CHIP ADDRESS MAP
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V0.3.3 SOC TRANSACTION INTEGRITY & MMIO BUS  
**Date:** November 2026  
**Status:** **APPROVED & IMPLEMENTED**  

---

## 1. Address Space Regions

```text
+-----------------------+-----------------------+---------------------+-------------------------------+
| Address Range         | Region Name           | Size                | Target Hardware Component     |
+-----------------------+-----------------------+---------------------+-------------------------------+
| 0x8000_0000 - 0x8000_FFFF | Main SRAM & Boot ROM  | 64 KB (16,384 words)| garuda_memory_controller.v    |
| 0x4000_0000 - 0x4000_003F | Secondary DMA Engine  | 64 Bytes            | garuda_memory_arbiter.v       |
| 0x4000_1000 - 0x4000_101F | Interrupt Controller  | 32 Bytes            | garuda_interrupt_controller.v |
| 0x4000_2000 - 0x4000_201F | MMIO Timer            | 32 Bytes            | garuda_timer.v                |
| 0x4000_3000 - 0x4000_301F | MMIO UART Serial      | 32 Bytes            | garuda_uart.v                 |
+-----------------------+-----------------------+---------------------+-------------------------------+
```

---

## 2. Address Decoding & Alignment Rules
- **Memory Requests (`>= 0x8000_0000`):** Routed to L1/L2 caches and SRAM Controller (`garuda_memory_subsystem_top.v`).
- **MMIO Requests (`< 0x8000_0000`):** Bypass L1/L2 caches and route directly to MMIO peripherals via [garuda_chip_interconnect.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_chip_interconnect.v). Unmapped addresses return an error response without corrupting SRAM.
