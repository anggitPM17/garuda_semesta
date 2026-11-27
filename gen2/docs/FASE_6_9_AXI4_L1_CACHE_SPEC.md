# GARUDA SEMESTA GEN2 — FASE 6.9 INDUSTRIAL AXI4 & PRIVATE L1 CACHE SPECIFICATION

**Document Version:** 1.0.0  
**Date:** November 26, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Status:** **SPECIFICATION & DESIGN — INDUSTRIAL UPGRADE**  

---

## 1. OBJECTIVE

Specify and design the transition of the **Garuda Semesta Gen2 4-Core Multiprocessor** to professional industrial standards:
1. **AMBA AXI4 Protocol Interconnect**: Replace custom memory handshakes with standard AMBA AXI4 master/slave interfaces (`AW`, `W`, `B`, `AR`, `R`).
2. **Private L1 Instruction & Data Caches**: Implement direct-mapped / 2-way set-associative L1 caches per hart to eliminate shared bus bottlenecks.

---

## 2. AMBA AXI4 INTERCONNECT ARCHITECTURE

Each hart exposes an AXI4 Master interface:
- **Write Address Channel (`AW`)**: `awid`, `awaddr`, `awlen`, `awsize`, `awburst`, `awvalid`, `awready`
- **Write Data Channel (`W`)**: `wdata`, `wstrb`, `last`, `wvalid`, `wready`
- **Write Response Channel (`B`)**: `bid`, `bresp`, `bvalid`, `bready`
- **Read Address Channel (`AR`)**: `arid`, `araddr`, `arlen`, `arsize`, `arburst`, `arvalid`, `arready`
- **Read Data Channel (`R`)**: `rid`, `rdata`, `rresp`, `rlast`, `rvalid`, `rready`

The **AXI4 Crossbar Interconnect** handles 4 masters (Hart 0..3) and 3 slaves (Shared RAM, CLINT, Mailbox) with round-robin arbitration and ID tagging.

---

## 3. PRIVATE L1 CACHE SPECIFICATION

- **L1 Instruction Cache (I-Cache)**: 4 KB, direct-mapped, 64-byte cache lines.
- **L1 Data Cache (D-Cache)**: 4 KB, direct-mapped, write-through policy to maintain memory consistency without complex snooping in Version 1.0.
- **Hit Ratio Target**: >90% instruction hit rate, reducing shared bus contention significantly.

---

## 4. IMPLEMENTATION PLAN

1. Create `gen2/rtl/interconnect/garuda_axi_crossbar.v`
2. Create `gen2/rtl/cache/garuda_l1_cache.v`
3. Integrate AXI4 and L1 Caches into `garuda_4core_top.v`
4. Run multicore verification simulation in Docker.
