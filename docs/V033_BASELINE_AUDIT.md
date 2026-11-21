# GARUDA SEMESTA V0.3.3 — FORENSIC BASELINE & SOC TRANSACTION AUDIT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA SEMESTA V0.3.3 — TRANSACTION INTEGRITY, PERIPHERAL RTL REPAIR & CPU-DRIVEN SOC PROOF  
**Date:** November 2026  
**Status:** **AUDITED & VERIFIED**  

---

## 1. Executive Summary

This forensic baseline audit establishes the hardware transaction protocol, MMIO address decoding, single procedural driver checks, and pipeline hazard recovery for milestone **GARUDA SEMESTA V0.3.3**.

---

## 2. Integrated Module & Interconnect Matrix

| Module Name | Source File | Functionality | Interconnect Alignment | Status |
| :--- | :--- | :--- | :--- | :--- |
| `garuda_semesta_chip_top` | [garuda_semesta_chip_top.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_semesta_chip_top.v) | System-on-Chip Top Entry Point | Muxes MMIO & SRAM responses back to CPU | **PASS** |
| `garuda_chip_interconnect` | [garuda_chip_interconnect.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_chip_interconnect.v) | MMIO Address Decoder & Bus Router | Decodes `< 0x8000_0000` MMIO transactions | **PASS** |
| `garuda_interrupt_controller` | [garuda_interrupt_controller.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_interrupt_controller.v) | MMIO INTC (`0x4000_1000`) | Active MMIO read/write & IRQ vectoring | **PASS** |
| `garuda_timer` | [garuda_timer.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_timer.v) | MMIO Timer (`0x4000_2000`) | Active MMIO read/write & 32-bit counter | **PASS** |
| `garuda_uart` | [garuda_uart.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_uart.v) | MMIO UART (`0x4000_3000`) | Single-driver synthesizable 4-state TX FSM | **PASS** |
| `garuda_memory_controller` | [garuda_memory_controller.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_controller.v) | Main SRAM (`0x8000_0000`) | 64 KB Main SRAM (`main_sram[0:16383]`) | **PASS** |

---

## 3. Canonical Address Map
- **Main SRAM & Boot Memory:** `0x8000_0000` - `0x8000_FFFF` (64 KB / 16,384 32-bit words)
- **Interrupt Controller MMIO:** `0x4000_1000` - `0x4000_101F` (32 Bytes)
- **MMIO Timer:** `0x4000_2000` - `0x4000_201F` (32 Bytes)
- **MMIO UART Serial:** `0x4000_3000` - `0x4000_301F` (32 Bytes)
