# GARUDA SEMESTA V0.3.3 — VERIFICATION MATRIX & ACCEPTANCE GATES
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V0.3.3 SOC TRANSACTION INTEGRITY  
**Date:** November 2026  
**Status:** **APPROVED & VERIFIED**  

---

## 1. Acceptance Gate Verification Matrix

| Gate | Acceptance Criteria | Target Hardware | Verified Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| **G1** | TITAN V12 baseline preserved | CPU Core | All 14 physical modules intact | **PASS** |
| **G2** | CPU SRAM path and cache verified | CPU & Caches | `SRAM[0x80000100] == 500` | **PASS** |
| **G3** | CPU MMIO response routing connected | Interconnect & CPU | Muxed `mmio_read_data` & `mmio_resp_valid` to CPU | **PASS** |
| **G4** | Active interconnect transaction routing | Interconnect | Decodes `< 0x8000_0000` MMIO addresses | **PASS** |
| **G5** | Unmapped address handling | Interconnect | Rejects invalid address without SRAM corruption | **PASS** |
| **G6** | UART TX FSM serial engine | MMIO UART | Synthesizable baud generator & 4-state TX FSM | **PASS** |
| **G7** | Timer MMIO & IRQ verified | MMIO Timer | 32-bit counter & timer IRQ line | **PASS** |
| **G8** | Interrupt Controller & IRQ line | MMIO INTC | 8-channel vectoring & `irq_to_cpu` output | **PASS** |
| **G9** | Single-source-of-truth runner | Verification | `garuda_v033_soc_runner.py` | **PASS** |
| **G10** | Clean build & zero binary pollution | Build System | `.vvp` build binaries cleaned from Git | **PASS** |
