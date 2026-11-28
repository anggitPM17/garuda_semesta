# GARUDA SEMESTA GEN3 — GPU & VECTOR ACCELERATOR ARCHITECTURE SPECIFICATION

**Document Version:** 1.0.0  
**Date:** November 26, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Status:** **GEN3 GPU DESIGN & SPECIFICATION START**  

---

## 1. ARCHITECTURE OVERVIEW

The **Garuda Semesta Gen3** introduces a dedicated **Vector Processing Unit (VPU) / SIMD GPU Accelerator** tightly coupled with the Gen2 4-Core RV64IM CPU. 
- **Gen2 CPU**: Acts as the *Host Processor* managing task queues, scalar control flow, and OS/bootstrap.
- **Gen3 GPU / VPU**: Acts as a *Co-processor Accelerator* executing data-parallel operations (pixel shading, matrix multiplication, vector arithmetic) across multiple parallel compute lanes using a Single Instruction, Multiple Data (SIMD) execution model.

```
+-------------------------------------------------------------+
|                      GEN2 HOST CPU                          |
|         (Scalar Control, Task Dispatch & OS Execution)      |
+------------------------------+------------------------------+
                               | AXI4 Command & Data Queue
                               v
+-------------------------------------------------------------+
|               GEN3 GPU / VECTOR ACCELERATOR                 |
|  +--------------------+   +------------------------------+  |
|  | Vector Instruction |-->| Vector Register File (VRF)   |  |
|  | Decoder & Dispatch |   | (128-bit / 256-bit Wide Regs)|  |
|  +--------------------+   +---------------+--------------+  |
|                                           |                 |
|                           +---------------+--------------+  |
|                           | Parallel Compute Lanes       |  |
|                           | [Lane 0] [Lane 1] [Lane 2]   |  |
|                           +---------------+--------------+  |
|                                           |                 |
|                           +---------------+--------------+  |
|                           | Memory Coalescing & Stride   |  |
|                           | Load/Store Unit              |  |
|                           +---------------+--------------+  |
+-------------------------------------------+-----------------+
                                            |
                                            v
+-------------------------------------------------------------+
|                SHARED RAM & AXI4 INTERCONNECT               |
+-------------------------------------------------------------+
```

---

## 2. KEY ARCHITECTURAL COMPONENTS

1. **Vector Register File (VRF)**:
   - 16 vector registers, each 128 bits wide (holding 2 x 64-bit elements, 4 x 32-bit elements, or 8 x 16-bit elements per vector register).
2. **Parallel Compute Lanes (SIMD ALUs)**:
   - 4 independent execution lanes operating simultaneously on vector elements in a single clock cycle.
3. **Memory Coalescing Unit**:
   - Gathers scattered scalar memory requests from vector lanes into a single wide burst transaction across the AMBA AXI4 interconnect.

---

## 3. INSTRUCTION SET SPECIFICATION (SIMD / VPU EXTENSION)

- **`VLD` (Vector Load)**: Load contiguous memory elements into Vector Register.
- **`VST` (Vector Store)**: Store Vector Register elements to memory.
- **`VADD.VV` (Vector-Vector Add)**: Element-wise addition across compute lanes.
- **`VMUL.VV` (Vector-Vector Multiply)**: Element-wise multiplication across compute lanes.

---

## 4. VERIFICATION & SIMULATION PLAN

- Create `gen2/rtl/gpu/garuda_vpu_top.v`
- Create `gen2/tb/garuda_gpu_tb.v`
- Validate vector arithmetic and memory coalescing in Docker.
