#!/usr/bin/env python3
import os
import subprocess
import sys

LATENCIES = [0, 1, 3, 5]

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

    # 1. Generate program hex
    gen_script = os.path.join(repo_dir, "tests", "programs", "generate_program.py")
    res = subprocess.run([sys.executable, gen_script], capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Error generating program: {res.stderr}")
        sys.exit(1)
    print(res.stdout)

    sources = [
        "rtl/core/rv64i_alu.v",
        "rtl/core/rv64i_decode.v",
        "rtl/core/rv64i_regfile.v",
        "rtl/core/rv64i_control_flow.v",
        "rtl/core/rv64i_load_store_unit.v",
        "rtl/core/rv64i_hazard_unit.v",
        "rtl/core/rv64i_if_id_reg.v",
        "rtl/core/rv64i_id_ex_reg.v",
        "rtl/core/rv64i_ex_mem_reg.v",
        "rtl/core/rv64i_mem_wb_reg.v",
        "rtl/core/rv64i_system_decode.v",
        "rtl/core/rv64i_writeback.v",
        "rtl/core/rv64i_memory_model.v",
        "rtl/core/garuda_rv64i_core.v",
        "tb/garuda_rv64i_core_tb.v"
    ]

    all_passed = True
    results = {}

    for lat in LATENCIES:
        print(f"\n=========================================")
        print(f"Running Garuda RV64I Simulation (LATENCY = {lat})")
        print(f"=========================================")

        vvp_out = os.path.join(reports_dir, f"garuda_rv64i_lat_{lat}.vvp")
        compile_log = os.path.join(reports_dir, f"compile_latency_{lat}.log")
        sim_log = os.path.join(reports_dir, f"sim_latency_{lat}.log")

        compile_cmd = [
            "iverilog", "-g2012", "-Wall",
            "-s", "garuda_rv64i_core_tb",
            f"-DMEM_LATENCY={lat}",
            "-o", vvp_out
        ] + sources

        c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
        with open(compile_log, "w", encoding="utf-8") as f:
            f.write(c_res.stdout + "\n" + c_res.stderr)

        if c_res.returncode != 0:
            print(f"Compilation FAILED for LATENCY = {lat}:\n{c_res.stderr}")
            all_passed = False
            results[lat] = "FAIL (Compilation)"
            continue

        sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
        print(sim_res.stdout)
        if sim_res.stderr:
            print(sim_res.stderr)

        with open(sim_log, "w", encoding="utf-8") as f:
            f.write(sim_res.stdout + "\n" + sim_res.stderr)

        if sim_res.returncode == 0 and "SUCCESS (PASS)" in sim_res.stdout:
            print(f"Simulation PASSED for LATENCY = {lat}")
            results[lat] = "PASS"
        else:
            print(f"Simulation FAILED for LATENCY = {lat}")
            results[lat] = "FAIL"
            all_passed = False

    print("\n=========================================")
    print("      MULTI-LATENCY SUMMARY REPORT       ")
    print("=========================================")
    for lat in LATENCIES:
        print(f"  LATENCY = {lat}: {results[lat]}")
    print("=========================================")

    if all_passed:
        print("\n>>> ALL LATENCY TESTS PASSED (0, 1, 3, 5) — SUCCESS <<<")
        sys.exit(0)
    else:
        print("\n>>> MULTI-LATENCY TEST SUITE FAILED — NON-ZERO EXIT <<<")
        sys.exit(1)

if __name__ == "__main__":
    main()
