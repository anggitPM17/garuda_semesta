#!/usr/bin/env python3
"""
GARUDA SEMESTA — TITAN V13.1-R3.3 EVIDENCE RECOVERY & SIGN-OFF RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Master Verification Orchestrator with Robust Diagnostics & Fail-Fast:
- STAGE 1: Real Compiler Pipeline (garuda_compiler.py -> program.hex)
- STAGE 2: Real BEQ & JMP Branch Execution Engine (tb_garuda_v125_branch_jump)
- STAGE 3: Interconnect Address Decoder & FSM Test (tb_garuda_v033_interconnect)
- STAGE 4: Synthesizable Bit-Level UART Waveform Test (tb_garuda_v033_uart)
- STAGE 5: CPU LOAD/STORE Transaction Acceptance Test (tb_cpu_load_store_v123)
- STAGE 6: Full SoC Integration Test (tb_garuda_v131_full_soc) - Fails fast if STAGE 5 fails.
- STAGE 7: Truthful Sign-Off JSON & Diagnostic Logs Generation (artifacts/v13.1-r3/)
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

logging.basicConfig(level=logging.INFO, format="[GARUDA V13.1-R3.3 RUNNER] %(levelname)s: %(message)s")

BUILD_DIR = os.path.join(PROJECT_DIR, "build")
V131R3_ARTIFACTS_DIR = os.path.join(PROJECT_DIR, "artifacts", "v13.1-r3")
REPORTS_DIR = os.path.join(V131R3_ARTIFACTS_DIR, "reports")
LOGS_DIR = os.path.join(V131R3_ARTIFACTS_DIR, "logs")

class GarudaV131R33MasterRunner:
    def __init__(self):
        os.makedirs(BUILD_DIR, exist_ok=True)
        os.makedirs(REPORTS_DIR, exist_ok=True)
        os.makedirs(LOGS_DIR, exist_ok=True)

        self.iverilog_path = shutil.which("iverilog")
        if not self.iverilog_path or not os.path.isfile(self.iverilog_path):
            raise RuntimeError("Fatal: 'iverilog' executable not found in system PATH.")

        self.vvp_path = shutil.which("vvp")
        if not self.vvp_path or not os.path.isfile(self.vvp_path):
            raise RuntimeError("Fatal: 'vvp' executable not found in system PATH.")

    def log(self, msg, level="info"):
        if level == "info":
            logging.info(msg)
        elif level == "warning":
            logging.warning(msg)
        elif level == "error":
            logging.error(msg)
        sys.stdout.flush()

    def run_single_tb(self, tb_name, tb_file, rtl_files, pass_marker):
        self.log(f"Compiling testbench '{tb_name}'...")
        out_vvp = os.path.join(BUILD_DIR, f"{tb_name}.vvp")
        cmd_c = [self.iverilog_path, "-g2012", "-Wall", "-s", tb_name, "-o", out_vvp] + rtl_files + [tb_file]
        res_c = subprocess.run(cmd_c, capture_output=True, text=True, cwd=PROJECT_DIR)

        log_path = os.path.join(LOGS_DIR, f"{tb_name}.log")

        if res_c.returncode != 0:
            self.log(f"[{tb_name}] Compilation FAILED:\n{res_c.stderr}", level="error")
            with open(log_path, "w", encoding="utf-8") as f:
                f.write(f"=== COMMAND ===\n{' '.join(cmd_c)}\n=== COMPILATION STDOUT ===\n{res_c.stdout}\n=== COMPILATION STDERR ===\n{res_c.stderr}\n")
            return False, res_c.returncode, "COMPILE_FAIL"

        self.log(f"Simulating '{tb_name}' via VVP...")
        cmd_s = [self.vvp_path, out_vvp]
        start_sim = time.time()
        try:
            res_s = subprocess.run(cmd_s, capture_output=True, text=True, timeout=180, cwd=PROJECT_DIR)
            sim_duration = time.time() - start_sim
        except subprocess.TimeoutExpired as e:
            sim_duration = time.time() - start_sim
            self.log(f"[{tb_name}] Simulation TIMEOUT after 180s!", level="error")
            out_partial = e.stdout.decode('utf-8', errors='ignore') if isinstance(e.stdout, bytes) else (e.stdout or "")
            err_partial = e.stderr.decode('utf-8', errors='ignore') if isinstance(e.stderr, bytes) else (e.stderr or "")
            with open(log_path, "w", encoding="utf-8") as f:
                f.write(f"=== COMMAND ===\n{' '.join(cmd_s)}\n=== TIMEOUT PARTIAL STDOUT ===\n{out_partial}\n=== TIMEOUT PARTIAL STDERR ===\n{err_partial}\n")
            return False, -1, "TIMEOUT"

        with open(log_path, "w", encoding="utf-8") as f:
            f.write(f"=== COMMAND ===\n{' '.join(cmd_s)}\n=== DURATION_SEC ===\n{sim_duration:.3f}\n=== SIMULATION STDOUT ===\n{res_s.stdout}\n=== SIMULATION STDERR ===\n{res_s.stderr}\n")

        passed = (res_s.returncode == 0 and pass_marker in res_s.stdout)
        if passed:
            self.log(f"[{tb_name}] PASSED: Found marker '{pass_marker}'")
            return True, res_s.returncode, "PASS"
        else:
            self.log(f"[{tb_name}] FAILED: Missing marker '{pass_marker}' or nonzero exit code ({res_s.returncode})", level="error")
            return False, res_s.returncode, "FAIL"

    def run_v131_pipeline(self):
        start_t = time.time()
        print("=========================================================================")
        print("GARUDA SEMESTA — TITAN V13.1-R3.3 FAILURE-DRIVEN REPAIR & EVIDENCE RUNNER")
        print("Architect & Author: Anggit Prasetyo Mituhu")
        print("=========================================================================\n")
        sys.stdout.flush()

        self.log("[STAGE 1/7] Compiling Target Assembly Program via garuda_compiler.py...")
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
        ok_branch, code_branch, status_branch = self.run_single_tb("tb_garuda_v125_branch_jump", branch_tb, branch_rtl, "BRANCH_JUMP_ASSERTION_PASS")

        # STAGE 3: Interconnect FSM Test
        interconnect_rtl = [os.path.join(PROJECT_DIR, "src", "chip", "garuda_chip_interconnect.v")]
        interconnect_tb = os.path.join(PROJECT_DIR, "tests", "chip", "tb_garuda_v033_interconnect.v")
        ok_interconnect, code_interconnect, status_interconnect = self.run_single_tb("tb_garuda_v033_interconnect", interconnect_tb, interconnect_rtl, "INTERCONNECT_DECODE_ASSERTION_PASS")

        # STAGE 4: UART Bit-Level Waveform Test
        uart_rtl = [os.path.join(PROJECT_DIR, "src", "peripherals", "garuda_uart.v")]
        uart_tb = os.path.join(PROJECT_DIR, "tests", "peripherals", "tb_garuda_v033_uart.v")
        ok_uart, code_uart, status_uart = self.run_single_tb("tb_garuda_v033_uart", uart_tb, uart_rtl, "UART_WAVEFORM_ASSERTION_PASS")

        # STAGE 5: CPU LOAD/STORE Transaction Acceptance Test
        ls_rtl = [
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
            os.path.join(PROJECT_DIR, "src", "integration", "garuda_vertical_slice_top.v")
        ]
        ls_tb = os.path.join(PROJECT_DIR, "tests", "rtl", "cpu", "tb_cpu_load_store_v123.v")
        ok_ls, code_ls, status_ls = self.run_single_tb("tb_cpu_load_store_v123", ls_tb, ls_rtl, "LOAD_STORE_ASSERTION_PASS")

        # STAGE 6: Full SoC Integration Test (FAIL-FAST: Only run if prerequisite ok_ls passed)
        ok_soc = False
        code_soc = -1
        status_soc = "NOT_RUN"
        if ok_ls:
            soc_rtl = [
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
            soc_tb = os.path.join(PROJECT_DIR, "tests", "v13_1", "tb_garuda_v131_full_soc.v")
            ok_soc, code_soc, status_soc = self.run_single_tb("tb_garuda_v131_full_soc", soc_tb, soc_rtl, "GARUDA_SOC_V131_ASSERTION_PASS")
        else:
            self.log("[STAGE 6/7] FAIL-FAST TRIGGERED: Skipping Full SoC Integration because CPU Load/Store prerequisite failed.", level="warning")

        passed = ok_branch and ok_interconnect and ok_uart and ok_ls and ok_soc
        duration = time.time() - start_t

        report_json = {
            "project": "GARUDA SEMESTA",
            "milestone": "GARUDA TITAN V13.1-R3.3 — EVIDENCE RECOVERY & SIGN-OFF",
            "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "host_environment": sys.platform,
            "overall_status": "PASS" if passed else "FAIL",
            "exit_code": 0 if passed else 1,
            "stage_results": {
                "tb_garuda_v125_branch_jump": status_branch,
                "tb_garuda_v033_interconnect": status_interconnect,
                "tb_garuda_v033_uart": status_uart,
                "tb_cpu_load_store_v123": status_ls,
                "tb_garuda_v131_full_soc": status_soc
            },
            "assertions_verified": [
                "BRANCH_JUMP_ASSERTION_PASS" if ok_branch else None,
                "INTERCONNECT_DECODE_ASSERTION_PASS" if ok_interconnect else None,
                "UART_WAVEFORM_ASSERTION_PASS" if ok_uart else None,
                "LOAD_STORE_ASSERTION_PASS" if ok_ls else None,
                "GARUDA_SOC_V131_ASSERTION_PASS" if ok_soc else None
            ],
            "duration_seconds": round(duration, 3)
        }
        report_json["assertions_verified"] = [a for a in report_json["assertions_verified"] if a is not None]

        with open(os.path.join(REPORTS_DIR, "final_signoff.json"), "w", encoding="utf-8") as f:
            json.dump(report_json, f, indent=2)

        print("\n=========================================================================")
        print(f" GARUDA V13.1-R3.3 MASTER RUNNER STATUS: {'PASS' if passed else 'FAIL'} (Exit Code: {0 if passed else 1})")
        print("=========================================================================\n")
        sys.stdout.flush()

        return passed

if __name__ == "__main__":
    runner = GarudaV131R33MasterRunner()
    success = runner.run_v131_pipeline()
    sys.exit(0 if success else 1)
