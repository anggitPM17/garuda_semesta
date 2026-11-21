#!/usr/bin/env python3
"""
GARUDA SEMESTA — Master 5-Chip Signoff Verifier (V2.4.6-R1 RECOVERY)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Enforced Granular Verification Suite (Removes False PASS):
- Executes real EDA tools (iverilog, verilator) via subprocess.
- Eliminates fake python:3.11-slim container 'print("PASS")' bypasses.
- Requires explicit RTL compilation for each target chip.
- Flags unimplemented testbenches as NOT_VERIFIED.
"""

import os
import sys
import subprocess
import time
import json

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
REPORT_PATH = os.path.join(PROJECT_DIR, "docs", "GARUDA_5_Chip_Master_Docker_Report.md")
JSON_REPORT_PATH = os.path.join(PROJECT_DIR, "artifacts", "v2.4.6-r1", "five_chip_report.json")

# Define target chips. Right now only CPU has a full vertical slice verified in V2.4.6-R1
CHIPS = [
    {
        "name": "GARUDA CPU SoC v12.4.6",
        "top": "garuda_vertical_slice_top",
        "verilog_files": [
            "src/memory/garuda_bus_adapter_64to32.v",
            "src/memory/garuda_l1_icache.v",
            "src/memory/garuda_l1_dcache.v",
            "src/memory/garuda_l2_cache.v",
            "src/memory/garuda_memory_arbiter.v",
            "src/memory/garuda_memory_controller.v",
            "src/memory/garuda_memory_subsystem_top.v",
            "src/cpu/garuda_pc.v",
            "src/cpu/garuda_idecode.v",
            "src/cpu/garuda_regfile.v",
            "src/cpu/garuda_alu.v",
            "src/cpu/garuda_cpu_pipeline_top.v",
            "src/integration/garuda_vertical_slice_top.v"
        ],
        "testbench": "src/integration/tb_garuda_vertical_slice_v24_6.v"
    },
    {
        "name": "GARUDA GPU v1.0",
        "top": "garuda_gpu_top",
        "verilog_files": ["src/gpu/garuda_gpu_shader_simd.v", "src/gpu/garuda_gpu_bvh_raytracer.v"],
        "testbench": None
    },
    {
        "name": "GARUDA NPU v1.0",
        "top": "garuda_npu_top",
        "verilog_files": ["src/npu/garuda_npu_systolic_array.v"],
        "testbench": None
    },
    {
        "name": "GARUDA SECURE v1.0",
        "top": "garuda_secure_top",
        "verilog_files": ["src/secure/garuda_secure_crypto_engine.v"],
        "testbench": None
    },
    {
        "name": "GARUDA MCU v1.0",
        "top": "garuda_mcu_top",
        "verilog_files": ["src/mcu/garuda_mcu_peripherals.v"],
        "testbench": None
    }
]

def run_real_verification():
    print("=========================================================================")
    print("GARUDA SEMESTA — REAL DOCKER-NATIVE 5-CHIP SIGNOFF VERIFIER v12.4.6-R1")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    os.makedirs(os.path.join(PROJECT_DIR, "build"), exist_ok=True)
    os.makedirs(os.path.dirname(JSON_REPORT_PATH), exist_ok=True)

    results = []
    all_passed = True

    for idx, chip in enumerate(CHIPS, 1):
        print(f"[{idx}/5] Verifying {chip['name']} (Top: {chip['top']})...")

        # Check if RTL source files actually exist
        missing_files = [f for f in chip['verilog_files'] if not os.path.exists(os.path.join(PROJECT_DIR, f))]

        if missing_files:
            print(f"  -> BLOCKED: Missing RTL sources: {missing_files}")
            results.append((chip['name'], chip['top'], "BLOCKED"))
            all_passed = False
            continue

        if chip['testbench'] is None or not os.path.exists(os.path.join(PROJECT_DIR, str(chip['testbench']))):
            print(f"  -> NOT_VERIFIED: No testbench available for {chip['top']}")
            results.append((chip['name'], chip['top'], "NOT_VERIFIED"))
            all_passed = False
            continue

        # Compile with Icarus Verilog
        out_vvp = os.path.join(PROJECT_DIR, "build", f"{chip['top']}.vvp")
        compile_cmd = ["iverilog", "-g2012", "-Wall", "-s", "tb_garuda_vertical_slice_v24_6", "-o", out_vvp] + chip['verilog_files'] + [chip['testbench']]

        print(f"  -> Compiling RTL via Icarus Verilog...")
        res_compile = subprocess.run(compile_cmd, capture_output=True, text=True, cwd=PROJECT_DIR)

        if res_compile.returncode != 0:
            print(f"  -> FAILED: Compilation Error\n{res_compile.stderr}")
            results.append((chip['name'], chip['top'], "FAILED_COMPILE"))
            all_passed = False
            continue

        # Simulate with VVP
        print(f"  -> Executing Simulation via VVP...")
        res_sim = subprocess.run(["vvp", out_vvp], capture_output=True, text=True, cwd=PROJECT_DIR, timeout=30)

        if res_sim.returncode == 0 and "FATAL" not in res_sim.stdout.upper() and "FAIL" not in res_sim.stdout.upper():
            print(f"  -> PASS: Execution Verified successfully!")
            results.append((chip['name'], chip['top'], "RTL_SIMULATED_PASS"))
        else:
            print(f"  -> FAILED: Simulation Errors Detected\n{res_sim.stdout}\n{res_sim.stderr}")
            results.append((chip['name'], chip['top'], "FAILED_SIMULATION"))
            all_passed = False

    generate_master_report(results)

    with open(JSON_REPORT_PATH, "w") as f:
        json.dump({"milestone": "V2.4.6-R1", "status": "PASS" if all_passed else "INCOMPLETE", "results": results}, f, indent=2)

    sys.exit(0 if all_passed else 1)

def generate_master_report(results):
    report_md = f"""# GARUDA SEMESTA — Master 5-Chip Verification Report

**Document Revision**: 12.4.6-R1-REAL-RTL-ENFORCED
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**
**License**: Apache License 2.0 (Copyright © 2026 Anggit Prasetyo Mituhu)
**Verification Date**: {time.strftime('%Y-%m-%d %H:%M:%S')}

---

## 1. 5-Chip Master Signoff Matrix

*Note: In V2.4.6-R1, false PASS states have been eliminated. Only chips with real testbenches and execution proofs are marked PASS.*

| Chip # | Chip Name & Domain | Top Verilog Module | V2.4.6-R1 Actual Status |
| :---: | :--- | :--- | :---: |
"""
    for idx, r in enumerate(results, 1):
        report_md += f"| **{idx}** | **{r[0]}** | `{r[1]}` | **{r[2]}** |\n"

    report_md += "\n---\n\n## 2. Note on Physical Design Signoff\n"
    report_md += "Claims regarding 3.5 GHz OpenLane signoff are downgraded to **TARGET_ONLY** until an automated OpenROAD flow is definitively reproduced and included in this test suite with physical DRC/LVS artifacts.\n"

    os.makedirs(os.path.dirname(REPORT_PATH), exist_ok=True)
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write(report_md)
    print(f"\n[MASTER REPORT SAVED] Saved to {REPORT_PATH}")

if __name__ == "__main__":
    run_real_verification()
