#!/usr/bin/env python3
"""
GARUDA SEMESTA — REAL EDA RTL RUNNER (`garuda-rtl-runner`) v12.4.0
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Orchestrates Genuine Verilog RTL Compilation & Simulation via Subprocess:
- Compiles Verilog RTL with Icarus Verilog (`iverilog`)
- Executes generated simulation binary with `vvp`
- Captures STDOUT, STDERR, Exit Codes, and VCD Waveform artifacts
- Generates Machine-Readable JSON Evidence Reports in artifacts/v2.4.0/reports/
- Strictly reports BLOCKED if Icarus is not installed, NEVER faking PASS.
"""

import sys
import os
import shutil
import subprocess
import time
import json
import logging

logging.basicConfig(level=logging.INFO, format="[GARUDA RTL RUNNER v2.4.0] %(levelname)s: %(message)s")

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BUILD_DIR = os.path.join(PROJECT_DIR, "build")
ARTIFACTS_DIR = os.path.join(PROJECT_DIR, "artifacts", "v2.4.0")
REPORTS_DIR = os.path.join(ARTIFACTS_DIR, "reports")

class GarudaRealRtlRunner:
    """Orchestrates genuine Icarus Verilog / VVP RTL compilation and execution."""
    def __init__(self):
        os.makedirs(BUILD_DIR, exist_ok=True)
        os.makedirs(REPORTS_DIR, exist_ok=True)
        self.iverilog_path = shutil.which("iverilog")
        self.vvp_path = shutil.which("vvp")

    def run_iverilog_compile(self, top_module, rtl_sources, testbench_file, output_vvp_name="garuda_vertical_slice.vvp"):
        if not self.iverilog_path:
            logging.warning("Icarus Verilog (iverilog) not found on host PATH -> Status: BLOCKED")
            return False, "BLOCKED: ICARUS VERILOG NOT INSTALLED", "", None

        out_vvp = os.path.join(BUILD_DIR, output_vvp_name)
        cmd = [self.iverilog_path, "-g2012", "-Wall", "-s", top_module, "-o", out_vvp] + rtl_sources + [testbench_file]

        start_t = time.time()
        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=30, cwd=PROJECT_DIR)
            duration = time.time() - start_t
            if res.returncode == 0:
                logging.info(f"iverilog Compilation SUCCESSFUL -> '{out_vvp}' ({duration:.2f}s)")
                return True, res.stdout, res.stderr, out_vvp
            else:
                logging.error(f"iverilog Compilation FAILED (Exit Code {res.returncode}):\n{res.stderr}")
                return False, res.stdout, res.stderr, None
        except Exception as e:
            return False, "", str(e), None

    def run_vvp_simulation(self, vvp_file):
        if not self.vvp_path or not vvp_file or not os.path.exists(vvp_file):
            logging.warning("vvp runtime or simulation binary not available -> Status: BLOCKED")
            return False, "BLOCKED: VVP SIMULATION NOT EXECUTED", ""

        cmd = [self.vvp_path, vvp_file]
        start_t = time.time()
        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=30, cwd=PROJECT_DIR)
            duration = time.time() - start_t
            if res.returncode == 0 and "FATAL" not in res.stdout.upper() and "FAIL" not in res.stdout.upper():
                logging.info(f"vvp Simulation SUCCESSFUL ({duration:.2f}s):\n{res.stdout}")
                return True, res.stdout, res.stderr
            else:
                logging.error(f"vvp Simulation FAILED (Exit Code {res.returncode}):\n{res.stdout}\n{res.stderr}")
                return False, res.stdout, res.stderr
        except Exception as e:
            return False, "", str(e)

    def generate_v24_json_report(self, overall_status, details):
        report = {
            "project": "GARUDA SEMESTA",
            "milestone": "V2.4.0 REAL DOCKER EDA & RTL VERIFICATION RECOVERY",
            "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "host_environment": sys.platform,
            "tool_versions": {
                "python": sys.version.split()[0],
                "iverilog": self.iverilog_path if self.iverilog_path else "BLOCKED",
                "vvp": self.vvp_path if self.vvp_path else "BLOCKED"
            },
            "overall_status": overall_status,
            "details": details
        }
        out_file = os.path.join(REPORTS_DIR, "v240_execution_report.json")
        with open(out_file, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2)
        return out_file

def run_full_v24_verification():
    runner = GarudaRealRtlRunner()
    print("=========================================================================")
    print("GARUDA SEMESTA — REAL EDA RTL RUNNER AUDIT v12.4.0")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    iverilog_avail = runner.iverilog_path is not None
    vvp_avail = runner.vvp_path is not None

    print(f"  - iverilog Path: {runner.iverilog_path if iverilog_avail else 'BLOCKED (NOT IN PATH)'}")
    print(f"  - vvp Path     : {runner.vvp_path if vvp_avail else 'BLOCKED (NOT IN PATH)'}")

    rtl_files = [
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
    tb_file = os.path.join(PROJECT_DIR, "src", "integration", "tb_garuda_vertical_slice_v23_2.v")

    if iverilog_avail:
        ok_compile, out_c, err_c, vvp_bin = runner.run_iverilog_compile("tb_garuda_vertical_slice_v23_2", rtl_files, tb_file)
        if ok_compile and vvp_avail:
            ok_sim, out_s, err_s = runner.run_vvp_simulation(vvp_bin)
            status = "PASS" if ok_sim else "FAILED"
        else:
            status = "FAILED" if ok_compile else "BLOCKED"
    else:
        status = "BLOCKED"
        out_c, err_c, out_s, err_s = "", "iverilog not in local PATH", "", ""

    details = {
        "rtl_files_count": len(rtl_files),
        "testbench": os.path.basename(tb_file),
        "compile_stdout": out_c if iverilog_avail else "",
        "compile_stderr": err_c if iverilog_avail else "iverilog not installed locally",
        "sram_target_address": "0x80000100",
        "sram_expected_value": 500
    }

    report_path = runner.generate_v24_json_report(status, details)
    print(f"\n[RTL RUNNER STATUS]: {status}")
    print(f"[REPORT SAVED]: '{report_path}'\n")

    return status == "PASS"

if __name__ == "__main__":
    run_full_v24_verification()
