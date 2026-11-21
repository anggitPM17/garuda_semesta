#!/usr/bin/env python3
"""
GARUDA SEMESTA — DUAL COMPILER-TO-RTL INTEGRATION SUITE (v12.4.6-R2)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Verifies Compiler-to-Hardware Execution via Dual Validation Modes:
1. Mode A: Python Golden Reference Functional Emulator Test
2. Mode B: Real Icarus Verilog RTL Simulation & DMA SRAM Assertion Test (via VVP)
"""

import sys
import os
import time
import json
import logging
import subprocess

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from garuda_compiler import GarudaCompiler
from src.cpu.verify_garuda_cpu_isa import GarudaCpu5StagePipelineEmulator
from src.verification.garuda_titan_v12_integration_runner import GarudaTitanV12R2Runner

logging.basicConfig(level=logging.INFO, format="[COMPILER VERTICAL SLICE V12.1] %(levelname)s: %(message)s")

REPORTS_V22_DIR = os.path.join(PROJECT_DIR, "reports", "verification_v22", "compiler_to_sram")

def run_python_golden_emulator():
    logging.info("--- [MODE A] Executing Python Golden Reference Functional Emulator ---")
    compiler = GarudaCompiler()

    assembly_source = """
    MOV r1, 150
    MOV r2, 350
    ADD r3, r1, r2
    STORE r3, [r0 + 0x80000100]
    HALT
    """

    compiled_words = compiler.compile_source_file(assembly_source, output_dir=REPORTS_V22_DIR)
    cpu = GarudaCpu5StagePipelineEmulator()
    cpu.load_program(compiled_words)

    cycles = 0
    while cpu.step_clock_cycle():
        cycles += 1

    sram_val = cpu.memory.get(0x80000100, 0)
    passed = (sram_val == 500 and cpu.registers[3] == 500)
    logging.info(f" -> Python Emulator executed {cycles} cycles. SRAM[0x80000100] = {sram_val} ({'PASS' if passed else 'FAIL'})")
    return passed

def run_real_verilog_rtl_simulation():
    logging.info("--- [MODE B] Executing Real Icarus Verilog RTL Simulation & VVP Readback ---")
    runner = GarudaTitanV12R2Runner()
    return runner.run_full_titan_v12_pipeline()

def run_dual_vertical_slice_integration():
    os.makedirs(REPORTS_V22_DIR, exist_ok=True)

    print("=========================================================================")
    print("GARUDA SEMESTA — DUAL COMPILER-TO-RTL INTEGRATION SUITE v12.4.6-R2")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    py_passed = run_python_golden_emulator()
    rtl_passed = run_real_verilog_rtl_simulation()

    overall_passed = py_passed and rtl_passed

    print("\n=========================================================================")
    print(f" DUAL COMPILER-TO-RTL VERIFICATION SUMMARY V12.1")
    print(f" MODE A (Python Golden Reference Emulator): {'PASS' if py_passed else 'FAILED'}")
    print(f" MODE B (Real Verilog RTL Simulation & SRAM Readback): {'PASS' if rtl_passed else 'FAILED'}")
    print("=========================================================================\n")

    if overall_passed:
        print("🏆 RESULT: DUAL COMPILER-TO-RTL VERIFICATION PASSED 100%!")
        return True
    else:
        print("❌ RESULT: DUAL VERIFICATION FAILED!")
        return False

if __name__ == "__main__":
    success = run_dual_vertical_slice_integration()
    sys.exit(0 if success else 1)
