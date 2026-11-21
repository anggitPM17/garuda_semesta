#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — RTL SIMULATION EXECUTION SCRIPT (v12.4.6-R2)
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_ROOT}/build"
LOGS_DIR="${PROJECT_ROOT}/artifacts/titan-v12-r2/logs"

VVP_BIN=$(which vvp || echo "")

if [ -z "$VVP_BIN" ]; then
    echo "[ERROR] vvp simulation runtime not found in PATH!"
    exit 1
fi

OUT_VVP="${BUILD_DIR}/garuda_titan_v12_r2.vvp"

if [ ! -f "$OUT_VVP" ]; then
    echo "[INFO] VVP binary not found. Triggering compilation..."
    "${SCRIPT_DIR}/rtl_compile.sh"
fi

echo "========================================================================="
echo "GARUDA SEMESTA — RTL VVP SIMULATION EXECUTION"
echo "========================================================================="

"$VVP_BIN" "$OUT_VVP" 2>&1 | tee "${LOGS_DIR}/rtl_simulation.log"

if grep -q "PASS: REAL RTL SRAM READBACK VERIFIED" "${LOGS_DIR}/rtl_simulation.log"; then
    echo "[SUCCESS] RTL Simulation Executed & Verified (SRAM[0x80000100] == 500)."
    exit 0
else
    echo "[FAIL] RTL Simulation Failed or Readback Mismatched!"
    exit 1
fi
