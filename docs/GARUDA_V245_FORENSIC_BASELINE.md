# GARUDA SEMESTA — V2.4.5 FORENSIC AUDIT & BASELINE REPORT

**Document Revision**: 12.4.5-FORENSIC-BASELINE  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/v2.4.5-execution-reconstruction`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  
**Core Motto**: *NO HARDCODED ROM PASS. NO PC FALLBACK. NO EMULATOR SUBSTITUTION. NO BLOCKED-AS-PASS. REAL RTL. REAL DOCKER. REAL EVIDENCE.*

---

## 1. Forensic Audit Table & Defect Remediation (V2.4.5)

| Finding ID | Component / File | Severity | Actual Behavior | Expected Behavior | Remediation Action Implemented | Status V2.4.5 |
| :---: | :--- | :---: | :--- | :--- | :--- | :---: |
| **V245-AUDIT-01** | `src/cpu/garuda_cpu_pipeline_top.v` | **CRITICAL** | Hardcoded ROM array was loaded in `initial` block as fallback. | Load `program.hex` deterministically via `$readmemh`. | Replaced ROM fallback with single deterministic `$readmemh` instruction loading. | **RTL_SIMULATED** |
| **V245-AUDIT-02** | `src/cpu/garuda_cpu_pipeline_top.v` | **HIGH** | ALU operand B selection used `rs2_val != 0` check. | Use explicit immediate signal check (`imm != 0`). | Handled `rs2_val = 0` operand value correctly. | **RTL_SIMULATED** |
| **V245-AUDIT-03** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | **CRITICAL** | Loose PC fallback condition existed (`current_pc >= 0x80000020`). | Require `SRAM[0x80000100] == 500` strictly with `$fatal`. | Removed loose PC fallback condition; enforced strict `$fatal` assertion. | **RTL_SIMULATED** |
| **V245-AUDIT-04** | `src/verification/garuda_v242_runner.py` | **HIGH** | Returned exit status PASS on BLOCKED. | Non-zero exit code on BLOCKED or FAILED status. | Created `garuda_v245_runner.py` with strict exit code propagation. | **RTL_SIMULATED** |
| **V245-AUDIT-05** | `docker/eda/Dockerfile` | **MEDIUM** | Container image for reproducible EDA toolchain. | Install Ubuntu 22.04, Python 3, `iverilog`, `vvp`, `gtkwave`. | Created `garuda-eda:v2.4.5` image tag. | **RTL_SIMULATED** |

---

## 2. Disambiguated Status Classification Categories
- **SPECIFIED**: Architectural specification / KDoc definition written.
- **RTL_IMPLEMENTED**: Synthesizable Verilog RTL source code implemented.
- **RTL_COMPILED**: RTL compiled cleanly with 0 errors via Icarus Verilog (`iverilog -g2012`).
- **RTL_SIMULATED**: RTL simulation executed via `vvp` and assertions passed (`SRAM[0x80000100] == 500`).
- **PHYSICAL_DESIGN_VERIFIED**: OpenLane configuration signoff verified (`src/openlane/garuda_l1_icache/config.json`).
