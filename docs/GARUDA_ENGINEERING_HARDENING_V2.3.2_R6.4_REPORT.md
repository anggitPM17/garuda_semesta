# GARUDA SEMESTA — V2.3.2-R6.4 DOCKER EDA WORKSTATION & REAL RTL EXECUTION REPORT

**Document Revision**: 12.3.2-R6.4-DOCKER-EDA-WORKSTATION-PASSED  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/hardening-v2.3.2`  
**Starting Commit**: `325de53` / `06bf63c`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  
**Core Motto**: *ONE REPRODUCIBLE EDA ENVIRONMENT. ONE REAL RTL EXECUTION PATH. ZERO FALSE PASS.*

---

## 1. Executive Summary & R6.4 Milestone Achievements

In strict compliance with **GARUDA SEMESTA — V2.3.2-R6.4 DIRECTIVE**, the reproducible **GARUDA EDA Workstation Container** (`docker/eda/Dockerfile`) has been built and verified, and all hardware Verilog RTL instruction buses and testbenches have been aligned under branch `engineering/hardening-v2.3.2`:

### Key R6.4 Accomplishments:
1. **Garuda EDA Workstation Container (`docker/eda/`)**:
   - Built image `garuda-eda:latest` based on `ubuntu:22.04` with pre-installed `iverilog`, `vvp`, `gtkwave`, `python3`, `make`, and `gcc`.
   - Docker container execution command verified:
     ```bash
     docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:latest python3 src/verification/garuda_real_rtl_runner.py
     ```
2. **Elimination of Instruction Bus Truncation**:
   - `garuda_vertical_slice_top.v` connects full 64-bit instruction bus (`cpu_inst_data [63:0]`) directly without truncation.
   - `garuda_cpu_pipeline_top.v` fetches 64-bit instruction words with `$readmemh("garuda_program.hex", ...)` ROM loading.
3. **Strict Assertion Testbench (`src/integration/tb_garuda_vertical_slice_v23_2.v`)**:
   - Enforces `$fatal(1, "Expected 500 in SRAM[0x80000100]")` without any PC fallback condition.
   - Outputs GTKWave VCD waveform trace `rtl_waveform.vcd` via `$dumpfile` & `$dumpvars`.
4. **Subprocess Toolchain Runner (`src/verification/garuda_real_rtl_runner.py`)**:
   - Manages Icarus Verilog compilation and VVP execution cleanly, capturing exit codes and STDOUT/STDERR without hardcoding fake PASS.

---

## 📊 2. Architectural Verification Matrix (V2.3.2-R6.4)

| # | Component | Verilog Source File | Container / EDA Engine | Verification Proof |
| :---: | :--- | :--- | :---: | :--- |
| **1** | **EDA Container** | `docker/eda/Dockerfile` | `garuda-eda:latest` (Ubuntu 22.04) | Built & Verified (`iverilog` & `vvp` v11.0) |
| **2** | **L1 Instruction Cache** | `src/memory/garuda_l1_icache.v` | 64-bit Full ISA Word | `mem_req_valid && mem_req_ready` Handshake Checked |
| **3** | **CPU Pipeline Top** | `src/cpu/garuda_cpu_pipeline_top.v` | 64-bit Full ISA Word | `$readmemh` ROM Fetching Verified |
| **4** | **Vertical Slice Top** | `src/integration/garuda_vertical_slice_top.v` | 64-bit Full ISA Word | No Truncation (`icache_inst_data[63:0]`) |
| **5** | **Strict Testbench** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | 64-bit Full ISA Word | `$readmemh` + `$dumpvars` + `$fatal` Strict |

---

## 📜 3. Executive Signoff

**Verified & Approved by**:  
**Anggit Prasetyo Mituhu**  
*Founder & Chief System Architect*  
*GARUDA SEMESTA Semiconductor Architecture*
