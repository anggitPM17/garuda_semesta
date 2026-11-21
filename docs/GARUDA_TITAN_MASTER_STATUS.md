# GARUDA SEMESTA — MASTER REPOSITORY STATUS & TRUTH SPECIFICATION (v13.1)
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V13.1 — CHIP COMPLETION MISSION  
**Date:** November 2026  
**Status:** **SINGLE SOURCE OF TRUTH (ACTIVE BASELINE)**  

---

## 1. Purpose of This Document

This document serves as the **Single Source of Truth** for the `anggitPM17/garuda_semesta` repository, resolving any ambiguity between historical iteration reports (V12.5 through V13.0) and the active hardware implementation on branch `engineering/v13.1-chip-completion` (merged into `main` at commit `7ea724f`).

---

## 2. Active RTL Implementation Truth

| Subsystem / Module | Source File Path | Active Architecture & Protocol | Status |
| :--- | :--- | :--- | :--- |
| **SoC Chip Top** | [src/chip/garuda_semesta_chip_top.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_semesta_chip_top.v) | Integrates CPU, Cache, SRAM, Interconnect, INTC, Timer, UART with MMIO stall MUX | **ACTIVE** |
| **Interconnect FSM** | [src/chip/garuda_chip_interconnect.v](file:///D:/richat/garuda_semesta_repo/src/chip/garuda_chip_interconnect.v) | Single-outstanding transaction FSM (`IDLE` $\rightarrow$ `CAPTURE` $\rightarrow$ `ISSUE` $\rightarrow$ `WAIT_RESPONSE` $\rightarrow$ `RETURN_RESPONSE` $\rightarrow$ `ERROR`) | **ACTIVE** |
| **CPU Pipeline Core** | [src/cpu/garuda_cpu_pipeline_top.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_cpu_pipeline_top.v) | 5-Stage CPU Core with BEQ/JMP branch engine, 1-cycle flush, and `irq_req` input | **ACTIVE** |
| **Memory Subsystem** | [src/memory/garuda_memory_subsystem_top.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_subsystem_top.v) | L1 I-Cache, L1 D-Cache, L2 Unified Cache, and Memory Arbiter | **ACTIVE** |
| **SRAM Controller** | [src/memory/garuda_memory_controller.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_memory_controller.v) | 64 KB Physical SRAM Array (`main_sram[0:16383]`) | **ACTIVE** |
| **UART Serial Engine** | [src/peripherals/garuda_uart.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_uart.v) | Single-driver synthesizable 4-state TX FSM with baud generator | **ACTIVE** |
| **Hardware Timer** | [src/peripherals/garuda_timer.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_timer.v) | MMIO 32-bit counter with compare match and IRQ | **ACTIVE** |
| **Interrupt Controller** | [src/peripherals/garuda_interrupt_controller.v](file:///D:/richat/garuda_semesta_repo/src/peripherals/garuda_interrupt_controller.v) | 8-Channel INTC with single next-state W1C priority logic | **ACTIVE** |

---

## 3. Authoritative Verification Entry Point

The single authoritative runner for all hardware regression tests is:
- [src/verification/garuda_v131_master_runner.py](file:///D:/richat/garuda_semesta_repo/src/verification/garuda_v131_master_runner.py)

**Re-execution Command:**
```bash
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 python3 -u src/verification/garuda_v131_master_runner.py
```
