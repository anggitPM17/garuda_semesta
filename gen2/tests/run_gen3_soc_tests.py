#!/usr/bin/env python3
import os
import subprocess
import sys
import json

def get_git_provenance(repo_dir):
    commit_sha = os.environ.get("GIT_COMMIT_SHA")
    branch = os.environ.get("GIT_BRANCH")
    if commit_sha and len(commit_sha) == 40 and branch:
        return commit_sha, branch, False

    try:
        commit_sha = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=repo_dir, stderr=subprocess.STDOUT, text=True
        ).strip()
        branch = subprocess.check_output(
            ["git", "branch", "--show-current"], cwd=repo_dir, stderr=subprocess.STDOUT, text=True
        ).strip()
        dirty = subprocess.check_output(
            ["git", "status", "--porcelain"], cwd=repo_dir, stderr=subprocess.STDOUT, text=True
        ).strip()
        if not branch:
            branch = "generation-2"
        return commit_sha, branch, bool(dirty)
    except Exception as exc:
        raise RuntimeError("Git provenance unavailable; refusing to generate PASS evidence for Gen3 SoC tests") from exc

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

    commit_sha, branch_name, is_dirty = get_git_provenance(repo_dir)

    print("=========================================================", flush=True)
    print(" GARUDA SEMESTA GEN3 — HETEROGENEOUS SOC VERIFICATION", flush=True)
    print("=========================================================", flush=True)

    vvp_out = os.path.join(reports_dir, "garuda_gen3_soc_tb.vvp")
    compile_log = os.path.join(reports_dir, "compile_gen3_soc.log")
    sim_log = os.path.join(reports_dir, "sim_gen3_soc.log")

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
        "rtl/multicore/garuda_4core_top.v",
        "rtl/gpu/garuda_vector_register_file.v",
        "rtl/gpu/garuda_vector_alu.v",
        "rtl/gpu/garuda_vpu_top.v",
        "rtl/security/garuda_crypto_engine.v",
        "rtl/display/garuda_framebuffer_controller.v",
        "rtl/soc/garuda_gen3_heterogeneous_soc.v",
        "tb/garuda_gen3_soc_tb.v"
    ]

    compile_cmd = ["iverilog", "-g2012", "-Wall", "-s", "garuda_gen3_soc_tb", "-o", vvp_out] + [os.path.join(repo_dir, s) for s in sources]
    c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)

    with open(compile_log, "w", encoding="utf-8") as f:
        f.write(c_res.stdout + ("\n" + c_res.stderr if c_res.stderr else ""))

    if c_res.returncode != 0:
        print(f"Compilation FAILED for Gen3 SoC testbench:\n{c_res.stderr}", flush=True)
        sys.exit(1)

    sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
    print(sim_res.stdout, flush=True)

    with open(sim_log, "w", encoding="utf-8") as f:
        f.write(sim_res.stdout + ("\n" + sim_res.stderr if sim_res.stderr else ""))

    if sim_res.returncode == 0 and "GEN3 HETEROGENEOUS SOC TEST PASSED" in sim_res.stdout:
        print("\n>>> GEN3 HETEROGENEOUS SOC SIMULATION PASSED — SUCCESS <<<", flush=True)
        sys.exit(0)
    else:
        print("\n>>> GEN3 HETEROGENEOUS SOC SIMULATION FAILED <<<", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
