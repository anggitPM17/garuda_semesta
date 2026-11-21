# GARUDA SEMESTA — Memory Fabric Architecture & Interface Contract V2.3.2-R6.1

**Document Revision**: 12.3.2-R6.1-MEMORY-FABRIC  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. 3-Master Isolated Memory Fabric Topology

$$\begin{array}{rcccl}
\text{Master 0: CPU I-Cache (64-bit)} & \xrightarrow{\text{mem\_req\_valid \& mem\_req\_ready}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 0}} & \text{CPU I-Cache} \\
\text{Master 1: CPU D-Cache (32-bit)} & \xrightarrow{\text{dcache\_req\_valid \& grant}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 1}} & \text{CPU D-Cache} \\
\text{Master 2: GPU / DMA (32-bit)} & \xrightarrow{\text{dma\_req\_valid \& grant}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 2}} & \text{GPU / DMA} \\
\text{3-Master Arbiter} & \xrightarrow{\text{target\_req\_valid \& addr}} & \text{SRAM Controller} & \xrightarrow{\text{Base: 0x80000000}} & \text{SRAM Backend (64KB)}
\end{array}$$

---

## 2. Interface Contract & Protocol Definitions

| Interface Port | Data Width | Address Width | Request Handshake | Response Handshake |
| :--- | :---: | :---: | :--- | :--- |
| **Master 0 (CPU I-Cache)** | 64-bit | 32-bit | `icache_mem_valid` & `icache_mem_ready` | `icache_mem_resp_valid` & `icache_mem_resp_error` |
| **Master 1 (CPU D-Cache)** | 32-bit | 32-bit | `dcache_mem_valid` & `dcache_mem_grant` | `dcache_mem_resp_valid` & `dcache_mem_resp_error` |
| **Master 2 (GPU / DMA)** | 32-bit | 32-bit | `gpu_dma_req_valid` & `gpu_dma_grant` | `gpu_dma_resp_valid` & `gpu_dma_resp_error` |
| **Main SRAM Controller** | 32-bit | 32-bit | `req_valid` & `req_ready` | `resp_valid` & `resp_error` |

- **Instruction Fetch Bus**: 64-bit full instruction word passed directly from `garuda_l1_icache.v` through `garuda_memory_subsystem_top.v` to `garuda_cpu_pipeline_top.v`.
- **SRAM Bounds**: Base `0x80000000` to End-Exclusive `0x80010000` (65,536 bytes). Addresses outside bounds trigger `resp_error = 1`.
