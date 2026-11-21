#!/usr/bin/env python3
"""
GARUDA SEMESTA — COMPILER PIPELINE & ARTIFACT GENERATOR (v12.4.6-R2)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Executes Phase 4 Real Compiler Pipeline:
1. Compiles GARUDA assembly source program via garuda_compiler.py
2. Generates artifacts/v2.4.6/compiler/ artifacts:
   source.garuda, compiler_output.ir, program.asm, program.hex, compiler_manifest.json
3. Calculates SHA-256 checksums for source & emitted 32-bit HEX bitstream.
4. Generates single canonical 32-bit word formatted program.hex for Memory Controller `$readmemh`
"""

import sys
import os
import json
import hashlib
import logging
import shutil

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from garuda_compiler import GarudaCompiler

logging.basicConfig(level=logging.INFO, format="[GARUDA COMPILER PIPELINE v2.4.6-R2] %(levelname)s: %(message)s")

ARTIFACTS_COMPILER_DIR = os.path.join(PROJECT_DIR, "artifacts", "v2.4.6", "compiler")
HEX_FILE_NAME = "program.hex"

def run_garuda_compiler_pipeline():
    os.makedirs(ARTIFACTS_COMPILER_DIR, exist_ok=True)

    print("=========================================================================")
    print("GARUDA SEMESTA — REAL COMPILER PIPELINE v12.4.6-R2")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    # The single unified test program for Acceptance Execution
    assembly_source = """# GARUDA Assembly Source Program (V2.4.6-R2 Target Requirement)
MOV r1, 150
MOV r2, 350
ADD r3, r1, r2
STORE r3, [r0 + 0x80000100]
HALT
"""

    compiler = GarudaCompiler()

    try:
        compiled_words = compiler.compile_source_file(assembly_source, output_dir=ARTIFACTS_COMPILER_DIR)
    except Exception as e:
        logging.error(f"GARUDA Compiler execution failed: {e}")
        return False, None, None

    # Convert 64-bit compiled words to 32-bit word lines for 32-bit SRAM $readmemh compatibility
    # Each 64-bit instruction emits 2 x 32-bit lines: [Lower 32-bit, Upper 32-bit]
    hex_32bit_lines = []
    for inst in compiled_words:
        lower_word = inst & 0xFFFFFFFF
        upper_word = (inst >> 32) & 0xFFFFFFFF
        hex_32bit_lines.append(f"{lower_word:08X}")
        hex_32bit_lines.append(f"{upper_word:08X}")

    root_hex_path = os.path.join(PROJECT_DIR, HEX_FILE_NAME)
    with open(root_hex_path, "w", encoding="utf-8") as f:
        f.write("\n".join(hex_32bit_lines) + "\n")

    artifact_hex_path = os.path.join(ARTIFACTS_COMPILER_DIR, HEX_FILE_NAME)
    shutil.copy2(root_hex_path, artifact_hex_path)

    source_sha256 = hashlib.sha256(assembly_source.encode()).hexdigest()
    hex_sha256 = hashlib.sha256("\n".join(hex_32bit_lines).encode()).hexdigest()

    manifest = {
        "compiler": "garuda_compiler.py v12.2",
        "target_isa": "GARUDA 64-bit Titanium ISA V2.4.6-R2",
        "instruction_width": 64,
        "instructions_compiled": len(compiled_words),
        "sram_32bit_words": len(hex_32bit_lines),
        "source_sha256": source_sha256,
        "hex_sha256": hex_sha256,
        "artifacts_generated": [
            "source.garuda",
            "compiler_output.ir",
            "program.asm",
            HEX_FILE_NAME,
            "compiler_manifest.json"
        ]
    }

    manifest_path = os.path.join(ARTIFACTS_COMPILER_DIR, "compiler_manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    logging.info(f"Compiled {len(compiled_words)} instructions -> Emitted {HEX_FILE_NAME} (SHA-256: {hex_sha256[:16]}...)")
    print(f"\n[COMPILER PIPELINE COMPLETE] Artifacts saved in 'artifacts/v2.4.6/compiler/'\n")

    return True, hex_sha256, len(compiled_words)

if __name__ == "__main__":
    success, _, _ = run_garuda_compiler_pipeline()
    sys.exit(0 if success else 1)
