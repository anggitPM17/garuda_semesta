#!/usr/bin/env python3
"""
GARUDA SEMESTA — CHIP V0.3 TRUE SOC INTEGRATION RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Verifies True SoC Chip Top-Level Integration (garuda_semesta_chip_top.v):
- STAGE 1: Real Compiler Pipeline (garuda_compiler.py -> program.hex)
- STAGE 2: Active SoC Chip Compilation (iverilog -g2012)
- STAGE 3: Active SoC Chip Testbench Execution (tb_garuda_semesta_chip_v03)
- STAGE 4: Evidence Report Generation (artifacts/v12.3-r2/)
"""

import sys
import os
import shutil
import subprocess
import time
import json
import logging

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from src.verification.garuda_compiler_pipeline import run_garuda_compiler_pipeline

logging.basicConfig(level=logging.INFO, format="[GARUDA CHIP V0.3 RUNNER] %(levelname)s: %(message)s")

BUILD_DIR = os.path.join(PROJECT_DIR, "build")
V03_ARTIFACTS_DIR = os.path.join(PROJECT_DIR, "artifacts", "v12.3-r2")
REPORTS_DIR = os.path.join(V03_ARTIFACTS_DIR, "reports")
LOGS_DIR = os.path.join(V03_ARTIFACTS_DIR, "logs")

class GarudaV03SocRunner:
    def __init__(self):
        os.makedirs(BUILD_DIR, exist_ok=True)
        os.makedirs(REPORTS_DIR, exist_ok=True)
        os.makedirs(LOGS_DIR, exist_ok=True)

        self.iverilog_path = shutil.which("iverilog")
        self.vvp_path = shutil.which("vvp")

    def log(self, msg, level="info"):
        if level == "info":
            logging.info(msg)
        elif level == "error":
            logging.error(msg)
        sys.stdout.flush()

    def run_chip_v03_pipeline(self):
        start_t = time.time()
        print("=========================================================================")
        print("GARUDA SEMESTA — CHIP V0.3 TRUE SOC INTEGRATION RUNNER")
        print("Architect & Author: Anggit Prasetyo Mituhu")
        print("=========================================================================\n")
        sys.stdout.flush()

        self.log("[STAGE 1/4] Compiling Target Assembly Program via garuda_compiler.py...")
        ok_compiler, hex_sha256, inst_count = run_garuda_compiler_pipeline()
        if not ok_compiler:
            self.log("Compiler pipeline failed!", level="error")
            return False

        chip_rtl_files = [
            os.path.join(PROJECT_DIR, "src", "peripherals", "garuda_interrupt_controller.v"),
            os.path.join(PROJECT_DIR, "src", "peripherals", "garuda_timer.v"),
            os.path.join(PROJECT_DIR, "src", "peripherals", "garuda_uart.v"),
            os.path.join(PROJECT_DIR, "src", "chip", "garuda_chip_interconnect.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_bus_adapter_64to32.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_l1_icache.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_l1_dcache.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_l2_cache.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_memory_arbiter.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_memory_controller.v"),
            os.path.join(PROJECT_DIR, "src", "memory", "garuda_memory_subsystem_top.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_pc.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_idecode.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_regfile.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_alu.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_cpu_pipeline_top.v"),
            os.path.join(PROJECT_DIR, "src", "chip", "garuda_semesta_chip_top.v")
        ]

        tb_file = os.path.join(PROJECT_DIR, "tests", "chip", "tb_garuda_semesta_chip_v03.v")
        out_vvp = os.path.join(BUILD_DIR, "tb_garuda_semesta_chip_v03.vvp")

        self.log("[STAGE 2/4] Compiling True SoC Chip Top RTL (garuda_semesta_chip_top.v)...")
        cmd_c = [self.iverilog_path, "-g2012", "-Wall", "-s", "tb_garuda_semesta_chip_v03", "-o", out_vvp] + chip_rtl_files + [tb_file]
        res_c = subprocess.run(cmd_c, capture_output=True, text=True, cwd=PROJECT_DIR)

        if res_c.returncode != 0:
            self.log(f"Compilation FAILED:\n{res_c.stderr}", level="error")
            return False

        self.log("[STAGE 3/4] Simulating True SoC Chip Top via VVP...")
        cmd_s = [self.vvp_path, out_vvp]
        try:
            res_s = subprocess.run(cmd_s, capture_output=True, text=True, timeout=180, cwd=PROJECT_DIR)
        except subprocess.TimeoutExpired:
            self.log("Simulation TIMEOUT after 180s!", level="error")
            return False

        log_path = os.path.join(LOGS_DIR, "tb_garuda_semesta_chip_v03.log")
        with open(log_path, "w", encoding="utf-8") as f:
            f.write(res_s.stdout + "\n" + res_s.stderr)

        passed = (res_s.returncode == 0 and "GARUDA_CHIP_V03_ASSERTION_PASS" in res_s.stdout)

        duration = time.time() - start_t
        report_json = {
            "project": "GARUDA SEMESTA",
            "milestone": "GARUDA SEMESTA CHIP V0.3 — TRUE SOC INTEGRATION",
            "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "host_environment": sys.platform,
            "overall_status": "PASS" if passed else "FAIL",
            "exit_code": 0 if passed else 1,
            "assertions_verified": [
                "r1 == 150",
                "r2 == 350",
                "r3 == 500",
                "SRAM[0x80000100] == 500 (STORE)",
                "r4 == 500 (LOADED from SRAM)",
                "r5 == 650 (r4 + r1)",
                "DMA Readback SRAM[0x80000100] == 500",
                "Active Interconnect Routing to Peripherals",
                "MMIO Interrupt Controller, Timer, UART Active Wiring"
            ],
            "duration_seconds": round(duration, 3)
        }

        with open(os.path.join(REPORTS_DIR, "v123_r2_execution_report.json"), "w", encoding="utf-8") as f:
            json.dump(report_json, f, indent=2)

        print("\n=========================================================================")
        print(f" GARUDA CHIP V0.3 RUNNER STATUS: {'PASS' if passed else 'FAIL'} (Exit Code: {0 if passed else 1})")
        print("=========================================================================\n")
        sys.stdout.flush()

        return passed

if __name__ == "__main__":
    runner = GarudaV03SocRunner()
    success = runner.run_chip_v03_pipeline()
    sys.exit(0 if success else 1)
