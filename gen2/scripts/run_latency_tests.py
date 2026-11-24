#!/usr/bin/env python3
import os
import subprocess
import sys
import json
import re

LATENCIES = [0, 1, 3, 5]
BACKPRESSURES = [0, 1, 2, 4, 8]

def parse_scoreboard_metrics(stdout):
    metrics = {
        "read_tx": None,
        "write_tx": None,
        "committed_stores": None,
        "total_resp": None,
        "duplicate_tx": None,
        "stability_violations": None
    }

    m_read = re.search(r"Read Accepted Transactions \(LD\)\s*=\s*(\d+)", stdout)
    if m_read: metrics["read_tx"] = int(m_read.group(1))

    m_write = re.search(r"Write Accepted Transactions \(ST\)\s*=\s*(\d+)", stdout)
    if m_write: metrics["write_tx"] = int(m_write.group(1))

    m_commit = re.search(r"Committed Store Count\s*=\s*(\d+)", stdout)
    if m_commit: metrics["committed_stores"] = int(m_commit.group(1))

    m_resp = re.search(r"Total Responses Issued\s*=\s*(\d+)", stdout)
    if m_resp: metrics["total_resp"] = int(m_resp.group(1))

    m_dup = re.search(r"Duplicate Transactions\s*=\s*(\d+)", stdout)
    if m_dup: metrics["duplicate_tx"] = int(m_dup.group(1))

    m_stab = re.search(r"Payload Stability Violations\s*=\s*(\d+)", stdout)
    if m_stab: metrics["stability_violations"] = int(m_stab.group(1))

    return metrics

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

    # 1. Generate program hex
    gen_script = os.path.join(repo_dir, "tests", "programs", "generate_program.py")
    res = subprocess.run([sys.executable, gen_script], capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Error generating program: {res.stderr}", flush=True)
        sys.exit(1)
    print(res.stdout, flush=True)

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
            print(f"\n=========================================", flush=True)
            print(f"Running Garuda RV64I Simulation ({config_id})", flush=True)
            print(f"=========================================", flush=True)

            vvp_out = os.path.join(reports_dir, f"garuda_rv64i_lat_{lat}_bp_{bp}.vvp")
            compile_log = os.path.join(reports_dir, f"compile_latency_{lat}_bp_{bp}.log")
            sim_log = os.path.join(reports_dir, f"sim_latency_{lat}_bp_{bp}.log")

            compile_cmd = [
                "iverilog", "-g2012", "-Wall",
                "-s", "garuda_rv64i_core_tb",
                f"-DMEM_LATENCY={lat}",
                f"-DBACKPRESSURE_CYCLES={bp}",
                "-o", vvp_out
            ] + sources

            c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
            compile_output = c_res.stdout + ("\n" + c_res.stderr if c_res.stderr else "")
            if not compile_output.strip():
                compile_output = f"Compilation completed cleanly for {config_id} with exit code {c_res.returncode}.\n"

            with open(compile_log, "w", encoding="utf-8") as f:
                f.write(compile_output)

            if c_res.returncode != 0:
                print(f"Compilation FAILED for {config_id}:\n{c_res.stderr}", flush=True)
                all_passed = False
                results[config_id] = "FAIL (Compilation)"
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": c_res.returncode, "sim_exit": -1, "result": "FAIL"
                })
                continue

            sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
            print(sim_res.stdout, flush=True)
            if sim_res.stderr:
                print(sim_res.stderr, flush=True)

            with open(sim_log, "w", encoding="utf-8") as f:
                f.write(sim_res.stdout + ("\n" + sim_res.stderr if sim_res.stderr else ""))

            # Dynamically parse simulation stdout
            parsed = parse_scoreboard_metrics(sim_res.stdout)

            passed_checks = (
                sim_res.returncode == 0 and
                "SUCCESS (PASS)" in sim_res.stdout and
                "FAILURE" not in sim_res.stdout and
                parsed["read_tx"] == 4 and
                parsed["write_tx"] == 4 and
                parsed["committed_stores"] == 4 and
                parsed["total_resp"] == 8 and
                parsed["duplicate_tx"] == 0 and
                parsed["stability_violations"] == 0
            )

            if passed_checks:
                print(f"Simulation PASSED for {config_id}", flush=True)
                results[config_id] = "PASS"
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": 0, "sim_exit": 0,
                    "read_tx": parsed["read_tx"],
                    "write_tx": parsed["write_tx"],
                    "committed_stores": parsed["committed_stores"],
                    "total_resp": parsed["total_resp"],
                    "duplicate_tx": parsed["duplicate_tx"],
                    "stability_violations": parsed["stability_violations"],
                    "result": "PASS"
                })
            else:
                print(f"Simulation FAILED for {config_id}", flush=True)
                results[config_id] = "FAIL"
                all_passed = False
                json_results.append({
                    "config_id": config_id, "latency": lat, "backpressure": bp,
                    "compile_exit": 0, "sim_exit": sim_res.returncode,
                    "parsed_metrics": parsed,
                    "result": "FAIL"
                })

    # Save JSON summary
    json_path = os.path.join(reports_dir, "FASE_6_7_4_3_REGRESSION_RESULTS.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(json_results, f, indent=2)

    print("\n=========================================", flush=True)
    print("      MULTI-LATENCY x BACKPRESSURE MATRIX", flush=True)
    print("=========================================", flush=True)
    for config_id, status in results.items():
        print(f"  {config_id:<20}: {status}", flush=True)
    print("=========================================", flush=True)

    if all_passed:
        print(f"\n>>> ALL {len(results)}/20 CONFIGURATIONS PASSED — SUCCESS <<<", flush=True)
        sys.exit(0)
    else:
        print("\n>>> REGRESSION MATRIX FAILED — NON-ZERO EXIT <<<", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
