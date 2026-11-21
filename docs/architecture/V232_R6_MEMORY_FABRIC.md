# GARUDA SEMESTA — Memory Fabric Architecture Specification V2.3.2-R6

**Document Revision**: 12.3.2-R6-MEMORY-FABRIC  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. 3-Master Memory Fabric Architecture Topology

$$\begin{array}{rcccl}
\text{CPU I-Cache Master 0 (64-bit)} & \xrightarrow{\text{mem\_req\_valid \& mem\_req\_ready}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 0}} & \text{CPU I-Cache} \\
\text{CPU D-Cache Master 1 (32-bit)} & \xrightarrow{\text{dcache\_req\_valid \& grant}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 1}} & \text{CPU D-Cache} \\
\text{GPU / DMA Master 2 (32-bit)} & \xrightarrow{\text{dma\_req\_valid \& grant}} & \text{3-Master Arbiter} & \xrightarrow{\text{Isolated Resp 2}} & \text{GPU / DMA} \\
\text{3-Master Arbiter} & \xrightarrow{\text{target\_req\_valid \& addr}} & \text{SRAM Controller} & \xrightarrow{\text{Base: 0x80000000}} & \text{SRAM Backend (64KB)}
\end{array}$$

---

## 2. Bus Conversion & Endianness Specification

- **Instruction Fetch Bus**: 64-bit full instruction word passed directly from `garuda_l1_icache.v` to `garuda_cpu_pipeline_top.v`.
- **Data Bus**: 32-bit data bus with 4-byte byte enables (`req_byte_enable[3:0]`).
- **SRAM Bounds**: Base `0x80000000` to End-Exclusive `0x80010000` (65,536 bytes). Addresses outside bounds trigger `resp_error = 1`.
