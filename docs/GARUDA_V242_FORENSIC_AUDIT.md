# GARUDA SEMESTA — V2.4.2 FORENSIC AUDIT & BASELINE REPORT

**Document Revision**: 12.4.2-FORENSIC-AUDIT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/v2.4.2-docker-native-rtl-proof`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  
**Core Motto**: *ONE SOURCE OF TRUTH. ONE REAL RTL EXECUTION PATH. REPRODUCIBLE DOCKER EDA. ZERO FALSE PASS.*

---

## 1. Forensic Audit Table & Component Categorization

| Finding ID | Location / Component | Severity | Actual Behavior | Expected Behavior | Remediation Action | Status V2.4.2 |
| :---: | :--- | :---: | :--- | :--- | :--- | :---: |
| **AUDIT-V242-01** | `garuda_compiler.py` | **HIGH** | Compiler emitted 64-bit HEX instruction words. | Compile GARUDA assembly source `150 + 350` to `program.hex`. | Created `src/verification/garuda_compiler_pipeline.py`. | **RTL_SIMULATED** |
| **AUDIT-V242-02** | `src/cpu/garuda_cpu_pipeline_top.v` | **HIGH** | Instruction ROM fetched instructions from memory array. | Load `program.hex` via `$readmemh` into instruction memory ROM. | Added `$readmemh` instruction ROM loading. | **RTL_SIMULATED** |
| **AUDIT-V242-03** | `src/memory/garuda_memory_subsystem_top.v` | **HIGH** | 64-bit instruction bus connected to CPU pipeline. | Full 64-bit instruction bus passed without truncation. | Connected 64-bit instruction bus end-to-end. | **RTL_SIMULATED** |
| **AUDIT-V242-04** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | **CRITICAL** | Strict `$fatal` assertion on SRAM readback. | Assert `SRAM[0x80000100] == 500` strictly without PC fallback. | Removed PC fallback; enforced strict `$fatal` assertion. | **RTL_SIMULATED** |
| **AUDIT-V242-05** | `docker/eda/Dockerfile` | **MEDIUM** | Reproducible Docker EDA container image. | Install Ubuntu 22.04, Python 3, `iverilog`, `vvp`, `gtkwave`. | Created `garuda-eda:v2.4.2` image. | **RTL_SIMULATED** |

---

## 2. Disambiguated Status Categories
- **IMPLEMENTED**: Source code / RTL written.
- **COMPILED**: RTL compiled cleanly with 0 errors via Icarus Verilog (`iverilog -g2012`).
- **RTL_SIMULATED**: RTL simulation executed via `vvp` and assertions passed (`SRAM[0x80000100] == 500`).
- **PHYSICAL_DESIGN_VERIFIED**: OpenLane configuration signoff verified (`src/openlane/garuda_l1_icache/config.json`).
