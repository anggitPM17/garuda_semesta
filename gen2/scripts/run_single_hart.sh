#!/usr/bin/env sh
set -e

echo "=== Running Garuda RV64I Latency Test Suite (LATENCY = 0, 1, 3, 5) ==="
python /workspace/scripts/run_latency_tests.py
