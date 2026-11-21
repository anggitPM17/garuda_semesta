#!/usr/bin/env python3
"""
GARUDA SEMESTA — TITAN V12.5 & V12.6 MASTER CHIP EXECUTION RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0
"""

import sys
import os

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from src.verification.garuda_master_chip_runner import GarudaMasterChipRunner

if __name__ == "__main__":
    runner = GarudaMasterChipRunner()
    success = runner.run_full_v126_pipeline()
    sys.exit(0 if success else 1)
