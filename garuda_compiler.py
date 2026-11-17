#!/usr/bin/env python3
"""
GARUDA Compiler & Assembler Toolchain
Translates GARUDA instructions into 43-bit binary/hex machine instructions
for the GARUDA SEMESTA SoC architecture (Verilog ROM output).

Bitstream Format (43-bit):
[Opcode: 3 bit][PID: 2 bit][Alamat/Target: 6 bit][Size: 4 bit][Data/Payload: 32 bit]

Opcode Mapping:
  0b000 (0): NOP / HALT
  0b001 (1): ALLOC (Alokasi heap privat untuk proses)
  0b010 (2): WRITE / SEND MSG (Menulis data ke memori atau kirim pesan mailbox)
  0b011 (3): READ (Membaca data dari memori)
  0b100 (4): GC FREE (Pembersihan memori garbage collection)
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
        Membentuk bitstream 43-bit sesuai spesifikasi decoder CPU Core GARUDA SEMESTA.
        - Opcode       : 3 bit  (bit 42..40)
        - PID          : 2 bit  (bit 39..38)
        - Addr/Target  : 6 bit  (bit 37..32)
        - Size         : 4 bit  (bit 31..28)
        - Data/Payload : 32 bit (bit 27..0 / mask 0xFFFFFFFF)
        """
        if isinstance(opcode, str):
            opcode = self.OPCODES.get(opcode.upper(), 0)

        binary_instruction = (
            ((opcode & 0x7) << 40) |
            ((pid & 0x3) << 38) |
            ((addr_or_target & 0x3F) << 32) |
            ((size & 0xF) << 28) |
            (data & 0xFFFFFFFF)
        )
        self.rom_binary.append(binary_instruction)
        return binary_instruction

    def generate_verilog_rom(self, output_file=None):
        lines = [
            "// =========================================================",
            "// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT",
            "// Target Architecture: GARUDA SEMESTA SoC (43-bit Bitstream)",
            "// ========================================================="
        ]
        for idx, inst in enumerate(self.rom_binary):
            lines.append(f"instruction_rom[{idx}] = 43'h{inst:011X};")

        output_str = "\n".join(lines)
        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(output_str + "\n")
            print(f"Generated Verilog ROM saved to: {output_file}")
        return output_str


if __name__ == "__main__":
    compiler = GarudaCompiler()
    # Contoh kompilasi instruksi bawaan
    compiler.compile_instruction(opcode=1, pid=0, addr_or_target=1, size=4, data=1024)       # ALLOC
    compiler.compile_instruction(opcode=2, pid=0, addr_or_target=1, size=4, data=0xDEADBEEF) # WRITE
    compiler.compile_instruction(opcode=3, pid=0, addr_or_target=1, size=4, data=0)          # READ
    compiler.compile_instruction(opcode=4, pid=0, addr_or_target=1, size=4, data=0)          # GC_FREE
    compiler.compile_instruction(opcode=0, pid=0, addr_or_target=0, size=0, data=0)          # HALT

    print(compiler.generate_verilog_rom())
