#!/usr/bin/env python3
import os
import subprocess
import sys

LATENCIES = [0, 1, 3, 5]

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

    # First generate program hex
    gen_script = os.path.join(repo_dir, "tests", "programs", "generate_program.py")
    res = subprocess.run([sys.executable, gen_script], capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Error generating program: {res.stderr}")
        sys.exit(1)
    print(res.stdout)

    all_passed = True

    for lat in LATENCIES:
        print(f"\n=========================================")
        print(f"Running Single-Hart Simulation (LATENCY = {lat})")
        print(f"=========================================")

        # Modify rv64i_memory_model.v parameter LATENCY or compile with macro / sed / rewrite
        # Since we can edit rv64i_memory_model.v parameter or use a macro:
        # Let's update memory model parameter LATENCY in rv64i_memory_model.v temporarily or pass override
        memory_model_path = os.path.join(repo_dir, "rtl", "core", "rv64i_memory_model.v")
        with open(memory_model_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Replace parameter LATENCY = N
        import re
        new_content = re.sub(r'parameter\s+LATENCY\s*=\s*\d+', f'parameter LATENCY = {lat}', content)
        with open(memory_model_path, "w", encoding="utf-8") as f:
            f.write(new_content)

        # Compile
        vvp_out = os.path.join(reports_dir, f"garuda_rv64i_lat_{lat}.vvp")
        log_out = os.path.join(reports_dir, f"sim_latency_{lat}.log")

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

        compile_cmd = ["iverilog", "-g2012", "-Wall", "-s", "garuda_rv64i_core_tb", "-o", vvp_out] + sources
        c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
        if c_res.returncode != 0:
            print(f"Compilation FAILED for LATENCY = {lat}:\n{c_res.stderr}")
            all_passed = False
            continue

        # Run simulation
        sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
        print(sim_res.stdout)
        if sim_res.stderr:
            print(sim_res.stderr)

        with open(log_out, "w", encoding="utf-8") as log_file:
            log_file.write(sim_res.stdout + "\n" + sim_res.stderr)

        if sim_res.returncode != 0 or "SUCCESS (PASS)" not in sim_res.stdout:
            print(f"Simulation FAILED for LATENCY = {lat}")
            all_passed = False
        else:
            print(f"Simulation PASSED for LATENCY = {lat}")

    if all_passed:
        print("\n>>> ALL LATENCY TESTS PASSED (0, 1, 3, 5) — SUCCESS <<<")
        sys.exit(0)
    else:
        print("\n>>> LATENCY TESTS FAILED <<<")
        sys.exit(1)

if __name__ == "__main__":
    main()
