#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — UNIFIED EDA CLI INTERFACE (v12.4.6-R2)
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

CMD="${1:-help}"

case "$CMD" in
    inventory)
        echo "========================================================================="
        echo "GARUDA SEMESTA — HARDWARE INVENTORY"
        echo "========================================================================="
        cat "${PROJECT_ROOT}/docs/RTL_RECOVERY_INVENTORY.md"
        ;;
    compile)
        bash "${SCRIPT_DIR}/rtl_compile.sh"
        ;;
    simulate|test)
        python3 "${PROJECT_ROOT}/src/verification/garuda_titan_v12_integration_runner.py"
        ;;
    memory-test)
        bash "${SCRIPT_DIR}/rtl_simulate.sh"
        ;;
    cache-test)
        bash "${SCRIPT_DIR}/rtl_simulate.sh"
        ;;
    waveform)
        echo "[INFO] VCD Waveform dumped at '${PROJECT_ROOT}/rtl_waveform.vcd'"
        ;;
    help|*)
        echo "Usage: $0 {inventory|compile|simulate|memory-test|cache-test|waveform|test}"
        ;;
esac
