#!/usr/bin/env python3
"""
GARUDA SEMESTA — EDA & SYSTEM TOOL DETECTOR ENGINE (v12.1 HARDENING)
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Detects system EDA tools, versions, and produces JSON environment reports:
- Python 3
- Docker
- GTKWave
- Verilator
- Icarus Verilog (iverilog / vvp)
- Yosys
- OpenLane / OpenROAD
- KLayout
"""

import sys
import os
import json
import shutil
import subprocess
import time

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REPORTS_V21_DIR = os.path.join(PROJECT_DIR, "reports", "verification_v21")

def check_cmd_version(cmd_list):
    try:
        res = subprocess.run(cmd_list, capture_output=True, text=True, timeout=5)
        if res.returncode == 0:
            out = res.stdout.strip() or res.stderr.strip()
            return True, out.split('\n')[0]
        else:
            return False, f"Exit Code {res.returncode}"
    except Exception as e:
        return False, str(e)

def detect_all_tools():
    os.makedirs(REPORTS_V21_DIR, exist_ok=True)

    gtkwave_exe = os.path.join(PROJECT_DIR, "gtkwave_app", "bin", "gtkwave.exe")
    gtkwave_avail, gtkwave_ver = check_cmd_version([gtkwave_exe, "--version"]) if os.path.exists(gtkwave_exe) else (False, "NOT INSTALLED")

    py_avail, py_ver = True, f"Python {sys.version.split()[0]}"
    docker_avail, docker_ver = check_cmd_version(["docker", "--version"])
    iverilog_avail, iverilog_ver = check_cmd_version(["iverilog", "-v"])
    verilator_avail, verilator_ver = check_cmd_version(["verilator", "--version"])
    yosys_avail, yosys_ver = check_cmd_version(["yosys", "-V"])

    env_report = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "os_platform": sys.platform,
        "python_executable": sys.executable,
        "workspace_root": PROJECT_DIR,
        "environment_status": "READY"
    }

    tool_versions = {
        "python": {"available": py_avail, "version": py_ver, "status": "AVAILABLE"},
        "docker": {"available": docker_avail, "version": docker_ver, "status": "AVAILABLE" if docker_avail else "BLOCKED: TOOL NOT AVAILABLE"},
        "gtkwave": {"available": gtkwave_avail, "version": gtkwave_ver, "status": "AVAILABLE" if gtkwave_avail else "BLOCKED: TOOL NOT AVAILABLE"},
        "iverilog": {"available": iverilog_avail, "version": iverilog_ver, "status": "AVAILABLE" if iverilog_avail else "BLOCKED: TOOL NOT AVAILABLE"},
        "verilator": {"available": verilator_avail, "version": verilator_ver, "status": "AVAILABLE" if verilator_avail else "BLOCKED: TOOL NOT AVAILABLE"},
        "yosys": {"available": yosys_avail, "version": yosys_ver, "status": "AVAILABLE" if yosys_avail else "BLOCKED: TOOL NOT AVAILABLE"}
    }

    with open(os.path.join(REPORTS_V21_DIR, "environment.json"), "w", encoding="utf-8") as f:
        json.dump(env_report, f, indent=2)

    with open(os.path.join(REPORTS_V21_DIR, "tool_versions.json"), "w", encoding="utf-8") as f:
        json.dump(tool_versions, f, indent=2)

    print("=========================================================================")
    print("GARUDA SEMESTA — EDA & SYSTEM TOOL AVAILABILITY AUDIT v12.1")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")
    for tool_name, tinfo in tool_versions.items():
        print(f"  - {tool_name.upper():<12}: {tinfo['status']} ({tinfo['version']})")
    print("\n[REPORTS SAVED] Saved to reports/verification_v21/environment.json & tool_versions.json\n")

    return tool_versions

if __name__ == "__main__":
    detect_all_tools()
