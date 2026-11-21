#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA V12.2 — UNIFIED EDA CONTROL SCRIPT
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

CMD="${1:-all}"

case "$CMD" in
    inventory|audit)
        cat "${PROJECT_ROOT}/artifacts/v12.2/audit/root_cause_report.md"
        ;;
    environment)
        bash "${SCRIPT_DIR}/eda_environment_check.sh"
        ;;
    compile)
        bash "${SCRIPT_DIR}/garuda_rtl_compile.sh"
        ;;
    simulate|test|regression|all)
        python3 "${PROJECT_ROOT}/src/verification/garuda_titan_v12_integration_runner.py"
        ;;
    waveform)
        echo "[INFO] VCD Waveform located at '${PROJECT_ROOT}/artifacts/v12.2/waveforms/rtl_execution.vcd'"
        ;;
    synthesis)
        cat "${PROJECT_ROOT}/artifacts/v12.2/reports/eda_synthesis_report.md"
        ;;
    help|*)
        echo "Usage: $0 {audit|environment|compile|simulate|test|waveform|synthesis|regression|all}"
        ;;
esac
