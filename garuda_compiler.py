#!/usr/bin/env python3
"""
GARUDA Compiler & Assembler Toolchain v12.2 (64-bit TITANIUM ISA)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Translates GARUDA high-level instructions & assembly into 64-bit TITANIUM ISA:
64-Bit Titanium ISA Format:
[Opcode: 4 bit][RS1: 5 bit][RS2: 5 bit][Unused: 7 bit][RD: 5 bit][Unused: 6 bit][Data/Imm: 32 bit]
"""

import sys
import os
import json
import hashlib

class GarudaCompiler:
    OPCODES = {
        'NOP': 0x0,
        'ADD': 0x1,
        'SUB': 0x2,
        'LOAD': 0x3,
        'STORE': 0x4,
        'BEQ': 0x5,
        'JMP': 0x6,
        'MUL': 0x7,
        'AND': 0x8,
        'OR': 0x9,
        'XOR': 0xA,
        'HALT': 0xF,
        'ALLOC': 0x1,
        'WRITE': 0x4,
        'READ': 0x3,
        'GC_FREE': 0x0
    }

    def __init__(self):
        self.rom_binary = []
        self.assembly_lines = []
        self.ir_lines = []

    def compile_instruction(self, opcode, rs1=0, rs2=0, rd=0, imm=0):
        if isinstance(opcode, str):
            opcode = self.OPCODES.get(opcode.upper(), 0)

        binary_instruction = (
            ((opcode & 0xF) << 60) |
            ((rs1 & 0x1F) << 55) |
            ((rs2 & 0x1F) << 50) |
            ((rd & 0x1F) << 38) |
            (imm & 0xFFFFFFFF)
        )
        self.rom_binary.append(binary_instruction)
        return binary_instruction

    def compile_source_file(self, garuda_src_text, output_dir=None):
        """Compiles GARUDA assembly source text into artifacts."""
        lines = [l.strip() for l in garuda_src_text.strip().split('\n') if l.strip() and not l.strip().startswith('#')]

        self.rom_binary = []
        self.assembly_lines = []
        self.ir_lines = []

        for line in lines:
            self.assembly_lines.append(line)
            tokens = line.replace(',', ' ').replace('[', ' ').replace(']', ' ').replace('+', ' ').split()
            if not tokens:
                continue

            mnemonic = tokens[0].upper()
            op = self.OPCODES.get(mnemonic, 0)

            if mnemonic in ['MOV', 'ADD']:
                # Example: MOV r1, 150 -> ADD r1, r0, 150
                # Example: ADD r3, r1, r2
                rd = int(tokens[1].replace('r', '')) if 'r' in tokens[1] else 0
                if len(tokens) == 3: # MOV r1, 150 -> ADD r0, r0, r1, 150
                    imm_val = int(tokens[2], 0) if not 'r' in tokens[2] else 0
                    rs1_val = int(tokens[2].replace('r', '')) if 'r' in tokens[2] else 0
                    self.compile_instruction('ADD', rs1=rs1_val, rs2=0, rd=rd, imm=imm_val)
                    self.ir_lines.append(f"IR_ADD rd=r{rd}, rs1=r{rs1_val}, imm={imm_val}")
                elif len(tokens) == 4: # ADD r3, r1, r2
                    rs1_val = int(tokens[2].replace('r', ''))
                    rs2_val = int(tokens[3].replace('r', ''))
                    self.compile_instruction('ADD', rs1=rs1_val, rs2=rs2_val, rd=rd, imm=0)
                    self.ir_lines.append(f"IR_ADD rd=r{rd}, rs1=r{rs1_val}, rs2=r{rs2_val}")

            elif mnemonic == 'LOAD':
                # Example: LOAD r4, [r0 + 0x80000100] -> LOAD rs1=0, rs2=0, rd=4, imm=0x80000100
                rd_val = int(tokens[1].replace('r', ''))
                rs1_val = int(tokens[2].replace('r', '')) if 'r' in tokens[2] else 0
                imm_val = int(tokens[3], 0) if len(tokens) > 3 else 0
                self.compile_instruction('LOAD', rs1=rs1_val, rs2=0, rd=rd_val, imm=imm_val)
                self.ir_lines.append(f"IR_LOAD rd=r{rd_val}, rs1=r{rs1_val}, imm=0x{imm_val:08X}")

            elif mnemonic == 'STORE':
                # Example: STORE r3, [r0 + 0x80000100] -> STORE rs1=0, rs2=3, imm=0x80000100
                rs2_val = int(tokens[1].replace('r', ''))
                rs1_val = int(tokens[2].replace('r', '')) if 'r' in tokens[2] else 0
                imm_val = int(tokens[3], 0) if len(tokens) > 3 else 0
                self.compile_instruction('STORE', rs1=rs1_val, rs2=rs2_val, rd=0, imm=imm_val)
                self.ir_lines.append(f"IR_STORE rs1=r{rs1_val}, rs2=r{rs2_val}, imm=0x{imm_val:08X}")

            elif mnemonic == 'HALT':
                self.compile_instruction('HALT', 0, 0, 0, 0)
                self.ir_lines.append("IR_HALT")

        if output_dir:
            os.makedirs(output_dir, exist_ok=True)
            with open(os.path.join(output_dir, "source.garuda"), "w", encoding="utf-8") as f:
                f.write(garuda_src_text)

            with open(os.path.join(output_dir, "source.ir"), "w", encoding="utf-8") as f:
                f.write("\n".join(self.ir_lines) + "\n")

            with open(os.path.join(output_dir, "source.asm"), "w", encoding="utf-8") as f:
                f.write("\n".join(self.assembly_lines) + "\n")

            hex_lines = [f"{inst:016X}" for inst in self.rom_binary]
            with open(os.path.join(output_dir, "source.hex"), "w", encoding="utf-8") as f:
                f.write("\n".join(hex_lines) + "\n")

            manifest = {
                "compiler": "garuda_compiler.py v12.2",
                "instructions_compiled": len(self.rom_binary),
                "binary_sha256": hashlib.sha256("\n".join(hex_lines).encode()).hexdigest()
            }
            with open(os.path.join(output_dir, "compiler_manifest.json"), "w", encoding="utf-8") as f:
                json.dump(manifest, f, indent=2)

        return self.rom_binary

    def generate_verilog_rom(self, output_file=None):
        lines = [
            "// =========================================================",
            "// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v12.2 TITAN-TITANIUM",
            "// Target Architecture: GARUDA SEMESTA 32-Core ASIC (64-bit Bitstream)",
            "// ========================================================="
        ]
        for idx, inst in enumerate(self.rom_binary):
            lines.append(f"instruction_rom[{idx}] = 64'h{inst:016X};")

        output_str = "\n".join(lines)
        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(output_str + "\n")
        return output_str


if __name__ == "__main__":
    compiler = GarudaCompiler()
    src = """
    MOV r1, 150
    MOV r2, 350
    ADD r3, r1, r2
    STORE r3, [r0 + 0x80000100]
    HALT
    """
    out_dir = os.path.join(os.path.dirname(__file__), "reports", "verification_v22", "compiler_to_sram")
    insts = compiler.compile_source_file(src, output_dir=out_dir)
    print(f"Compiled {len(insts)} instructions to {out_dir}")
