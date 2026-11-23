#!/usr/bin/env python3
import os
import subprocess
import sys

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

    print("\n=========================================")
    print("Running Single-Hart Simulation (LATENCY = 0)")
    print("=========================================")

    vvp_out = os.path.join(reports_dir, "garuda_rv64i_lat_0.vvp")
    log_out = os.path.join(reports_dir, "sim_latency_0.log")

    compile_cmd = [
        "iverilog", "-g2012", "-Wall",
        "-s", "garuda_rv64i_core_tb",
        "-DMEM_LATENCY=0",
        "-o", vvp_out
    ] + sources

    c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)
    if c_res.returncode != 0:
        print(f"Compilation FAILED:\n{c_res.stderr}")
        sys.exit(1)

    sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
    print(sim_res.stdout)
    if sim_res.stderr:
        print(sim_res.stderr)

    with open(log_out, "w", encoding="utf-8") as log_file:
        log_file.write(sim_res.stdout + "\n" + sim_res.stderr)

    if sim_res.returncode != 0 or "SUCCESS (PASS)" not in sim_res.stdout:
        print("Simulation FAILED for LATENCY = 0")
        sys.exit(1)
    else:
        print("Simulation PASSED for LATENCY = 0")
        sys.exit(0)

if __name__ == "__main__":
    main()
