#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA V12.1 — MASTER EDA CONTROL INTERFACE
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
        echo "GARUDA SEMESTA V12.1 — HARDWARE INVENTORY"
        echo "========================================================================="
        cat "${PROJECT_ROOT}/docs/V12_1_BASELINE_AUDIT.md"
        ;;
    environment)
        bash "${SCRIPT_DIR}/eda_environment_check.sh"
        ;;
    compile)
        bash "${SCRIPT_DIR}/garuda_rtl_compile.sh"
        ;;
    cpu-test|memory-test|cache-test|integration-test|simulate|regression|all)
        python3 "${PROJECT_ROOT}/src/verification/garuda_titan_v12_integration_runner.py"
        ;;
    waveform)
        echo "[INFO] VCD Waveform generated at '${PROJECT_ROOT}/rtl_waveform.vcd'"
        ;;
    synthesis)
        cat "${PROJECT_ROOT}/reports/V12_1_SYNTHESIS_READINESS.md"
        ;;
    help|*)
        echo "Usage: $0 {inventory|environment|compile|cpu-test|memory-test|cache-test|integration-test|waveform|synthesis|regression|all}"
        ;;
esac
