#!/usr/bin/env python3
"""
GARUDA Compiler & Assembler Toolchain v3.0 (Silicon & Tiny Tapeout ASIC Ready)
Translates GARUDA instructions into 43-bit binary/hex machine instructions
for the GARUDA SEMESTA Quad-Core SoC architecture (Verilog ROM output).

Bitstream Format (43-bit):
[Opcode: 3 bit][PID: 2 bit][Alamat/Target: 6 bit][Size: 4 bit][Data/Payload: 32 bit]

Opcode Mapping:
  0b000 (0): NOP / HALT
  0b001 (1): ALLOC (Alokasi heap privat untuk proses)
  0b010 (2): WRITE / SEND MSG / UART TX / TIMER (Menulis data ke memori/periferal)
  0b011 (3): READ (Membaca data dari memori / Cycle counter)
  0b100 (4): GC FREE (Pembersihan memori Garbage Collection Hardware)
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
        - PID          : 2 bit  (bit 39..38, PID 0..3)
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

    def alloc(self, pid, size):
        return self.compile_instruction('ALLOC', pid=pid, addr_or_target=0, size=size, data=0)

    def write(self, pid, address, data):
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=address, size=0, data=data)

    def print_uart(self, pid, char):
        # Hardware UART Serial Console Address 62
        ascii_code = ord(char) if isinstance(char, str) else char
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=62, size=0, data=ascii_code)

    def set_timer(self, pid, ticks):
        # Hardware Timer Wheel Address 61
        return self.compile_instruction('WRITE', pid=pid, addr_or_target=61, size=0, data=ticks)

    def send_mailbox(self, src_pid, target_pid, payload):
        # Mailbox Target Address 60
        return self.compile_instruction('SEND_MSG', pid=src_pid, addr_or_target=60 + (target_pid & 0x3), size=0, data=payload)

    def read_cycle_counter(self, pid):
        # Profiling Cycle Counter Address 58
        return self.compile_instruction('READ', pid=pid, addr_or_target=58, size=0, data=0)

    def gc_free(self, pid, size):
        return self.compile_instruction('GC_FREE', pid=pid, addr_or_target=0, size=size, data=0)

    def halt(self, pid=0):
        return self.compile_instruction('HALT', pid=pid, addr_or_target=0, size=0, data=0)

    def generate_verilog_rom(self, output_file=None):
        lines = [
            "// =========================================================",
            "// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v3.0",
            "// Target Architecture: GARUDA SEMESTA Quad-Core SoC (43-bit Bitstream)",
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
    # Program Demonstrasi v3.0: Hardware UART + Mailbox IPC + Timer Wheel + HW-GC
    compiler.alloc(pid=0, size=4)
    compiler.print_uart(pid=0, char='G')                               # Cetak karakter 'G' via Hardware UART TX
    compiler.send_mailbox(src_pid=0, target_pid=1, payload=0xCAFEBABE) # Mailbox IPC ke PID 1
    compiler.set_timer(pid=0, ticks=100)                               # Set Hardware Timer Wheel (100 ticks)
    compiler.gc_free(pid=0, size=4)                                    # Active HW-GC Free
    compiler.halt(pid=0)

    print(compiler.generate_verilog_rom())
