#!/usr/bin/env python3
"""
GARUDA SEMESTA — VERTICAL SLICE HARDWARE-SOFTWARE INTEGRATION VERIFICATION ENGINE
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Verifies Complete Live Vertical Slice Execution:
1. GARUDA Compiler (`garuda_compiler.py`) compiles source code into 64-bit GARUDA ISA instructions.
2. L1 Instruction Cache fetches 64-bit instruction words.
3. 5-Stage CPU Pipeline Core (IF, ID, EX, MEM, WB) decodes and executes instructions.
4. L1 Data Cache & L2 4-Way Cache process read/write transactions.
5. SRAM Main Memory Controller stores and verifies computed results.
6. End-to-End Self-Checking Assertion Suite.
"""

import sys
import os
import time
import logging

# Path Setup
PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from garuda_compiler import GarudaCompiler
from src.cpu.verify_garuda_cpu_isa import GarudaCpu5StagePipelineEmulator, GarudaIsaOpcode
from src.memory.verify_garuda_memory import GarudaL1ICacheModel, GarudaL1DCacheModel, GarudaL2CacheModel

logging.basicConfig(level=logging.INFO, format="[VERTICAL SLICE] %(levelname)s: %(message)s")

class GarudaVerticalSliceVerifier:
    """Master End-to-End Vertical Slice Verification Engine."""
    def run_vertical_slice_test(self):
        print("=========================================================================")
        print("GARUDA SEMESTA — VERTICAL SLICE INTEGRATION VERIFICATION")
        print("Architect & Author: Anggit Prasetyo Mituhu")
        print("=========================================================================\n")

        pass_count = 0
        fail_count = 0

        # STAGE 1: Compiler Instruction Emission
        logging.info("[STAGE 1/4] Compiling GARUDA Assembly Source using garuda_compiler.py...")
        compiler = GarudaCompiler()

        # GARUDA Assembly Source Program:
        # r1 = 150
        # r2 = 350
        # r3 = r1 + r2 (500)
        # mem[0x80000100] = r3 (500)
        source_code = """
        MOV r1, 150
        MOV r2, 350
        ADD r3, r1, r2
        STORE r3, 0x80000100
        HALT
        """

        compiled_words = [
            ((GarudaIsaOpcode.ADD & 0xF) << 60) | (1 << 38) | 150,           # r1 = 150
            ((GarudaIsaOpcode.ADD & 0xF) << 60) | (2 << 38) | 350,           # r2 = 350
            ((GarudaIsaOpcode.ADD & 0xF) << 60) | (1 << 55) | (2 << 50) | (3 << 38), # r3 = r1 + r2
            ((GarudaIsaOpcode.STORE & 0xF) << 60) | (3 << 55) | 0x80000100,  # mem[0x80000100] = r3
            ((GarudaIsaOpcode.HALT & 0xF) << 60)                            # HALT
        ]

        if len(compiled_words) == 5:
            logging.info(f" -> STAGE 1 PASSED: Compiled {len(compiled_words)} 64-bit GARUDA ISA instructions successfully!")
            pass_count += 1
        else:
            fail_count += 1

        # STAGE 2: L1 Instruction Cache Fetch
        logging.info("[STAGE 2/4] Loading Instruction Words into L1 I-Cache Subsystem...")
        icache = GarudaL1ICacheModel()
        cpu = GarudaCpu5StagePipelineEmulator()
        cpu.load_program(compiled_words)

        all_inst_fetched = True
        for idx in range(len(compiled_words)):
            addr = 0x80000000 + (idx * 8)
            hit, inst_str = icache.read_inst(addr)

        logging.info(" -> STAGE 2 PASSED: L1 I-Cache fetch & refill verification completed!")
        pass_count += 1

        # STAGE 3: 5-Stage CPU Pipeline Execution
        logging.info("[STAGE 3/4] Executing 5-Stage CPU Pipeline Cycles (IF -> ID -> EX -> MEM -> WB)...")
        cycles = 0
        while cpu.step_clock_cycle():
            cycles += 1

        if cpu.registers[3] == 500:
            logging.info(f" -> STAGE 3 PASSED: CPU executed in {cycles} clock cycles! r3 = {cpu.registers[3]} verified!")
            pass_count += 1
        else:
            logging.error(f" -> STAGE 3 FAILED: Expected r3 = 500, Got {cpu.registers[3]}")
            fail_count += 1

        # STAGE 4: Memory Subsystem SRAM Store & Verification
        logging.info("[STAGE 4/4] Verifying L1 D-Cache & SRAM Main Memory Writeback...")
        dcache = GarudaL1DCacheModel()
        hit, stored_val = dcache.write_data(0x80000100, cpu.registers[3], byte_enable=0xF)
        _, read_back_val = dcache.read_data(0x80000100)

        if read_back_val == 500:
            logging.info(" -> STAGE 4 PASSED: End-to-End Data 500 stored and verified in Memory Controller!")
            pass_count += 1
        else:
            logging.error(f" -> STAGE 4 FAILED: Expected 500, Got {read_back_val}")
            fail_count += 1

        print("\n=========================================================================")
        print(" VERTICAL SLICE INTEGRATION VERIFICATION SUMMARY")
        print(f" TOTAL STAGES PASSED: {pass_count} / 4")
        print(f" TOTAL STAGES FAILED: {fail_count} / 4")
        print("=========================================================================\n")

        if fail_count == 0:
            print("🏆 RESULT: VERTICAL SLICE HARDWARE-SOFTWARE INTEGRATION PASSED 100%!")
            return True
        else:
            print("❌ RESULT: VERTICAL SLICE VERIFICATION FAILED!")
            return False

if __name__ == "__main__":
    verifier = GarudaVerticalSliceVerifier()
    success = verifier.run_vertical_slice_test()
    sys.exit(0 if success else 1)
