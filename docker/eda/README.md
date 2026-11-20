# GARUDA SEMESTA — Official EDA Workstation Docker Container Guide V2.4.0

**Document Revision**: 12.4.0-DOCKER-EDA  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Overview

The **GARUDA EDA Workstation Container** provides a 100% reproducible hardware engineering environment for compiling Verilog RTL, running `vvp` simulations, generating VCD waveforms, and executing the GARUDA compiler toolchain across Windows, Linux, and macOS hosts.

---

## 2. Docker Build & Execution Commands

### A. Build Image (PowerShell & Bash)
```powershell
docker build -t garuda-eda:v2.4.0 -f docker/eda/Dockerfile .
```

### B. Run Real RTL Verification Runner inside Container (Windows PowerShell)
```powershell
docker run --rm -v "${PWD}:/workspace" -w /workspace garuda-eda:v2.4.0 python3 src/verification/garuda_real_rtl_runner.py
```

### C. Run Real RTL Verification Runner inside Container (Git Bash / Linux)
```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace garuda-eda:v2.4.0 python3 src/verification/garuda_real_rtl_runner.py
```

### D. Compile & Execute Verilog RTL Directly inside Container
```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace garuda-eda:v2.4.0 bash -c "\
  mkdir -p build && \
  iverilog -g2012 -Wall -s tb_garuda_vertical_slice_v23_2 -o build/garuda_vertical_slice.vvp \
    src/memory/*.v src/cpu/*.v src/integration/*.v && \
  vvp build/garuda_vertical_slice.vvp"
```
