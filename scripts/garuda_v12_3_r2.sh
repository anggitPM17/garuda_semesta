#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — TITAN V12 & CHIP V0.1 UNIFIED EDA CONTROL SCRIPT
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

CMD="${1:-all}"

case "$CMD" in
    inventory|audit)
        echo "========================================================================="
        echo "GARUDA SEMESTA CHIP V0.1 — HARDWARE INVENTORY & FORENSIC AUDIT"
        echo "========================================================================="
        cat "${PROJECT_ROOT}/docs/chip/GARUDA_SEMESTA_CHIP_ARCHITECTURE_V0_1.md"
        ;;
    environment)
        bash "${SCRIPT_DIR}/eda_environment_check.sh"
        ;;
    compile|compiler)
        bash "${SCRIPT_DIR}/garuda_chip_build.sh"
        ;;
    cpu-test|memory-test|cache-test|store|load|negative|integration-test|simulate|regression|all)
        python3 "${PROJECT_ROOT}/src/verification/garuda_v123_r2_runner.py"
        ;;
    waveform)
        echo "[INFO] VCD Waveform located at '${PROJECT_ROOT}/rtl_waveform.vcd'"
        ;;
    synthesis)
        cat "${PROJECT_ROOT}/reports/V12_1_SYNTHESIS_READINESS.md"
        ;;
    help|*)
        echo "Usage: $0 {audit|environment|compile|store|load|memory|cache|negative|integration|waveform|synthesis|regression|all}"
        ;;
esac
