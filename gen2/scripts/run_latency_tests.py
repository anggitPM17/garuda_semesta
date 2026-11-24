#!/usr/bin/env python3
import os
import subprocess
import sys
import json

LATENCIES = [0, 1, 3, 5]
BACKPRESSURES = [0, 1, 2, 4, 8]

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
    json_results = []

    for lat in LATENCIES:
        for bp in BACKPRESSURES:
            config_id = f"LATENCY={lat}_BP={bp}"
            print(f"\n=========================================")
            print(f"Running Garuda RV64I Simulation ({config_id})")
            print(f"=========================================")

            vvp_out = os.path.join(reports_dir, f"garuda_rv64i_lat_{lat}_bp_{bp}.vvp")
            compile_log = os.path.join(reports_dir, f"compile_latency_{lat}_bp_{bp}.log")
            sim_log = os.path.join(reports_dir, f"sim_latency_{lat}_bp_{bp}.log")

            # Remove stale logs
            if os.path.exists(compile_log): os.remove(compile_log)
            if os.path.exists(sim_log): os.remove(sim_log)

            compile_cmd = [
                "iverilog", "-g2012", "-Wall",
                "-s", "garuda_rv64i_core_tb",
                f"-DMEM_LATENCY={lat}",
                f"-DBACKPRESSURE_CYCLES={bp}",
                "-o", vvp_out
            ] + sources

            c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
            with open(compile_log, "w", encoding="utf-8") as f:
                f.write(c_res.stdout + "\n" + c_res.stderr)

            if c_res.returncode != 0:
                print(f"Compilation FAILED for {config_id}:\n{c_res.stderr}")
                all_passed = False
                results[config_id] = "FAIL (Compilation)"
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": c_res.returncode, "sim_exit": -1, "result": "FAIL"
                })
                continue

            sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
            print(sim_res.stdout)
            if sim_res.stderr:
                print(sim_res.stderr)

            with open(sim_log, "w", encoding="utf-8") as f:
                f.write(sim_res.stdout + "\n" + sim_res.stderr)

            passed_checks = (
                sim_res.returncode == 0 and
                "SUCCESS (PASS)" in sim_res.stdout and
                "FAILURE" not in sim_res.stdout and
                "Read Accepted Transactions (LD)  = 4" in sim_res.stdout and
                "Write Accepted Transactions (ST) = 4" in sim_res.stdout and
                "Committed Store Count            = 4" in sim_res.stdout and
                "Total Responses Issued           = 8" in sim_res.stdout and
                "Duplicate Transactions           = 0" in sim_res.stdout and
                "Payload Stability Violations    = 0" in sim_res.stdout
            )

            if passed_checks:
                print(f"Simulation PASSED for {config_id}")
                results[config_id] = "PASS"
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": 0, "sim_exit": 0,
                    "read_tx": 4, "write_tx": 4, "committed_stores": 4, "total_resp": 8,
                    "duplicate_tx": 0, "stability_violations": 0, "result": "PASS"
                })
            else:
                print(f"Simulation FAILED for {config_id}")
                results[config_id] = "FAIL"
                all_passed = False
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": 0, "sim_exit": sim_res.returncode, "result": "FAIL"
                })

    # Save JSON summary
    json_path = os.path.join(reports_dir, "FASE_6_7_4_2_REGRESSION_RESULTS.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(json_results, f, indent=2)

    print("\n=========================================")
    print("      MULTI-LATENCY x BACKPRESSURE MATRIX")
    print("=========================================")
    for config_id, status in results.items():
        print(f"  {config_id:<20}: {status}")
    print("=========================================")

    if all_passed:
        print(f"\n>>> ALL {len(results)}/20 CONFIGURATIONS PASSED — SUCCESS <<<")
        sys.exit(0)
    else:
        print("\n>>> REGRESSION MATRIX FAILED — NON-ZERO EXIT <<<")
        sys.exit(1)

if __name__ == "__main__":
    main()
