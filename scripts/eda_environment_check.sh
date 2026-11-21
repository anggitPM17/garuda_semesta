#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — EDA ENVIRONMENT AUDIT SCRIPT (v12.4.6-R2)
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# =========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "========================================================================="
echo "GARUDA SEMESTA V12.1 — EDA WORKSTATION ENVIRONMENT AUDIT"
echo "========================================================================="

check_tool() {
    local tool_name="$1"
    local tool_bin
    tool_bin=$(which "$tool_name" 2>/dev/null || echo "")
    if [ -n "$tool_bin" ]; then
        local version_str
        version_str=$("$tool_bin" --version 2>&1 | head -n 1 || echo "Available")
        echo "[AVAILABLE] ${tool_name}: ${tool_bin} (${version_str})"
    else
        echo "[BLOCKED] ${tool_name}: Not found in PATH"
    fi
}

echo "[INFO] Container / Host Operating System: $(uname -a)"
echo "[INFO] Python Version: $(python3 --version 2>&1)"
echo ""

echo "--- EDA Tool Audit ---"
check_tool iverilog
check_tool vvp
check_tool verilator
check_tool yosys
check_tool openlane
check_tool gtkwave
check_tool make
check_tool gcc
check_tool git

echo "========================================================================="
exit 0
