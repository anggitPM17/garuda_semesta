# GARUDA SEMESTA V0.3.2 — CANONICAL CHIP ADDRESS MAP
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V0.3.2 ACTIVE SOC INTEGRATION & MMIO BUS  
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

## 2. Word Address Mapping Proof for Main SRAM
- **SRAM Base Address:** `0x8000_0000`
- **Target Address:** `0x8000_0100`
- **Offset in Bytes:** `0x8000_0100 - 0x8000_0000 = 0x100 = 256 bytes`
- **Word Array Index:** `256 / 4 = 64`
- **Array Location:** `u_mem_controller.main_sram[64] == 500`
