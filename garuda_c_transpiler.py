#!/usr/bin/env python3
"""
GARUDA C/C++ Transpiler Compiler (`garudac-c`) v12.0
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Parses C/C++ source code (.c / .cpp) using garuda.h C-SDK intrinsics and compiles them
directly into 64-bit synthesizable Verilog ROM bitstream instructions for 32-Core SMP.
"""

import sys
import re
from garuda_compiler import GarudaCompiler

class GarudaCTranspiler:
    def __init__(self):
        self.compiler = GarudaCompiler()

    def transpile_c_code(self, c_code_text):
        """
        Parses C/C++ function calls matching garuda.h C-SDK.
        Supported C API:
          - garuda_alloc(pid, size);
          - garuda_snn_spike_array(pid, mask);
          - garuda_gemm_transformer(pid, matrix);
          - garuda_pqc_encrypt(pid, data);
          - garuda_aes_encrypt(pid, key);
          - garuda_vector_simd(pid, operand);
          - garuda_print_char(pid, 'G');
          - garuda_print_string(pid, "HELLO");
          - garuda_send_mailbox(src_pid, target_pid, payload);
          - garuda_free(pid, size);
          - garuda_halt(pid);
        """
        lines = c_code_text.split('\n')
        for line_num, line in enumerate(lines, 1):
            line = line.split('//')[0].strip() # Clean comments
            if not line:
                continue

            # Match C Function Calls using Regex
            alloc_match = re.search(r'garuda_alloc\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)', line)
            if alloc_match:
                self.compiler.alloc(int(alloc_match.group(1)), int(alloc_match.group(2)))
                continue

            snn_match = re.search(r'garuda_snn_spike_array\s*\(\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if snn_match:
                self.compiler.neuromorphic_spike_array(int(snn_match.group(1)), int(snn_match.group(2), 0))
                continue

            gemm_match = re.search(r'garuda_gemm_transformer\s*\(\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if gemm_match:
                self.compiler.gemm_transformer_op(int(gemm_match.group(1)), int(gemm_match.group(2), 0))
                continue

            pqc_match = re.search(r'garuda_pqc_encrypt\s*\(\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if pqc_match:
                self.compiler.pqc_lattice_op(int(pqc_match.group(1)), int(pqc_match.group(2), 0))
                continue

            aes_match = re.search(r'garuda_aes_encrypt\s*\(\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if aes_match:
                self.compiler.aes_encrypt(int(aes_match.group(1)), int(aes_match.group(2), 0))
                continue

            simd_match = re.search(r'garuda_vector_simd\s*\(\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if simd_match:
                self.compiler.vector_simd_op(int(simd_match.group(1)), int(simd_match.group(2), 0))
                continue

            char_match = re.search(r"garuda_print_char\s*\(\s*(\d+)\s*,\s*['\"](.)['\"]\s*\)", line)
            if char_match:
                self.compiler.print_uart(int(char_match.group(1)), char_match.group(2))
                continue

            str_match = re.search(r'garuda_print_string\s*\(\s*(\d+)\s*,\s*["\']([^"\']+)["\']\s*\)', line)
            if str_match:
                pid = int(str_match.group(1))
                for ch in str_match.group(2):
                    self.compiler.print_uart(pid, ch)
                continue

            mb_match = re.search(r'garuda_send_mailbox\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*\)', line)
            if mb_match:
                self.compiler.send_mailbox(int(mb_match.group(1)), int(mb_match.group(2)), int(mb_match.group(3), 0))
                continue

            free_match = re.search(r'garuda_free\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)', line)
            if free_match:
                self.compiler.gc_free(int(free_match.group(1)), int(free_match.group(2)))
                continue

            halt_match = re.search(r'garuda_halt\s*\(\s*(\d+)\s*\)', line)
            if halt_match:
                self.compiler.halt(int(halt_match.group(1)))
                continue

        return self.compiler.generate_verilog_rom()


if __name__ == "__main__":
    sample_c_program = """
    // Sample C Program for GARUDA SEMESTA 32-Core SoC
    // Author: Anggit Prasetyo Mituhu

    #include <garuda.h>

    int main() {
        garuda_alloc(0, 4);
        garuda_snn_spike_array(0, 0xFFFFFFFF);
        garuda_gemm_transformer(0, 0x00020003);
        garuda_pqc_encrypt(31, 0x12345678);
        garuda_print_string(0, "GARUDA");
        garuda_send_mailbox(0, 31, 0xCAFEBABE);
        garuda_free(0, 4);
        garuda_halt(0);
        return 0;
    }
    """

    transpiler = GarudaCTranspiler()
    print("=== GARUDA C/C++ TRANSPILER COMPILER (`garudac-c`) v12.0 ===")
    print("Transpiling Standard C Code (main.c) to 64-bit Verilog ROM...\n")
    rom_output = transpiler.transpile_c_code(sample_c_program)
    print(rom_output)
