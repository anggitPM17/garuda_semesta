# GARUDA SEMESTA — Memory Fabric Forensic Audit & Port Connection Table V2.3.2-R4

**Document Revision**: 12.3.2-R4-FORENSIC-AUDIT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Verilog Module Connection & Port Mapping Table

| Module Name | Port Name | Width | Direction | Connected Source / Destination | Handshake & Reset Protocol |
| :--- | :--- | :---: | :---: | :--- | :--- |
| `garuda_l1_icache` | `req_addr` | 32-bit | Input | `garuda_cpu_pipeline_top.current_pc` | Address from PC |
| `garuda_l1_icache` | `resp_data` | 64-bit | Output | `garuda_cpu_pipeline_top.icache_inst_data` | Full 64-bit GARUDA ISA Instruction Word |
| `garuda_l1_icache` | `mem_req_addr` | 32-bit | Output | `garuda_memory_subsystem_top` | Increments `+8` bytes per word during refill |
| `garuda_l1_dcache` | `req_addr` | 32-bit | Input | `garuda_cpu_pipeline_top.dcache_addr` | Data Address from ALU / LSU |
| `garuda_l1_dcache` | `req_write_data`| 32-bit | Input | `garuda_cpu_pipeline_top.dcache_write_val` | Writeback Data from RegFile |
| `garuda_l1_dcache` | `req_byte_enable`| 4-bit | Input | `garuda_cpu_pipeline_top.dcache_byte_en` | Byte/Half/Word Write Mask (`4'hF`) |
| `garuda_l2_cache` | `l1_req_addr` | 32-bit | Input | `garuda_l1_dcache.mem_addr` | Refill/Eviction Address |
| `garuda_memory_arbiter`| `m0_addr` | 32-bit | Input | `garuda_l2_cache.mem_addr` | CPU Master 0 Address |
| `garuda_memory_arbiter`| `m1_addr` | 32-bit | Input | `gpu_dma_addr` | GPU/DMA Master 1 Address |
| `garuda_memory_controller`| `req_addr` | 32-bit | Input | `garuda_memory_arbiter.target_addr` | Base: `0x80000000`, Size: 64KB (`0x80010000`) |

---

## 2. Identified Defect Remediations
- **I-Cache Truncation**: Resolved by enforcing 64-bit data bus (`cpu_inst_data [63:0]`) from I-Cache output through Memory Subsystem Top to CPU Pipeline Top.
- **Refill Address Increment**: Resolved by implementing explicit address increment (`line_base + refill_cnt * 8`) in `garuda_l1_icache.v`.
- **SRAM Out-of-Bounds Error**: Enforced lower & upper bounds validation (`req_addr >= 0x80000000 && req_addr < 0x80010000`).
