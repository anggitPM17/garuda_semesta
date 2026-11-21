# GARUDA SEMESTA V12.2 — MEMORY FABRIC VALIDATION REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** **PASSED & VERIFIED**  

---

## 1. Memory Subsystem Topology

- **L1 Instruction Cache (`garuda_l1_icache.v`):** 4 KB Direct-Mapped, 32-Byte Line Size (4 x 64-bit instruction words).
- **Bus Adapter (`garuda_bus_adapter_64to32.v`):** Translates 64-bit instruction fetches into twin 32-bit burst requests.
- **L1 Data Cache (`garuda_l1_dcache.v`):** 4 KB Direct-Mapped, Write-Through policy.
- **L2 Unified Cache (`garuda_l2_cache.v`):** 2 KB 4-Way Set-Associative Cache with per-word valid vectors.
- **Memory Arbiter (`garuda_memory_arbiter.v`):** Round-robin multi-master arbitration (L2 vs DMA).
- **Memory Controller (`garuda_memory_controller.v`):** 64 KB Main SRAM Controller (`main_sram[0:16383]`).

---

## 2. Memory Fabric Test Matrix

| Test Case | Description | Expected Outcome | RTL Simulation Result |
| :--- | :--- | :--- | :--- |
| **I-Cache Twin Burst Fetch** | Fetch 64-bit instruction word over 32-bit L2 bus | Complete 64-bit instruction assembled | **PASS** |
| **D-Cache Store Write-Through** | Write `500` to target address `0x80000100` | Write data passes through L2 to SRAM | **PASS** (`main_sram[64] == 500`) |
| **DMA Readback Verification** | Read SRAM location `0x80000100` via DMA | Returned data equals `500` | **PASS** (`ext_dma_read_val == 500`) |
| **Arbiter Arbitration** | CPU and DMA request memory access concurrently | Zero collision or transaction corruption | **PASS** |
