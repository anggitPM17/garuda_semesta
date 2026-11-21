# GARUDA TITAN V12.5 — KNOWN LIMITATIONS & FUTURE ROADMAP
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** TITAN V12.5 COMPLETE CPU EXECUTION ENGINE  
**Date:** November 2026  
**Status:** **AUDITED**  

---

## 1. Architectural Scope & Boundaries

- **CPU Core Execution Engine:** Synthesizable 5-stage pipeline with Branch/Jump control, forwarding, load-use hazard handling, and MMIO response MUXing.
- **Physical Memory Capacity:** 64 KB Main SRAM (`0x8000_0000` - `0x8000_FFFF`).
- **Physical ASIC Target:** Designed for open-source EDA synthesis (Yosys) and simulation (Icarus Verilog / Verilator). GDSII physical place-and-route requires OpenROAD target configuration.
