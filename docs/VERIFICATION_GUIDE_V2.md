# GARUDA SEMESTA — Verification Guide V2

**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  

---

## How to Run All Verification Test Suites

### 1. Master Unit & Integration Test Suite (12 Tests)
```bash
python tests/run_all_unit_and_integration_tests.py
```

### 2. Live Compiler-to-Silicon Vertical Slice Integration Test
```bash
python src/integration/garuda_compiler_vertical_slice.py
```

### 3. RTL Verilog Linter, Elaboration & Cycle Simulator
```bash
python src/verification/garuda_verilog_linter_and_simulator.py
```

### 4. Memory Architecture Subsystem Test
```bash
python src/memory/verify_garuda_memory.py
```

### 5. CPU Core & ISA Conformance Test
```bash
python src/cpu/verify_garuda_cpu_isa.py
```

### 6. NoC Interconnect 3D Mesh Test
```bash
python src/noc/verify_garuda_noc.py
```

### 7. Multi-Chip Hardware Tests (GPU, NPU, SECURE, MCU)
```bash
python src/gpu/verify_garuda_gpu_hardware.py
python src/npu/verify_garuda_npu_hardware.py
python src/secure/verify_garuda_secure_hardware.py
python src/mcu/verify_garuda_mcu_hardware.py
```

### 8. Granular Docker Signoff Pipeline Test
```bash
python garuda_all_chips_docker_test.py
```
