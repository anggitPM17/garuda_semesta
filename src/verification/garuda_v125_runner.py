#!/usr/bin/env python3
"""
GARUDA SEMESTA — TITAN V12.5 COMPLETE CPU EXECUTION ENGINE RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Verifies Complete TITAN V12.5 CPU Core Execution Engine:
- STAGE 1: Real Compiler Pipeline (garuda_compiler.py -> program.hex)
- STAGE 2: Branch & Jump Engine Test (tb_garuda_v125_branch_jump)
- STAGE 3: MMIO Interconnect Decoding Test (tb_garuda_v033_interconnect)
- STAGE 4: MMIO UART Serial Waveform Test (tb_garuda_v033_uart)
- STAGE 5: Full SoC Chip Top Test (tb_garuda_semesta_chip_v031)
- STAGE 6: Master Execution Report Generation (artifacts/v12.5/)
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

logging.basicConfig(level=logging.INFO, format="[GARUDA TITAN V12.5 RUNNER] %(levelname)s: %(message)s")

BUILD_DIR = os.path.join(PROJECT_DIR, "build")
V125_ARTIFACTS_DIR = os.path.join(PROJECT_DIR, "artifacts", "v12.5")
REPORTS_DIR = os.path.join(V125_ARTIFACTS_DIR, "reports")
LOGS_DIR = os.path.join(V125_ARTIFACTS_DIR, "logs")

class GarudaV125Runner:
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

    def run_single_tb(self, tb_name, tb_file, rtl_files, pass_marker):
        self.log(f"Compiling testbench '{tb_name}'...")
        out_vvp = os.path.join(BUILD_DIR, f"{tb_name}.vvp")
        cmd_c = [self.iverilog_path, "-g2012", "-Wall", "-s", tb_name, "-o", out_vvp] + rtl_files + [tb_file]
        res_c = subprocess.run(cmd_c, capture_output=True, text=True, cwd=PROJECT_DIR)

        if res_c.returncode != 0:
            self.log(f"[{tb_name}] Compilation FAILED:\n{res_c.stderr}", level="error")
            return False

        self.log(f"Simulating '{tb_name}' via VVP...")
        cmd_s = [self.vvp_path, out_vvp]
        try:
            res_s = subprocess.run(cmd_s, capture_output=True, text=True, timeout=120, cwd=PROJECT_DIR)
        except subprocess.TimeoutExpired:
            self.log(f"[{tb_name}] Simulation TIMEOUT after 120s!", level="error")
            return False

        log_path = os.path.join(LOGS_DIR, f"{tb_name}.log")
        with open(log_path, "w", encoding="utf-8") as f:
            f.write(res_s.stdout + "\n" + res_s.stderr)

        passed = (res_s.returncode == 0 and pass_marker in res_s.stdout)
        if passed:
            self.log(f"[{tb_name}] PASSED: Found marker '{pass_marker}'")
        else:
            self.log(f"[{tb_name}] FAILED: Missing marker '{pass_marker}'", level="error")

        return passed

    def run_v125_pipeline(self):
        start_t = time.time()
        print("=========================================================================")
        print("GARUDA SEMESTA — TITAN V12.5 COMPLETE CPU EXECUTION RUNNER")
        print("Architect & Author: Anggit Prasetyo Mituhu")
        print("=========================================================================\n")
        sys.stdout.flush()

        self.log("[STAGE 1/5] Compiling Target Assembly Program via garuda_compiler.py...")
        ok_compiler, hex_sha256, inst_count = run_garuda_compiler_pipeline()
        if not ok_compiler:
            self.log("Compiler pipeline failed!", level="error")
            return False

        # STAGE 2: Branch & Jump Test
        branch_rtl = [
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_pc.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_idecode.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_regfile.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_alu.v"),
            os.path.join(PROJECT_DIR, "src", "cpu", "garuda_cpu_pipeline_top.v")
        ]
        branch_tb = os.path.join(PROJECT_DIR, "tests", "cpu", "tb_garuda_v125_branch_jump.v")
        ok_branch = self.run_single_tb("tb_garuda_v125_branch_jump", branch_tb, branch_rtl, "BRANCH_JUMP_ASSERTION_PASS")

        # STAGE 3: Interconnect Test
        interconnect_rtl = [os.path.join(PROJECT_DIR, "src", "chip", "garuda_chip_interconnect.v")]
        interconnect_tb = os.path.join(PROJECT_DIR, "tests", "chip", "tb_garuda_v033_interconnect.v")
        ok_interconnect = self.run_single_tb("tb_garuda_v033_interconnect", interconnect_tb, interconnect_rtl, "INTERCONNECT_DECODE_ASSERTION_PASS")

        # STAGE 4: UART Serial Waveform Test
        uart_rtl = [os.path.join(PROJECT_DIR, "src", "peripherals", "garuda_uart.v")]
        uart_tb = os.path.join(PROJECT_DIR, "tests", "peripherals", "tb_garuda_v033_uart.v")
        ok_uart = self.run_single_tb("tb_garuda_v033_uart", uart_tb, uart_rtl, "UART_WAVEFORM_ASSERTION_PASS")

        # STAGE 5: Full SoC Chip Top Test
        chip_rtl = [
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
        chip_tb = os.path.join(PROJECT_DIR, "tests", "chip", "tb_garuda_semesta_chip_v031.v")
        ok_chip = self.run_single_tb("tb_garuda_semesta_chip_v031", chip_tb, chip_rtl, "GARUDA_CHIP_V031_ASSERTION_PASS")

        passed = ok_branch and ok_interconnect and ok_uart and ok_chip
        duration = time.time() - start_t

        report_json = {
            "project": "GARUDA SEMESTA",
            "milestone": "GARUDA TITAN V12.5 — COMPLETE CPU EXECUTION ENGINE",
            "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "host_environment": sys.platform,
            "overall_status": "PASS" if passed else "FAIL",
            "exit_code": 0 if passed else 1,
            "stage_results": {
                "tb_garuda_v125_branch_jump": "PASS" if ok_branch else "FAIL",
                "tb_garuda_v033_interconnect": "PASS" if ok_interconnect else "FAIL",
                "tb_garuda_v033_uart": "PASS" if ok_uart else "FAIL",
                "tb_garuda_semesta_chip_v031": "PASS" if ok_chip else "FAIL"
            },
            "duration_seconds": round(duration, 3)
        }

        with open(os.path.join(REPORTS_DIR, "titan_v125_execution_report.json"), "w", encoding="utf-8") as f:
            json.dump(report_json, f, indent=2)

        print("\n=========================================================================")
        print(f" GARUDA TITAN V12.5 RUNNER STATUS: {'PASS' if passed else 'FAIL'} (Exit Code: {0 if passed else 1})")
        print("=========================================================================\n")
        sys.stdout.flush()

        return passed

if __name__ == "__main__":
    runner = GarudaV125Runner()
    success = runner.run_v125_pipeline()
    sys.exit(0 if success else 1)
