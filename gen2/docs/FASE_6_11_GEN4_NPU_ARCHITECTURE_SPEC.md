# GARUDA SEMESTA GEN4 — NPU (NEURAL PROCESSING UNIT / AI EDGE ACCELERATOR) SPECIFICATION

**Document Version:** 1.0.0  
**Date:** November 26, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `main`  
**Status:** **GEN4 NPU SPECIFICATION & DESIGN START**  

---

## 1. OBJECTIVE

Specify and design **Garuda Semesta Gen4**, introducing a high-efficiency **Neural Processing Unit (NPU) / AI Edge Accelerator** integrated into the heterogeneous SoC.

- **Host CPU (Gen2 4-Core)**: Manages model loading, layer scheduling, and OS tasks.
- **GPU (Gen3 VPU)**: Handles vector arithmetic and 2D/3D graphics rendering.
- **NPU (Gen4 AI Engine)**: Executes deep neural network (DNN) tensor inference (convolution, matrix multiplication, activation) at ultra-low power.

```
+-----------------------------------------------------------------------+
|                      GARUDA SEMESTA GEN3 SOC                          |
|  +------------------------+  +-------------------+  +--------------+  |
|  | Gen2 4-Core Host CPU   |  | Gen3 GPU / VPU    |  | Shared RAM   |  |
|  +-----------+------------+  +---------+---------+  +-------+------+  |
+--------------|-------------------------|------------------|-----------+
               | AXI4 MMIO Bus           |                  |
               v                         v                  v
+-----------------------------------------------------------------------+
|            GEN4 NPU (NEURAL PROCESSING UNIT / AI ENGINE)              |
|                                                                       |
|  +---------------------------+   +---------------------------------+  |
|  | NPU Command & Layer FSM   |-->| Weight & Activation SRAM Buffer |  |
|  +-------------+-------------+   +----------------+----------------+  |
|                |                                  |                   |
|                v                                  v                   |
|  +-----------------------------------------------------------------+  |
|  | 8x8 SYSTOLIC ARRAY (64 Parallel MAC Units for Matrix Multiplication)|  |
|  +--------------------------------+--------------------------------+  |
|                                   |                                   |
|                                   v                                   |
|  +-----------------------------------------------------------------+  |
|  | Activation Function Unit (AFU) — ReLU / GELU Non-Linearity       |  |
|  +-----------------------------------------------------------------+  |
+-----------------------------------------------------------------------+
```

---

## 2. NPU ARCHITECTURAL SPECIFICATION

1. **8x8 Systolic Array Matrix Engine**:
   - 64 parallel Multiply-Accumulate (MAC) processing elements operating synchronously.
   - Computes 64 INT8/INT16 matrix operations per clock cycle.
2. **Activation Function Unit (AFU)**:
   - Hardware implementation of `ReLU` (`f(x) = max(0, x)`) and `GELU` activation functions.
3. **Weight & Feature Map SRAM Buffers**:
   - Dedicated 16 KB Weight SRAM and 16 KB Feature Map SRAM to stream layer inputs/weights without saturating the main AXI4 bus.
4. **MMIO Control Address**:
   - Address range `0x0000_6000 - 0x0000_60FF` on the AXI4 Interconnect.

---

## 3. IMPLEMENTATION PLAN

1. Create `gen2/rtl/npu/garuda_systolic_array_8x8.v`
2. Create `gen2/rtl/npu/garuda_npu_afu.v`
3. Create `gen2/rtl/npu/garuda_npu_top.v`
4. Integrate NPU into `garuda_gen3_heterogeneous_soc.v`
5. Create `gen2/tb/garuda_npu_tb.v` and `gen2/tests/run_npu_tests.py`
