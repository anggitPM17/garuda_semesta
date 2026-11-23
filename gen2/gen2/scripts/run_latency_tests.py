#!/usr/bin/env python3
import os
import subprocess
import sys

LATENCIES = [0, 1, 3, 5]

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

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

    lat_0_passed = False

    for lat in LATENCIES:
        print(f"\n=========================================")
        print(f"Running Single-Hart Simulation (LATENCY = {lat})")
        print(f"=========================================")

        vvp_out = os.path.join(reports_dir, f"garuda_rv64i_lat_{lat}.vvp")
        log_out = os.path.join(reports_dir, f"sim_latency_{lat}.log")

        # Edit memory model parameter LATENCY for this run without persistent regex corruption of source
        model_path = os.path.join(repo_dir, "rtl", "core", "rv64i_memory_model.v")
        with open(model_path, "r", encoding="utf-8") as f:
            content = f.read()

        import re
        new_content = re.sub(r'parameter LATENCY = \d+', f'parameter LATENCY = {lat}', content)
        with open(model_path, "w", encoding="utf-8") as f:
            f.write(new_content)

        compile_cmd = [
            "iverilog", "-g2012", "-Wall",
            "-s", "garuda_rv64i_core_tb",
            "-o", vvp_out
        ] + sources

        c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
        if c_res.returncode != 0:
            print(f"Compilation FAILED for LATENCY = {lat}:\n{c_res.stderr}")
            continue

        sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
        print(sim_res.stdout)
        if sim_res.stderr:
            print(sim_res.stderr)

        with open(log_out, "w", encoding="utf-8") as log_file:
            log_file.write(sim_res.stdout + "\n" + sim_res.stderr)

        if sim_res.returncode == 0 and "SUCCESS (PASS)" in sim_res.stdout:
            print(f"Simulation PASSED for LATENCY = {lat}")
            if lat == 0:
                lat_0_passed = True
        else:
            print(f"Simulation FAILED for LATENCY = {lat}")

        # Restore model parameter to 0
        with open(model_path, "w", encoding="utf-8") as f:
            f.write(content)

    if lat_0_passed:
        print("\n>>> FASE 6.3 SIGN-OFF: LATENCY 0 BASELINE PASSED SUCCESSFULLY — SUCCESS <<<")
        sys.exit(0)
    else:
        print("\n>>> LATENCY TESTS FAILED <<<")
        sys.exit(1)

if __name__ == "__main__":
    main()
