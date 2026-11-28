# 🦅 GARUDA SEMESTA — OPEN-SOURCE RISC-V MULTICORE & HETEROGENEOUS AI SOC

Welcome to **Garuda Semesta**, a state-of-the-art open-source 64-bit RISC-V Multicore Processor, GPU Vector Accelerator, and Super-NPU AI Engine family designed for high-performance embedded systems, edge AI inference, and ASIC physical synthesis via OpenLane.

---

## 🌟 ARCHITECTURAL HIGHLIGHTS & GENERATIONS

### 🇮🇩 1. Garuda Semesta Gen2 — RV64IM Quad-Core Multiprocessor SoC
- **ISA**: 64-Bit RISC-V RV64IM (Base Integer + Hardware Multiplication & Division `MUL`, `MULH`, `MULHU`, `DIV`, `DIVU`, `REM`, `REMU`).
- **Core Complex**: 4 Independent Harts (`hart_id = 0, 1, 2, 3`) with read-only CSR `mhartid` (`0xF14`).
- **Pipeline**: 5-Stage In-Order Pipeline with Hazard Unit and Data Forwarding.
- **Interconnect**: 4-Port Crossbar Interconnect with Round-Robin Bus Arbiter (Grant Locking) and Response Router (*Zero Crosstalk*).
- **Inter-Hart Sync**: Core Local Interruptor (CLINT - `mtime`, `mtimecmp0..3`, `msip0..3`) and Hardware Mailbox with MMIO Mutex Locks (`LOCK_REG0..3`).

### 🎨 2. Garuda Semesta Gen3 — Heterogeneous Super-SoC & GPU Accelerator
- **Gen3 GPU / VPU**: Vector Processing Unit featuring a 16 x 128-bit Vector Register File (3 Read Ports + 1 Write Port), 4 SIMD Compute Lanes (`VADD.VV`, `VMUL.VV`), Tensor Multiply-Accumulate (`VMACC.VV`), and Vector Masking (`vmask`).
- **Crypto Security Engine**: Hardware AES-256 and SHA-256 MMIO Accelerator (`0x0000_3000`).
- **DMA Framebuffer Controller**: 24-bit RGB Video Timing Generator (`hsync`, `vsync`, `rgb_out`) for 2D graphics rendering from Shared RAM (`0x0000_4000`).

### 🧠 3. Garuda Semesta Gen4 — Super-NPU AI Edge Accelerator
- **8x8 Systolic Array**: 64 parallel 16-bit Multiply-Accumulate (MAC) processing elements computing tensor dot-products in a single clock cycle.
- **Hardware Layer Bias Unit**: Integrated bias addition (`Result = AFU(DotProduct + Bias)`).
- **Activation Function Unit (AFU)**: Hardware non-linearities (`ReLU` and `GELU`).
- **2x2 Max/Avg-Pooling Engine**: Hardware feature map dimension reduction (`garuda_npu_pooling.v`).
- **INT8 Re-Quantization Unit**: Fixed-point multiplier scaling and shift saturation (`garuda_npu_quantizer.v`).

---

## 🧪 VERIFICATION & HARDENING STATUS (DOCKER EDA)

All design generations are fully verified and signed off using Docker EDA (`garuda-goldenway:v1.0`):

| Test Suite / Matrix | Description | Result |
| :--- | :--- | :---: |
| **Multi-Latency x Backpressure Regression** | 20 Configurations (Latencies 0, 1, 3, 5 x Backpressure 0, 1, 2, 4, 8) | **20 / 20 PASS** |
| **Adversarial Fault Injection (Negative Tests)** | Real fault injection (Payload stability, duplicate store, timeout watchdog, count mismatch, fatal, stale logs) | **6 / 6 PASS** |
| **Hart ID & CSR `mhartid` Suite** | Architectural Hart ID read-only & register integrity verification (HID-01..HID-08) | **8 / 8 PASS** |
| **4-Core Multicore Execution** | Parallel execution of Hart 0..3 reaching EBREAK simultaneously | **4 / 4 PASS** |
| **Inter-Hart Synchronization** | CLINT timer/software interrupts and MMIO Mutex Lock coordination | **PASS** |
| **Gen3 GPU / VPU SIMD & Tensor MAC** | 128-bit vector arithmetic, `VMACC.VV` Tensor MAC, and vector masking | **PASS** |
| **Gen3 Heterogeneous Super-SoC** | Fully-wired MMIO interconnect linking 4-Core CPU, GPU, Crypto, FB, CLINT, Mailbox | **PASS** |
| **Gen4 Super-NPU AI Engine** | 8x8 Systolic Array matrix dot product, Bias, ReLU AFU, Pooling, Re-Quantizer | **PASS** |

---

## 📁 REPOSITORY STRUCTURE

```
garuda_semesta/
├── gen2/
│   ├── rtl/
│   │   ├── core/         # RV64IM Core Pipeline, ALU, LSU, Regfile, Hazard Unit
│   │   ├── multicore/    # Hart Wrapper, Bus Arbiter, Interconnect, Response Router, 4-Core Top
│   │   ├── memory/       # Shared Main RAM & Boot ROM
│   │   ├── interrupt/    # CLINT (Timer/MSIP) & Hardware Mailbox / Mutex
│   │   ├── gpu/          # Gen3 VPU, Vector Register File, SIMD Vector ALU
│   │   ├── security/     # AES-256 & SHA-256 Crypto Security Engine
│   │   ├── display/      # DMA Framebuffer 24-bit RGB Video Controller
│   │   ├── npu/          # Gen4 NPU 8x8 Systolic Array, AFU, Pooling, Quantizer
│   │   └── soc/          # Gen3 Heterogeneous Super-SoC Top
│   ├── tb/               # Comprehensive Verilog Testbenches
│   ├── tests/            # Automated Python Test Runners & Evidence Validator
│   ├── scripts/          # Latency Regression & OpenLane Synthesis Scripts
│   ├── openlane/         # ASIC Physical Synthesis Configuration (config.json)
│   ├── docs/             # Architecture Specifications (4-Core, RV64IM, AXI4, GPU, NPU)
│   └── reports/          # Formal Release Gate Reports, Manifests & JSON Evidence
└── README.md
```

---

## 🚀 QUICK START & RUNNING TESTS IN DOCKER

To execute the complete multicore and AI simulation suite in Docker:

```bash
# 1. Run Single-Hart Multi-Latency Regression Matrix (20 Configs)
python gen2/scripts/run_latency_tests.py

# 2. Run Adversarial Fault Injection Negative Test Suite (6 Faults)
python gen2/tests/run_negative_tests.py

# 3. Run Hart ID Verification Suite (HID-01 to HID-08)
python gen2/tests/run_hart_id_tests.py

# 4. Run 4-Core Multicore Execution Test
python gen2/tests/run_4core_tests.py

# 5. Run 4-Core Inter-Hart Synchronization Test (CLINT & Mailbox)
python gen2/tests/run_4core_sync_tests.py

# 6. Run Gen3 GPU SIMD & Tensor MAC Verification
python gen2/tests/run_gpu_tests.py

# 7. Run Gen3 Heterogeneous Super-SoC Verification
python gen2/tests/run_gen3_soc_tests.py

# 8. Run Gen4 Super-NPU AI Engine Verification
python gen2/tests/run_npu_tests.py
```

---

## 📜 LICENSE

Licensed under the MIT License. See `LICENSE` for details.
