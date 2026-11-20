# GARUDA SEMESTA — Memory Fabric Architecture Specification V2.3.2-R3

**Document Revision**: 12.3.2-R3-MEMORY-FABRIC  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Memory Subsystem Connection Diagram

$$\begin{array}{rcccl}
\text{GARUDA CPU Core Pipeline} & \xrightarrow{\text{64-bit Inst Fetch (PC)}} & \text{L1 I-Cache (4KB)} & \xrightarrow{\text{Refill 4-Word}} & \text{L2 Cache (32KB 4-Way)} \\
& \xrightarrow{\text{64-bit Data L/S}} & \text{L1 D-Cache (4KB Write-Back)} & \xrightarrow{\text{Evict/Refill}} & \text{L2 Cache (32KB 4-Way)} \\
\text{GPU / DMA Master} & \xrightarrow{\text{32-bit DMA Bus}} & \text{Multi-Master Arbiter} & \xrightarrow{\text{Target Req}} & \text{SRAM Controller (64KB)}
\end{array}$$

---

## 2. Bus Conversion & Interface Contract

| Interface Port | Data Width | Address Width | Protocol Handshake | Notes |
| :--- | :---: | :---: | :---: | :--- |
| **CPU I-Cache Fetch** | 64-bit | 32-bit | `icache_req_valid`, `icache_stall` | 64-bit Full GARUDA ISA Instruction Word |
| **CPU D-Cache Access** | 64-bit | 32-bit | `dcache_req_valid`, `dcache_stall` | Write-Back with 4-Byte Enable Masking |
| **L2 Unified Cache** | 32-bit | 32-bit | `l1_req_valid`, `l1_backpressure` | 4-Way Set Associative, Round-Robin Eviction |
| **Main SRAM Controller** | 32-bit | 32-bit | `req_valid`, `resp_valid`, `resp_error` | Base: `0x80000000`, Size: 64KB (`0x80010000` End) |
