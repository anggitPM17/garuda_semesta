# GARUDA SEMESTA V0.3.3 — SOC ARCHITECTURE & MMIO PROTOCOL
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V0.3.3 TRANSACTION INTEGRITY & PERIPHERAL EXECUTION  
**Date:** November 2026  
**Status:** **APPROVED & IMPLEMENTED**  

---

## 1. Top-Level SoC Integration Architecture

```text
+-----------------------------------------------------------------------------------+
|                        GARUDA SEMESTA CHIP TOP V0.3.3                             |
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

## 2. Response Multiplexing Logic ([garuda_semesta_chip_top.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_semesta_chip_top.v))
- **Memory Address Check:** `wire is_mmio_addr = (dcache_addr < 32'h8000_0000);`
- **Read Data MUX:** `assign dcache_read_val[31:0] = is_mmio_addr ? mmio_read_data : sram_dcache_read_val;`
- **Valid Response MUX:** `assign dcache_valid = is_mmio_addr ? mmio_resp_valid : sram_dcache_valid;`
- **Stall MUX:** `assign dcache_stall = is_mmio_addr ? 1'b0 : sram_dcache_stall;`
