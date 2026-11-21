#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — TITAN V12-R3 MASTER CONTROL SCRIPT
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

CMD="${1:-all}"

case "$CMD" in
    inventory)
        echo "========================================================================="
        echo "GARUDA SEMESTA V12-R3 — HARDWARE INVENTORY & AUDIT"
        echo "========================================================================="
        cat "${PROJECT_ROOT}/docs/V12_1_BASELINE_AUDIT.md"
        ;;
    environment)
        bash "${SCRIPT_DIR}/eda_environment_check.sh"
        ;;
    compile|compiler)
        bash "${SCRIPT_DIR}/garuda_rtl_compile.sh"
        ;;
    cpu-test|memory-test|cache-test|store|fetch|negative|integration-test|simulate|regression|all)
        python3 "${PROJECT_ROOT}/src/verification/garuda_titan_v12_integration_runner.py"
        ;;
    waveform)
        echo "[INFO] Waveform VCD generated at '${PROJECT_ROOT}/rtl_waveform.vcd'"
        ;;
    synthesis)
        cat "${PROJECT_ROOT}/reports/V12_1_SYNTHESIS_READINESS.md"
        ;;
    help|*)
        echo "Usage: $0 {inventory|environment|compile|fetch|store|memory|cache|negative|integration|waveform|synthesis|regression|all}"
        ;;
esac
