# GARUDA SEMESTA — V2.3.2-R6.1 Forensic Audit & Baseline Report

**Document Revision**: 12.3.2-R6.1-FORENSIC-BASELINE  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/hardening-v2.3.2`  
**HEAD Commit**: `95b0cf5`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Forensic Audit Table & Defect Categorization

| Finding ID | Location / File | Severity | Actual Behavior | Expected Behavior | Technical Impact | Resolution Action | Status |
| :---: | :--- | :---: | :--- | :--- | :--- | :--- | :---: |
| **R61-FIND-01** | `src/memory/garuda_l1_icache.v` | **CRITICAL** | `mem_req_ready` was declared but not checked before FSM refill transition. | FSM must check `mem_req_valid && mem_req_ready` before advancing state. | Request loss or duplicate refill under backpressure. | Updated `ST_COMPARE` next-state logic to check `mem_req_ready`. | **RTL_SIMULATED** |
| **R61-FIND-02** | `src/memory/garuda_memory_subsystem_top.v` | **HIGH** | `mem_req_ready` & `mem_resp_error` were un-instantiated for I-Cache. | Explicitly wire `mem_req_ready` and `mem_resp_error` to I-Cache. | Signal floating / missing handshake. | Instantiated explicit `mem_req_ready` and `mem_resp_error` wires. | **RTL_SIMULATED** |
| **R61-FIND-03** | `src/integration/garuda_vertical_slice_top.v` | **HIGH** | Instruction bus truncation `icache_inst_data[31:0]` risk existed. | Pass full 64-bit instruction bus (`cpu_inst_data[63:0]`). | Instruction bit truncation during fetch. | Connected 64-bit instruction bus end-to-end. | **RTL_SIMULATED** |
| **R61-FIND-04** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | **CRITICAL** | Fallback OR condition on PC existed. | Require `SRAM[0x80000100] == 500` strictly with `$fatal`. | Risk of false PASS on PC advance. | Removed PC fallback OR condition; enforced strict `$fatal` readback. | **RTL_SIMULATED** |
| **R61-FIND-05** | `src/verification/garuda_verilog_linter_and_simulator.py` | **MEDIUM** | Contained text-pattern cycle narrative strings. | Run real Verilog static lint & cycle simulation. | Misrepresentation of Python strings as RTL simulation. | Separated static lint, elaboration, and cycle simulation. | **RTL_SIMULATED** |

---

## 📜 2. Executive Signoff

**Verified & Approved by**:  
**Anggit Prasetyo Mituhu**  
*Founder & Chief System Architect*  
*GARUDA SEMESTA Semiconductor Architecture*
