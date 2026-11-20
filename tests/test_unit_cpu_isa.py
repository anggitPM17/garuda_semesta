#!/usr/bin/env python3
"""
GARUDA SEMESTA — UNIT TEST: CPU CORE & ISA CONFORMANCE (FASE 3 & FASE 4)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0
"""

import sys
import os
import unittest

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from src.cpu.verify_garuda_cpu_isa import GarudaCpu5StagePipelineEmulator, GarudaInstructionEncoder, GarudaIsaOpcode

class TestGarudaCpuCore(unittest.TestCase):
    def setUp(self):
        self.cpu = GarudaCpu5StagePipelineEmulator()

    def test_regfile_r0_constant_zero(self):
        inst = GarudaInstructionEncoder.encode(GarudaIsaOpcode.ADD, rs1=0, rd=0, imm=100) # write to r0
        self.cpu.load_program([inst, GarudaInstructionEncoder.encode(GarudaIsaOpcode.HALT)])
        self.cpu.step_clock_cycle()
        self.assertEqual(self.cpu.registers[0], 0) # r0 must remain 0

    def test_alu_multiplication(self):
        prog = [
            GarudaInstructionEncoder.encode(GarudaIsaOpcode.ADD, rs1=0, rd=1, imm=300),
            GarudaInstructionEncoder.encode(GarudaIsaOpcode.ADD, rs1=0, rd=2, imm=200),
            GarudaInstructionEncoder.encode(GarudaIsaOpcode.MUL, rs1=1, rs2=2, rd=3),
            GarudaInstructionEncoder.encode(GarudaIsaOpcode.HALT)
        ]
        self.cpu.load_program(prog)
        while self.cpu.step_clock_cycle():
            pass
        self.assertEqual(self.cpu.registers[3], 60000)

if __name__ == "__main__":
    unittest.main()
