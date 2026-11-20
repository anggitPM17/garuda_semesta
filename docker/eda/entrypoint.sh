#!/usr/bin/env bash
# =========================================================================
# GARUDA SEMESTA — EDA DOCKER CONTAINER ENTRYPOINT SCRIPT v12.3.2-R6.4
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# Licensed under the Apache License, Version 2.0
# =========================================================================

set -e

echo "========================================================================="
echo "GARUDA SEMESTA — EDA DOCKER WORKSTATION CONTAINER v12.3.2-R6.4"
echo "Architect & Author: Anggit Prasetyo Mituhu"
echo "========================================================================="
echo ""
echo "[EDA CONTAINER INFO] Verifying Installed Hardware EDA Tools..."
echo "  - Python Version  : $(python3 --version)"
echo "  - Icarus Verilog : $(iverilog -v 2>&1 | head -n 1)"
echo "  - VVP Runtime    : $(vvp -V 2>&1 | head -n 1)"
echo "  - GTKWave        : $(gtkwave --version 2>&1 | head -n 1)"
echo "========================================================================="
echo ""

exec "$@"
