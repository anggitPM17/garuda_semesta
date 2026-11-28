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
        raise RuntimeError("Git provenance unavailable; refusing to generate PASS evidence for NPU tests") from exc

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)

    commit_sha, branch_name, is_dirty = get_git_provenance(repo_dir)

    print("=========================================================", flush=True)
    print(" GARUDA SEMESTA GEN4 — NPU AI ENGINE VERIFICATION", flush=True)
    print("=========================================================", flush=True)

    vvp_out = os.path.join(reports_dir, "garuda_npu_tb.vvp")
    compile_log = os.path.join(reports_dir, "compile_npu.log")
    sim_log = os.path.join(reports_dir, "sim_npu.log")

    sources = [
        "rtl/npu/garuda_systolic_array_8x8.v",
        "rtl/npu/garuda_npu_afu.v",
        "rtl/npu/garuda_npu_pooling.v",
        "rtl/npu/garuda_npu_quantizer.v",
        "rtl/npu/garuda_npu_top.v",
        "tb/garuda_npu_tb.v"
    ]

    compile_cmd = ["iverilog", "-g2012", "-Wall", "-s", "garuda_npu_tb", "-o", vvp_out] + [os.path.join(repo_dir, s) for s in sources]
    c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)

    with open(compile_log, "w", encoding="utf-8") as f:
        f.write(c_res.stdout + ("\n" + c_res.stderr if c_res.stderr else ""))

    if c_res.returncode != 0:
        print(f"Compilation FAILED for NPU testbench:\n{c_res.stderr}", flush=True)
        sys.exit(1)

    sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)
    print(sim_res.stdout, flush=True)

    with open(sim_log, "w", encoding="utf-8") as f:
        f.write(sim_res.stdout + ("\n" + sim_res.stderr if sim_res.stderr else ""))

    if sim_res.returncode == 0 and "ALL GEN4 NPU AI ENGINE TESTS PASSED" in sim_res.stdout:
        print("\n>>> GEN4 NPU AI ENGINE SIMULATION PASSED — SUCCESS <<<", flush=True)
        sys.exit(0)
    else:
        print("\n>>> GEN4 NPU AI ENGINE SIMULATION FAILED <<<", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
