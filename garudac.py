#!/usr/bin/env python3
"""
GARUDA High-Level Language Compiler (`garudac`) v9.0
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Parses readable high-level GARUDA actor scripts (.gar) and compiles them
directly into 43-bit synthesizable Verilog ROM bitstream instructions.
"""

import sys
import re
from garuda_compiler import GarudaCompiler

class GarudaHighLevelCompiler:
    def __init__(self):
        self.compiler = GarudaCompiler()

    def compile_script(self, script_text):
        """
        Parses high-level GARUDA language script statements.
        Supported Syntax:
          - alloc <pid> <size>
          - write <pid> <address> <data_hex_or_int>
          - print_uart <pid> <char_or_ascii>
          - send_mailbox <src_pid> <target_pid> <payload_hex_or_int>
          - snn_spike <pid> <weight_int>
          - gemm <pid> <matrix_data_hex>
          - pqc_encrypt <pid> <input_data_hex>
          - aes_encrypt <pid> <key_data_hex>
          - gc_free <pid> <size>
          - set_timer <pid> <ticks>
          - halt <pid>
        """
        lines = script_text.strip().split('\n')
        for line_num, line in enumerate(lines, 1):
            line = line.split('//')[0].split('#')[0].strip() # Remove comments
            if not line:
                continue

            tokens = line.split()
            cmd = tokens[0].lower()

            try:
                if cmd == 'alloc':
                    pid = int(tokens[1])
                    size = int(tokens[2])
                    self.compiler.alloc(pid, size)

                elif cmd == 'write':
                    pid = int(tokens[1])
                    addr = int(tokens[2])
                    data = int(tokens[3], 0)
                    self.compiler.write(pid, addr, data)

                elif cmd == 'print_uart':
                    pid = int(tokens[1])
                    char_val = tokens[2].strip("'\"")
                    self.compiler.print_uart(pid, char_val)

                elif cmd == 'send_mailbox':
                    src_pid = int(tokens[1])
                    target_pid = int(tokens[2])
                    payload = int(tokens[3], 0)
                    self.compiler.send_mailbox(src_pid, target_pid, payload)

                elif cmd == 'snn_spike':
                    pid = int(tokens[1])
                    weight = int(tokens[2], 0)
                    self.compiler.neuromorphic_spike(pid, weight)

                elif cmd == 'gemm':
                    pid = int(tokens[1])
                    matrix_data = int(tokens[2], 0)
                    self.compiler.gemm_transformer_op(pid, matrix_data)

                elif cmd == 'pqc_encrypt':
                    pid = int(tokens[1])
                    input_data = int(tokens[2], 0)
                    self.compiler.pqc_lattice_op(pid, input_data)

                elif cmd == 'aes_encrypt':
                    pid = int(tokens[1])
                    key_data = int(tokens[2], 0)
                    self.compiler.aes_encrypt(pid, key_data)

                elif cmd == 'gc_free':
                    pid = int(tokens[1])
                    size = int(tokens[2])
                    self.compiler.gc_free(pid, size)

                elif cmd == 'set_timer':
                    pid = int(tokens[1])
                    ticks = int(tokens[2])
                    self.compiler.set_timer(pid, ticks)

                elif cmd == 'halt':
                    pid = int(tokens[1]) if len(tokens) > 1 else 0
                    self.compiler.halt(pid)

                else:
                    print(f"Warning [Line {line_num}]: Unknown command '{cmd}'")
            except Exception as e:
                print(f"Error [Line {line_num}]: Failed to parse line '{line}' - {e}")

        return self.compiler.generate_verilog_rom()


if __name__ == "__main__":
    sample_garuda_script = """
    # High-Level GARUDA Actor Script Example
    # Created by Anggit Prasetyo Mituhu

    alloc 0 4
    snn_spike 0 255
    gemm 0 0x00020003
    pqc_encrypt 0 0x12345678
    print_uart 0 'G'
    print_uart 0 'A'
    print_uart 0 'R'
    print_uart 0 'U'
    print_uart 0 'D'
    print_uart 0 'A'
    send_mailbox 0 1 0xCAFEBABE
    gc_free 0 4
    halt 0
    """

    hl_compiler = GarudaHighLevelCompiler()
    print("=== GARUDA HIGH-LEVEL COMPILER (`garudac`) v9.0 ===")
    print("Compiling GARUDA High-Level Script to 43-bit Verilog ROM...\n")
    verilog_rom_output = hl_compiler.compile_script(sample_garuda_script)
    print(verilog_rom_output)
