#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — CHIP V0.1 RTL COMPILATION & BUILD MANIFEST SCRIPT
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_ROOT}/build"
LOGS_DIR="${PROJECT_ROOT}/artifacts/chip_v0.1/logs"

mkdir -p "$BUILD_DIR" "$LOGS_DIR"

IVERILOG_BIN=$(which iverilog 2>/dev/null || echo "")

if [ -z "$IVERILOG_BIN" ]; then
    echo "[ERROR] iverilog compiler not found in PATH!"
    exit 1
fi

echo "========================================================================="
echo "GARUDA SEMESTA CHIP V0.1 — RTL COMPILATION (iverilog -g2012)"
echo "========================================================================="

RTL_CHIP_SOURCES=(
    "${PROJECT_ROOT}/src/peripherals/garuda_interrupt_controller.v"
    "${PROJECT_ROOT}/src/peripherals/garuda_timer.v"
    "${PROJECT_ROOT}/src/peripherals/garuda_uart.v"
    "${PROJECT_ROOT}/src/chip/garuda_chip_interconnect.v"
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
    "${PROJECT_ROOT}/src/chip/garuda_semesta_chip_top.v"
    "${PROJECT_ROOT}/tests/chip/tb_garuda_semesta_chip_v01.v"
)

OUT_VVP="${BUILD_DIR}/tb_garuda_semesta_chip_v01.vvp"

echo "[INFO] Compiling ${#RTL_CHIP_SOURCES[@]} Verilog modules into ${OUT_VVP}..."
"$IVERILOG_BIN" -g2012 -Wall -s tb_garuda_semesta_chip_v01 -o "$OUT_VVP" "${RTL_CHIP_SOURCES[@]}" 2>&1 | tee "${LOGS_DIR}/chip_rtl_compile.log"

echo "[SUCCESS] GARUDA SEMESTA CHIP V0.1 RTL Compiled successfully: ${OUT_VVP}"
exit 0
