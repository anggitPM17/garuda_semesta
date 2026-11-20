#!/usr/bin/env python3
"""
GARUDA SEMESTA — COMPILER PIPELINE & ARTIFACT GENERATOR (v12.4.2)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Executes Phase 4 Real Compiler Pipeline:
1. Compiles GARUDA assembly source program via garuda_compiler.py
2. Generates build/v2.4.2/compiler/ and artifacts/v2.4.2/compiler/ artifacts:
   source.garuda, compiler_output.ir, program.asm, program.hex, compiler_manifest.json
3. Calculates SHA-256 checksums for source & emitted HEX bitstream.
"""

import sys
import os
import json
import hashlib
import logging

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from garuda_compiler import GarudaCompiler

logging.basicConfig(level=logging.INFO, format="[GARUDA COMPILER PIPELINE v2.4.2] %(levelname)s: %(message)s")

BUILD_COMPILER_DIR = os.path.join(PROJECT_DIR, "build", "v2.4.2", "compiler")
ARTIFACTS_COMPILER_DIR = os.path.join(PROJECT_DIR, "artifacts", "v2.4.2", "compiler")

def run_garuda_compiler_pipeline():
    os.makedirs(BUILD_COMPILER_DIR, exist_ok=True)
    os.makedirs(ARTIFACTS_COMPILER_DIR, exist_ok=True)

    print("=========================================================================")
    print("GARUDA SEMESTA — REAL COMPILER PIPELINE v12.4.2")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    assembly_source = """# GARUDA Assembly Source Program (V2.4.2 Target Requirement)
MOV r1, 150
MOV r2, 350
ADD r3, r1, r2
STORE r3, [r0 + 0x80000100]
HALT
"""

    compiler = GarudaCompiler()
    compiled_words = compiler.compile_source_file(assembly_source, output_dir=BUILD_COMPILER_DIR)

    # Also emit artifacts to artifacts/v2.4.2/compiler/
    compiler.compile_source_file(assembly_source, output_dir=ARTIFACTS_COMPILER_DIR)

    hex_path = os.path.join(BUILD_COMPILER_DIR, "source.hex")
    with open(hex_path, "r", encoding="utf-8") as f:
        hex_lines = [line.strip() for line in f if line.strip()]

    source_sha256 = hashlib.sha256(assembly_source.encode()).hexdigest()
    hex_sha256 = hashlib.sha256("\n".join(hex_lines).encode()).hexdigest()

    manifest = {
        "compiler": "garuda_compiler.py v12.2",
        "target_isa": "GARUDA 64-bit Titanium ISA V2.4.2",
        "instruction_width": 64,
        "instructions_compiled": len(compiled_words),
        "source_sha256": source_sha256,
        "hex_sha256": hex_sha256,
        "artifacts_generated": [
            "source.garuda",
            "compiler_output.ir",
            "program.asm",
            "program.hex",
            "compiler_manifest.json"
        ]
    }

    manifest_path = os.path.join(ARTIFACTS_COMPILER_DIR, "compiler_manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    logging.info(f"Compiled {len(compiled_words)} instructions -> Emitted source.hex (SHA-256: {hex_sha256[:16]}...)")
    print(f"\n[COMPILER PIPELINE COMPLETE] Artifacts saved in 'artifacts/v2.4.2/compiler/'\n")

    return True

if __name__ == "__main__":
    run_garuda_compiler_pipeline()
