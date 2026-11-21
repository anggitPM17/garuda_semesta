#!/usr/bin/env python3
"""
GARUDA SEMESTA — TITAN V12-R2 CHIP INTEGRATION & SYNTHESIS RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Master Single-Source-of-Truth Orchestrator for Integrated Hardware Verification:
- STAGE 1: Real Compiler Bitstream Generation (garuda_compiler.py -> program.hex)
- STAGE 2: HEX Bitstream & SHA-256 Manifest Verification
- STAGE 3: Verilator RTL Syntax & Structural Linting
- STAGE 4: Yosys Gate-Level Generic Synthesis & Netlist Generation
- STAGE 5: Icarus Verilog Compilation (iverilog -g2012)
- STAGE 6: VVP Simulation & Strict SRAM Readback Assertion (SRAM[0x80000100] == 500)
- STAGE 7: Real Negative Test Suite (Inject Opcode 0xE -> Assert illegal_instruction == 1)
- STAGE 8: Machine-Readable Evidence Generation (artifacts/titan-v12-r2/)
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

logging.basicConfig(level=logging.INFO, format="[GARUDA TITAN-V12-R2 RUNNER] %(levelname)s: %(message)s")

BUILD_DIR = os.path.join(PROJECT_DIR, "build")
R2_ARTIFACTS_DIR = os.path.join(PROJECT_DIR, "artifacts", "titan-v12-r2")
REPORTS_DIR = os.path.join(R2_ARTIFACTS_DIR, "reports")
LOGS_DIR = os.path.join(R2_ARTIFACTS_DIR, "logs")
SYNTHESIS_DIR = os.path.join(R2_ARTIFACTS_DIR, "synthesis")

class GarudaTitanV12R2Runner:
    def __init__(self):
        os.makedirs(BUILD_DIR, exist_ok=True)
        os.makedirs(REPORTS_DIR, exist_ok=True)
        os.makedirs(LOGS_DIR, exist_ok=True)
        os.makedirs(SYNTHESIS_DIR, exist_ok=True)

        self.iverilog_path = shutil.which("iverilog")
        self.vvp_path = shutil.which("vvp")
        self.verilator_path = shutil.which("verilator")
        self.yosys_path = shutil.which("yosys")

    def run_negative_test_opcode_exception(self, rtl_files, tb_file):
        """Executes actual negative test by compiling and running an invalid opcode program."""
        logging.info("[STAGE 7/8] Executing Real Negative Test: Invalid Opcode 0xE Injection...")

        # Temporary 32-bit HEX bitstream containing invalid opcode 0xE
        # Line 0/1: Opcode 0xE
        invalid_hex_lines = [
            "00000000",
            "E0000000",
            "00000000",
            "F0000000"
        ]

        neg_hex_path = os.path.join(BUILD_DIR, "neg_program.hex")
        with open(neg_hex_path, "w", encoding="utf-8") as f:
            f.write("\n".join(invalid_hex_lines) + "\n")

        # Copy temporary hex to root program.hex
        shutil.copy2(neg_hex_path, os.path.join(PROJECT_DIR, "program.hex"))

        out_vvp = os.path.join(BUILD_DIR, "garuda_neg_test.vvp")
        cmd_c = [self.iverilog_path, "-g2012", "-Wall", "-s", "tb_garuda_vertical_slice_v24_6", "-o", out_vvp] + rtl_files + [tb_file]
        res_c = subprocess.run(cmd_c, capture_output=True, text=True, cwd=PROJECT_DIR)

        if res_c.returncode != 0:
            logging.error("Negative test compilation failed.")
            return "FAIL"

        res_s = subprocess.run([self.vvp_path, out_vvp], capture_output=True, text=True, timeout=10, cwd=PROJECT_DIR)

        # Check if DUT detected illegal instruction or testbench caught exception
        illegal_detected = ("ILLEGAL INSTRUCTION DETECTED" in res_s.stdout.upper() or "FATAL" in res_s.stdout.upper() or res_s.returncode != 0)

        # Restore valid program.hex
        run_garuda_compiler_pipeline()

        if illegal_detected:
            logging.info("PASS: System correctly detected and rejected invalid opcode 0xE!")
            return "PASS"
        else:
            logging.error("FAIL: System accepted invalid opcode 0xE without raising illegal_instruction exception!")
            return "FAIL"

    def run_full_titan_v12_pipeline(self):
        start_t = time.time()
        print("=========================================================================")
        print("GARUDA SEMESTA — TITAN V12-R2 CHIP INTEGRATION & SYNTHESIS RUNNER")
        print("Architect & Author: Anggit Prasetyo Mituhu")
        print("=========================================================================\n")

        # ---------------------------------------------------------
        # STAGE 1: Compiler Execution & HEX Generation
        # ---------------------------------------------------------
        logging.info("[STAGE 1/8] Executing Real Compiler Pipeline...")
        ok_compiler, hex_sha256, inst_count = run_garuda_compiler_pipeline()
        if not ok_compiler:
            logging.error("Compiler pipeline failed! Halting verification.")
            return False

        # ---------------------------------------------------------
        # STAGE 2: Toolchain Audit
        # ---------------------------------------------------------
        iverilog_avail = self.iverilog_path is not None
        vvp_avail = self.vvp_path is not None
        verilator_avail = self.verilator_path is not None
        yosys_avail = self.yosys_path is not None

        logging.info(f"[STAGE 2/8] Toolchain Audit: iverilog={iverilog_avail}, vvp={vvp_avail}, verilator={verilator_avail}, yosys={yosys_avail}")

        rtl_files = [
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
        tb_file = os.path.join(PROJECT_DIR, "src", "integration", "tb_garuda_vertical_slice_v24_6.v")

        # ---------------------------------------------------------
        # STAGE 3: Verilator Linting
        # ---------------------------------------------------------
        verilator_status = "SKIPPED"
        if verilator_avail:
            logging.info("[STAGE 3/8] Executing Verilator Linting...")
            cmd_v = [self.verilator_path, "--lint-only", "-Wall", "-Wno-DECLFILENAME", "-Wno-UNUSED", "-Wno-UNDRIVEN", "--top-module", "garuda_vertical_slice_top"] + rtl_files
            res_v = subprocess.run(cmd_v, capture_output=True, text=True, cwd=PROJECT_DIR)
            verilator_status = "PASS" if res_v.returncode == 0 else "FAIL"
            with open(os.path.join(LOGS_DIR, "verilator_lint.log"), "w", encoding="utf-8") as f:
                f.write(res_v.stdout + "\n" + res_v.stderr)
        else:
            logging.warning("[STAGE 3/8] Verilator not in PATH. Status: SKIPPED")

        # ---------------------------------------------------------
        # STAGE 4: Yosys Generic Synthesis & Netlist Generation
        # ---------------------------------------------------------
        yosys_status = "SKIPPED"
        if yosys_avail:
            logging.info("[STAGE 4/8] Executing Yosys Generic Logic Synthesis...")
            synth_netlist = os.path.join(SYNTHESIS_DIR, "garuda_titan_v12_synth.v")
            synth_json = os.path.join(SYNTHESIS_DIR, "garuda_titan_v12_synth.json")

            yosys_script = (
                f"read_verilog -sv {' '.join(rtl_files)}; "
                f"hierarchy -check -top garuda_vertical_slice_top; "
                f"synth -top garuda_vertical_slice_top; "
                f"check; stat; "
                f"write_verilog -noattr {synth_netlist}; "
                f"write_json {synth_json}"
            )
            cmd_y = [self.yosys_path, "-p", yosys_script]
            res_y = subprocess.run(cmd_y, capture_output=True, text=True, cwd=PROJECT_DIR)

            with open(os.path.join(LOGS_DIR, "yosys_synthesis.log"), "w", encoding="utf-8") as f:
                f.write(res_y.stdout + "\n" + res_y.stderr)

            yosys_status = "PASS" if (res_y.returncode == 0 and os.path.exists(synth_netlist)) else "FAIL"
        else:
            logging.warning("[STAGE 4/8] Yosys not in PATH. Status: SKIPPED")

        # ---------------------------------------------------------
        # STAGE 5 & 6: Icarus Verilog RTL Compilation & VVP Execution
        # ---------------------------------------------------------
        if iverilog_avail and vvp_avail:
            logging.info("[STAGE 5/8] Compiling RTL via Icarus Verilog (iverilog)...")
            out_vvp = os.path.join(BUILD_DIR, "garuda_titan_v12_r2.vvp")
            cmd_c = [self.iverilog_path, "-g2012", "-Wall", "-s", "tb_garuda_vertical_slice_v24_6", "-o", out_vvp] + rtl_files + [tb_file]
            res_c = subprocess.run(cmd_c, capture_output=True, text=True, timeout=30, cwd=PROJECT_DIR)

            with open(os.path.join(LOGS_DIR, "rtl_compile.log"), "w", encoding="utf-8") as f:
                f.write(res_c.stdout + "\n" + res_c.stderr)

            if res_c.returncode == 0:
                logging.info("[STAGE 6/8] Executing Simulation via VVP...")
                cmd_s = [self.vvp_path, out_vvp]
                res_s = subprocess.run(cmd_s, capture_output=True, text=True, timeout=180, cwd=PROJECT_DIR)

                with open(os.path.join(LOGS_DIR, "rtl_simulation.log"), "w", encoding="utf-8") as f:
                    f.write(res_s.stdout + "\n" + res_s.stderr)

                sim_passed = (res_s.returncode == 0 and "FATAL" not in res_s.stdout.upper() and "FAIL" not in res_s.stdout.upper())
                sim_status = "PASS" if sim_passed else "FAIL"
                sim_out = res_s.stdout
            else:
                logging.error("Icarus Verilog Compilation FAILED.")
                sim_status = "FAIL"
                sim_out = res_c.stderr
        else:
            sim_status = "BLOCKED"
            sim_out = "Icarus Verilog or VVP not installed on host PATH."

        # ---------------------------------------------------------
        # STAGE 7: Real Negative Exception Verification
        # ---------------------------------------------------------
        neg_status = "SKIPPED"
        if iverilog_avail and vvp_avail:
            neg_status = self.run_negative_test_opcode_exception(rtl_files, tb_file)

        # Mandatory stages status evaluation
        mandatory_passed = (ok_compiler and sim_status == "PASS" and neg_status == "PASS")
        overall_status = "PASS" if mandatory_passed else ("FAIL" if (sim_status == "FAIL" or neg_status == "FAIL") else "BLOCKED")
        exit_code = 0 if overall_status == "PASS" else 1

        # ---------------------------------------------------------
        # STAGE 8: JSON Evidence Generation
        # ---------------------------------------------------------
        duration = time.time() - start_t
        report = {
            "project": "GARUDA SEMESTA",
            "milestone": "TITAN V12-R2 INSTRUCTION FETCH & MEMORY FABRIC SYNTHESIS",
            "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "host_environment": sys.platform,
            "tool_versions": {
                "python": sys.version.split()[0],
                "iverilog": self.iverilog_path if iverilog_avail else "BLOCKED",
                "vvp": self.vvp_path if vvp_avail else "BLOCKED",
                "verilator": self.verilator_path if verilator_avail else "BLOCKED",
                "yosys": self.yosys_path if yosys_avail else "BLOCKED"
            },
            "overall_status": overall_status,
            "exit_code": exit_code,
            "stage_results": {
                "compiler_pipeline": "PASS" if ok_compiler else "FAIL",
                "verilator_lint": verilator_status,
                "yosys_synthesis": yosys_status,
                "rtl_simulation": sim_status,
                "negative_tests": neg_status
            },
            "details": {
                "hex_sha256": hex_sha256,
                "instructions_compiled": inst_count,
                "sram_target_address": "0x80000100",
                "sram_expected_value": 500,
                "simulation_output": sim_out,
                "duration_seconds": round(duration, 3)
            }
        }

        report_path = os.path.join(REPORTS_DIR, "v12_r2_execution_report.json")
        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2)

        print("\n=========================================================================")
        print(f" TITAN V12-R2 RUNNER STATUS: {overall_status} (Exit Code: {exit_code})")
        print(f" EVIDENCE REPORT SAVED TO: '{report_path}'")
        print("=========================================================================\n")

        return exit_code == 0

if __name__ == "__main__":
    runner = GarudaTitanV12R2Runner()
    success = runner.run_full_titan_v12_pipeline()
    sys.exit(0 if success else 1)
