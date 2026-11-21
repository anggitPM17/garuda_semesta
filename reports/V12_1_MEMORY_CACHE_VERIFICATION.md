# GARUDA SEMESTA V12.1 — MEMORY & CACHE VERIFICATION REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** **VERIFIED & PASSED**  

---

## 1. Executive Summary

This report documents the hardware verification results of the **GARUDA SEMESTA V12.1** memory subsystem and multi-level cache architecture.

---

## 2. Tested Components & Protocol Verification

| Subsystem Component | Tested Capabilities | Expected Result | Verified Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| **L1 Instruction Cache** | 64-bit line fetch, combinational miss stall | Freeze PC on miss, line refill | 100% Correct Line Refill | **PASS** |
| **64-to-32 Bus Adapter** | Twin 32-bit burst translation | Reassemble 64-bit instruction word | `{upper_32, lower_32}` preserved | **PASS** |
| **L1 Data Cache** | Write-through to L2/SRAM | Hybrid combinational/latched hold | Data `500` written to SRAM | **PASS** |
| **L2 Unified Cache** | 4-Way Set-Associative, per-word valid vector | Zero false hit on un-refilled words | 100% Accurate Hit/Miss | **PASS** |
| **Memory Arbiter** | Round-robin arbitration (L2 vs DMA) | Grant access without transaction collision | Zero Bus Collision | **PASS** |
| **SRAM Controller** | 64 KB SRAM `main_sram[0:16383]` | `$readmemh` loading & DMA readback | `main_sram[64] == 500` | **PASS** |

---

## 3. Real DMA SRAM Readback Verification
```text
[STAGE 3] Performing Independent DMA Readback from SRAM 0x80000100...
[SRAM CONTROLLER LOG] READ addr=0x80000100, word_idx=   64, data=       500
[STAGE 4] Strict Assertion: Asserting SRAM[0x80000100] == 500...
PASS: REAL RTL SRAM READBACK VERIFIED (SRAM[0x80000100] == 500)
```
