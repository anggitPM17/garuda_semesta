#!/usr/bin/env python3
import os
import subprocess
import sys
import json

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports", "openlane")
    os.makedirs(reports_dir, exist_ok=True)

    print("=========================================================", flush=True)
    print(" GARUDA SEMESTA GEN2 — ASIC LOGIC SYNTHESIS (YOSYS / OPENLANE)", flush=True)
    print("=========================================================", flush=True)

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
        "rtl/multicore/garuda_hart_wrapper.v",
        "rtl/multicore/garuda_bus_arbiter.v",
        "rtl/multicore/garuda_response_router.v",
        "rtl/multicore/garuda_memory_interconnect.v",
        "rtl/memory/garuda_shared_ram.v",
        "rtl/interrupt/garuda_clint.v",
        "rtl/interrupt/garuda_mailbox.v",
        "rtl/multicore/garuda_4core_top.v"
    ]

    synth_script = os.path.join(reports_dir, "synth_yosys.ys")
    netlist_out = os.path.join(reports_dir, "garuda_4core_top_synth.v")
    synth_log = os.path.join(reports_dir, "yosys_synth.log")

    # Generate Yosys synthesis script
    with open(synth_script, "w", encoding="utf-8") as f:
        for s in sources:
            f.write(f"read_verilog -sv {os.path.join('/workspace', s)}\n")
        f.write("synth -top garuda_4core_top\n")
        f.write(f"write_verilog {os.path.join('/workspace', 'reports', 'openlane', 'garuda_4core_top_synth.v')}\n")
        f.write("stat\n")

    cmd = ["yosys", synth_script]
    print(f"Executing Yosys synthesis...", flush=True)
    res = subprocess.run(cmd, cwd=repo_dir, capture_output=True, text=True)

    with open(synth_log, "w", encoding="utf-8") as f:
        f.write(res.stdout + ("\n" + res.stderr if res.stderr else ""))

    print(res.stdout, flush=True)

    if res.returncode == 0 and "Printing statistics" in res.stdout:
        print("\n>>> ASIC LOGIC SYNTHESIS COMPLETED CLEANLY — SUCCESS (PASS) <<<", flush=True)
        sys.exit(0)
    else:
        print(f"\nASIC Logic Synthesis FAILED:\n{res.stderr}", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
