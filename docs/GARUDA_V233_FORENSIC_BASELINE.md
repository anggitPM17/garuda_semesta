# GARUDA SEMESTA — V2.3.3 FORENSIC BASELINE & AUDIT REPORT

**Document Revision**: 12.3.3-FORENSIC-BASELINE  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/hardening-v2.3.2`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  
**Core Motto**: *SOURCE CODE IS TRUTH. RTL SIMULATION MUST BE REAL. PYTHON MODEL IS NOT RTL SIMULATION. ZERO FAKE PASS.*

---

## 1. Architectural Module Inventory & Disambiguation

| Module Category | File Path | Architectural Role | Simulation & Verification Level |
| :--- | :--- | :--- | :---: |
| **Compiler** | `garuda_compiler.py` | Compiles GARUDA assembly to 64-bit HEX (`program.hex`) | **RTL_SIMULATED** |
| **Instruction Fetch** | `src/cpu/garuda_pc.v` | 32-bit Program Counter (+8 Stride per 64b Word) | **RTL_SIMULATED** |
| **Instruction Decoder** | `src/cpu/garuda_idecode.v` | 64-bit GARUDA ISA Opcode & Operand Decoder | **RTL_SIMULATED** |
| **Register File** | `src/cpu/garuda_regfile.v` | 32 x 64-bit Register File (r0=0 Constant Zero) | **RTL_SIMULATED** |
| **ALU 64-bit** | `src/cpu/garuda_alu.v` | 64-bit Arithmetic Logic Unit (ADD, SUB, MUL) | **RTL_SIMULATED** |
| **CPU Pipeline Top** | `src/cpu/garuda_cpu_pipeline_top.v` | 5-Stage CPU Pipeline Core (IF/ID/EX/MEM/WB) | **RTL_SIMULATED** |
| **L1 Instruction Cache** | `src/memory/garuda_l1_icache.v` | 4KB 64-bit I-Cache (Explicit Handshake FSM) | **RTL_SIMULATED** |
| **L1 Data Cache** | `src/memory/garuda_l1_dcache.v` | 4KB 32-bit Write-Back D-Cache | **RTL_SIMULATED** |
| **L2 Cache** | `src/memory/garuda_l2_cache.v` | 32KB 4-Way Set Associative L2 Cache | **RTL_SIMULATED** |
| **Memory Arbiter** | `src/memory/garuda_memory_arbiter.v` | Multi-Master Arbiter (CPU & GPU Masters) | **RTL_SIMULATED** |
| **Memory Controller** | `src/memory/garuda_memory_controller.v` | 64KB SRAM Controller (Base: 0x80000000) | **RTL_SIMULATED** |
| **Vertical Slice Top** | `src/integration/garuda_vertical_slice_top.v` | End-to-End Vertical Slice Top | **RTL_SIMULATED** |

---

## 2. Python Reference Model vs RTL Verification Disambiguation
- **Python Models** (`GarudaCpu5StagePipelineEmulator`, `GarudaL1ICacheModel`, `GarudaL1DCacheModel`): Used ONLY as software reference architecture comparison oracles.
- **RTL Hardware Verification**: Driven by synthesizable Verilog modules (`src/memory/*.v`, `src/cpu/*.v`, `src/integration/garuda_vertical_slice_top.v`) and Verilog testbenches (`tb_garuda_vertical_slice_v23_2.v`).
