#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA V12.1 — REAL RTL COMPILATION SCRIPT
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_ROOT}/build"
LOGS_DIR="${PROJECT_ROOT}/artifacts/titan-v12-r2/logs"

mkdir -p "$BUILD_DIR" "$LOGS_DIR"

IVERILOG_BIN=$(which iverilog 2>/dev/null || echo "")

if [ -z "$IVERILOG_BIN" ]; then
    echo "[ERROR] iverilog compiler not found in PATH!"
    exit 1
fi

echo "========================================================================="
echo "GARUDA SEMESTA V12.1 — RTL COMPILATION (iverilog -g2012)"
echo "========================================================================="

RTL_SOURCES=(
    "${PROJECT_ROOT}/src/memory/garuda_bus_adapter_64to32.v"
    "${PROJECT_ROOT}/src/memory/garuda_l1_icache.v"
    "${PROJECT_ROOT}/src/memory/garuda_l1_dcache.v"
    "${PROJECT_ROOT}/src/memory/garuda_l2_cache.v"
    "${PROJECT_ROOT}/src/memory/garuda_memory_arbiter.v"
    "${PROJECT_ROOT}/src/memory/garuda_memory_controller.v"
    "${PROJECT_ROOT}/src/memory/garuda_memory_subsystem_top.v"
    "${PROJECT_ROOT}/src/cpu/garuda_pc.v"
    "${PROJECT_ROOT}/src/cpu/garuda_idecode.v"
    "${PROJECT_ROOT}/src/cpu/garuda_regfile.v"
    "${PROJECT_ROOT}/src/cpu/garuda_alu.v"
    "${PROJECT_ROOT}/src/cpu/garuda_cpu_pipeline_top.v"
    "${PROJECT_ROOT}/src/integration/garuda_vertical_slice_top.v"
    "${PROJECT_ROOT}/src/integration/tb_garuda_vertical_slice_v24_6.v"
)

OUT_VVP="${BUILD_DIR}/garuda_titan_v12_r2.vvp"

echo "[INFO] Compiling ${#RTL_SOURCES[@]} Verilog modules into ${OUT_VVP}..."
"$IVERILOG_BIN" -g2012 -Wall -s tb_garuda_vertical_slice_v24_6 -o "$OUT_VVP" "${RTL_SOURCES[@]}" 2>&1 | tee "${LOGS_DIR}/rtl_compile.log"

echo "[SUCCESS] RTL Compiled successfully: ${OUT_VVP}"
exit 0
