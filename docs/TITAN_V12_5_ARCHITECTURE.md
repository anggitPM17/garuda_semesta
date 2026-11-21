# GARUDA TITAN V12.5 — CPU EXECUTION ENGINE ARCHITECTURE SPECIFICATION
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V12.5 — COMPLETE CPU EXECUTION ENGINE  
**Date:** November 2026  
**Status:** **APPROVED & IMPLEMENTED IN SYNTHESIZABLE RTL**  

---

## 1. Executive Summary

The **GARUDA TITAN V12.5** CPU execution engine expands the synthesizable 5-stage pipeline core (`garuda_cpu_pipeline_top.v`) with precise Branch/Jump execution, 1-cycle pipeline flush engine, hardware interrupt vectoring, and MMIO interconnect response multiplexing.

---

## 2. Pipeline Stage Breakdown

```text
+---------------+     +---------------+     +---------------+     +---------------+     +---------------+
| Instruction   |---> | Instruction   |---> | Execute (EX)  |---> | Memory (MEM)  |---> | Writeback (WB)|
| Fetch (IF)    |     | Decode (ID)   |     | - ALU / MUL   |     | - D-Cache     |     | - RegFile Write|
| - PC Unit     |     | - Decoder     |     | - BEQ / JMP   |     | - MMIO MUX    |     | - Retires Inst|
| - I-Cache 4KB |     | - RegFile 32x64|    | - Flush Engine|     | - Bus Adapter |     | - Exceptions  |
+---------------+     +---------------+     +---------------+     +---------------+     +---------------+
```

- **Branch Engine:** Evaluates `BEQ` (Opcode `0x5`) and `JMP` (Opcode `0x6`) in EX stage.
- **Pipeline Flush:** When `branch_taken` evaluates TRUE, a 1-cycle flush clears `if_id` and injects a NOP bubble into `id_ex`, preventing mispredicted instruction execution.
- **Hardware Interrupt Line:** `irq_req` input line vectors interrupts directly into the PC unit.
