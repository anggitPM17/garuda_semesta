# GARUDA SEMESTA — V2.3.2-R6 Forensic Audit & Connection Matrix

**Document Revision**: 12.3.2-R6-FORENSIC-AUDIT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Forensic Audit Table & Finding Remediation

| Finding ID | Component / File | Severity | Technical Audit Finding | Remediation Action Implemented | Status R6 |
| :---: | :--- | :---: | :--- | :--- | :---: |
| **AUDIT-R6-01** | `src/memory/garuda_l1_icache.v` | **HIGH** | `mem_req_ready` was declared but not checked before advancing FSM. | Updated `ST_COMPARE` to require `mem_req_valid && mem_req_ready` before transitioning to `ST_REFILL`. | **RTL_SIMULATED** |
| **AUDIT-R6-02** | `src/memory/garuda_memory_subsystem_top.v` | **HIGH** | `mem_req_ready` & `mem_resp_error` were un-instantiated for I-Cache. | Explicitly wired `mem_req_ready` and `mem_resp_error` to I-Cache ports. | **RTL_SIMULATED** |
| **AUDIT-R6-03** | `src/integration/garuda_vertical_slice_top.v` | **HIGH** | `icache_inst_data[31:0]` truncation risk existed on 64-bit instruction bus. | Enforced 64-bit data bus (`cpu_inst_data [63:0]`) end-to-end without truncation. | **RTL_SIMULATED** |
| **AUDIT-R6-04** | `src/memory/tb_garuda_l1_icache_r5.v` | **MEDIUM** | Testbench did not test backpressure (`mem_req_ready = 0`). | Created `tb_garuda_l1_icache_r6.v` testing 4 distinct words & backpressure stall. | **RTL_SIMULATED** |
| **AUDIT-R6-05** | `src/memory/garuda_memory_arbiter.v` | **MEDIUM** | Response routing required multi-master isolation for 3 masters. | Created 3-Master Isolated Arbiter for Master 0 (I-Cache), Master 1 (D-Cache), and Master 2 (DMA). | **RTL_SIMULATED** |
| **AUDIT-R6-06** | `src/integration/tb_garuda_vertical_slice_v23_2.v` | **CRITICAL** | Loose fallback OR condition existed on PC. | Enforced strict assertion: `$fatal(1, "SRAM READBACK FAILED")` if readback != 500. | **RTL_SIMULATED** |

---

## 2. Interface Contract Mapping

| Master / Slave | Data Width | Address Width | Request Handshake | Response Handshake |
| :--- | :---: | :---: | :--- | :--- |
| **Master 0 (I-Cache)** | 64-bit | 32-bit | `icache_req_valid` & `icache_req_ready` | `icache_resp_valid` & `icache_resp_error` |
| **Master 1 (D-Cache)** | 32-bit | 32-bit | `dcache_req_valid` & `dcache_req_ready` | `dcache_resp_valid` & `dcache_resp_error` |
| **Master 2 (GPU/DMA)** | 32-bit | 32-bit | `gpu_dma_req_valid` & `gpu_dma_grant` | `gpu_dma_resp_valid` & `gpu_dma_resp_error` |
| **SRAM Controller** | 32-bit | 32-bit | `req_valid` & `req_ready` | `resp_valid` & `resp_error` |
