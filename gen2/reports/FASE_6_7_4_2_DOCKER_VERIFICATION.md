# GARUDA SEMESTA GEN2 — FASE 6.7.4.2 DOCKER VERIFICATION REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Container Image:** `garuda-goldenway:v1.0`  

---

## 1. DOCKER EDA ENVIRONMENT & TOOL VERSIONS

- **Docker Container:** `garuda-goldenway:v1.0`
- **Mount Path:** `-v "D:/richat/gen2:/workspace"`
- **Icarus Verilog:** `Icarus Verilog version 12.0 (stable)`
- **VVP Simulator:** `Icarus Verilog vvp version 12.0`
- **Python Engine:** `Python 3.11.16`

---

## 2. REGRESSION EXECUTION COMMAND

```bash
docker run --rm -v "D:/richat/gen2:/workspace" garuda-goldenway:v1.0 python -u /workspace/scripts/run_latency_tests.py
```

- **Exit Status:** `0`
- **Configurations Executed:** 20 / 20 PASSED
- **Negative Test Executions:** 6 / 6 PASSED
