#!/usr/bin/env python3
"""
GARUDA Compiler & Assembler Toolchain v10.0 EXCALIBUR (Enterprise BGA-2000+)
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Translates GARUDA high-level instructions into 64-bit EXCALIBUR ISA
for the Octa-Core SMP Hyperscale Network-on-Chip (NoC) Architecture.

64-Bit Enterprise ISA Format:
[Opcode: 4 bit][PID: 4 bit][Target/Addr: 12 bit][Size: 12 bit][Data/Payload: 32 bit]
"""

import sys

class GarudaCompiler:
    OPCODES = {
        'NOP': 0,
        'HALT': 0,
        'ALLOC': 1,
        'WRITE': 2,
        'SEND_MSG': 2,
        'READ': 3,
        'GC_FREE': 4
    }

    def __init__(self):
        self.rom_binary = []

    def compile_instruction(self, opcode, pid, addr_or_target, size, data):
        """
        Membentuk bitstream 64-bit sesuai spesifikasi Excalibur NoC CPU Core.
        - Opcode       : 4 bit  (bit 63..60)
        - PID          : 4 bit  (bit 59..56, PID 0..15)
        - Addr/Target  : 12 bit (bit 55..44)
        - Size         : 12 bit (bit 43..32)
        - Data/Payload : 32 bit (bit 31..0)
        """
        if isinstance(opcode, str):
            opcode = self.OPCODES.get(opcode.upper(), 0)

        binary_instruction = (
            ((opcode & 0xF) << 60) |
            ((pid & 0xF) << 56) |
            ((addr_or_target & 0xFFF) << 44) |
            ((size & 0xFFF) << 32) |
            (data & 0xFFFFFFFF)
        )
        self.rom_binary.append(binary_instruction)
        return binary_instruction

    def alloc(self, pid, size):
        return self.compile_instruction('ALLOC', pid=pid, addr_or_target=0, size=size, data=0)

    def write(self, pid, address, data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=address, size=0, data=data)

    def neuromorphic_spike(self, pid, synapse_weight):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x046, size=0, data=synapse_weight)

    def gemm_transformer_op(self, pid, matrix_data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x048, size=0, data=matrix_data)

    def pqc_lattice_op(self, pid, input_data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x050, size=0, data=input_data)

    def vector_simd_op(self, pid, operand_data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x054, size=0, data=operand_data)

    def aes_encrypt(self, pid, key_data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x056, size=0, data=key_data)

    def print_uart(self, pid, char):
        ascii_code = ord(char) if isinstance(char, str) else char
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=0x062, size=0, data=ascii_code)

    def gc_free(self, pid, size):
        return self.compile_instruction('GC_FREE', pid=pid, addr_or_target=0, size=size, data=0)

    def halt(self, pid=0):
        return self.compile_instruction('HALT', pid=pid, addr_or_target=0, size=0, data=0)

    def generate_verilog_rom(self, output_file=None):
        lines = [
            "// =========================================================",
            "// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v10.0 EXCALIBUR",
            "// Target Architecture: GARUDA SEMESTA Octa-Core BGA-2000 NoC ASIC (64-bit Bitstream)",
            "// ========================================================="
        ]
        for idx, inst in enumerate(self.rom_binary):
            lines.append(f"instruction_rom[{idx}] = 64'h{inst:016X};")

        output_str = "\n".join(lines)
        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(output_str + "\n")
            print(f"Generated Verilog ROM saved to: {output_file}")
        return output_str


if __name__ == "__main__":
    compiler = GarudaCompiler()
    compiler.alloc(pid=0, size=4)
    compiler.gemm_transformer_op(pid=0, matrix_data=0x00020003)
    compiler.pqc_lattice_op(pid=0, input_data=0x12345678)
    compiler.print_uart(pid=0, char='G')
    compiler.gc_free(pid=0, size=4)
    compiler.halt(pid=0)

    print(compiler.generate_verilog_rom())
