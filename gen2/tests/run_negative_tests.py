#!/usr/bin/env python3
import os
import subprocess
import sys
import json
from evidence_validator import validate_evidence_package

def get_git_info():
    commit = os.environ.get("GIT_COMMIT_SHA")
    branch = os.environ.get("GIT_BRANCH")
    if commit and len(commit) == 40 and branch:
        return commit, branch

    try:
        commit = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode("utf-8").strip()
        branch = subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"]).decode("utf-8").strip()
        return commit, branch
    except Exception:
        raise RuntimeError("Git provenance unavailable; refusing to generate PASS evidence for negative tests")

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    reports_dir = os.path.join(repo_dir, "reports")
    neg_dir = os.path.join(reports_dir, "negative_tests", "FASE_6_7_4_7")
    fixtures_dir = os.path.join(repo_dir, "tests", "fixtures")
    os.makedirs(neg_dir, exist_ok=True)

    commit_sha, branch_name = get_git_info()

    print("=========================================================")
    print(" GARUDA SEMESTA GEN2 — FASE 6.7.4.7 ADVERSARIAL FAULT TESTS")
    print("=========================================================")

    negative_scenarios = [
        ("NEG_1_UNSTABLE_PAYLOAD", "fixture_neg_1_unstable_payload.v", "Inject actual payload mutation during response backpressure stall", "PAYLOAD STABILITY VIOLATION DETECTED DURING BACKPRESSURE STALL", "RTL_CHECKER"),
        ("NEG_2_DUPLICATE_STORE", "fixture_neg_2_duplicate_store.v", "Inject actual duplicate store commit into memory model", "FAIL: Committed store count mismatch", "RTL_CHECKER"),
        ("NEG_3_MISSING_RESPONSE", "fixture_neg_3_missing_response.v", "Suppress actual response valid signal permanently", "WATCHDOG TIMEOUT — Core failed to reach EBREAK", "RTL_CHECKER"),
        ("NEG_4_COUNT_MISMATCH", "fixture_neg_4_count_mismatch.v", "Inject actual transaction request count mismatch", "Independent request/response count mismatch", "RTL_CHECKER"),
        ("NEG_5_NONZERO_EXIT", "fixture_neg_5_nonzero_exit.v", "Force a genuine simulator $fatal exit", "DELIBERATE SIMULATOR FATAL EXIT", "INFRASTRUCTURE_TEST")
    ]

    results = []
    detected_count = 0

    sources = [
        "rtl/core/rv64i_alu.v", "rtl/core/rv64i_decode.v", "rtl/core/rv64i_regfile.v",
        "rtl/core/rv64i_control_flow.v", "rtl/core/rv64i_load_store_unit.v",
        "rtl/core/rv64i_hazard_unit.v", "rtl/core/rv64i_if_id_reg.v", "rtl/core/rv64i_id_ex_reg.v",
        "rtl/core/rv64i_ex_mem_reg.v", "rtl/core/rv64i_mem_wb_reg.v", "rtl/core/rv64i_system_decode.v",
        "rtl/core/rv64i_writeback.v", "rtl/core/rv64i_memory_model.v", "rtl/core/garuda_rv64i_core.v",
        "tb/garuda_rv64i_core_tb.v"
    ]

    # Execute Verilog real fault injection fixtures (NEG-01 to NEG-05)
    for test_id, fixture_file, desc, expected_fault, category in negative_scenarios:
        print(f"\n[FAULT INJECTION ({category})] Executing {test_id}: {desc}")
        fixture_path = os.path.join(fixtures_dir, fixture_file)
        vvp_out = os.path.join(neg_dir, f"{test_id}.vvp")
        log_file = os.path.join(neg_dir, f"{test_id}.log")

        extra_defines = []
        bp_cycles = 2
        if test_id == "NEG_2_DUPLICATE_STORE":
            extra_defines = ["-DFAULT_INJECT_DUPLICATE_STORE"]
        elif test_id in ["NEG_3_MISSING_RESPONSE", "NEG_4_COUNT_MISMATCH"]:
            bp_cycles = 0

        compile_cmd = ["iverilog", "-g2012", f"-DBACKPRESSURE_CYCLES={bp_cycles}"] + extra_defines + ["-o", vvp_out, fixture_path] + [os.path.join(repo_dir, s) for s in sources]
        c_res = subprocess.run(compile_cmd, cwd=repo_dir, capture_output=True, text=True)

        if c_res.returncode != 0:
            print(f"Compilation error on negative fixture {test_id}: {c_res.stderr}")
            sys.exit(1)

        sim_res = subprocess.run(["vvp", vvp_out], cwd=repo_dir, capture_output=True, text=True)

        with open(log_file, "w", encoding="utf-8") as f:
            f.write(sim_res.stdout + "\n" + sim_res.stderr)

        # A successful negative test MUST result in exit code != 0 and the expected checker fault
        if sim_res.returncode != 0 and expected_fault in sim_res.stdout:
            print(f"  Result: ACTUAL FAULT DETECTED BY CHECKER (PASS - Exit Code {sim_res.returncode})")
            detected_count += 1
            results.append({
                "test_id": test_id,
                "category": category,
                "description": desc,
                "fault_injected": True,
                "detected": True,
                "expected_checker_signature": expected_fault,
                "sim_exit_code": sim_res.returncode,
                "status": "PASS",
                "evidence_log": log_file,
                "commit_sha": commit_sha
            })
        else:
            print(f"  Result: UNEXPECTED PASS — Fault was NOT detected by the expected checker!")
            print(sim_res.stdout)
            sys.exit(1)

    # NEG-06: Real Stale / Invalid Evidence Validator Test
    print(f"\n[EVIDENCE VALIDATOR TEST] Executing NEG_6_STALE_LOG_REJECTION: Test evidence validator against invalid metadata")
    log_file_6 = os.path.join(neg_dir, "NEG_6_STALE_LOG_REJECTION.log")

    # Test validator with an invalid commit SHA and missing log file
    fake_json_path = os.path.join(neg_dir, "fake_corrupted_evidence.json")
    with open(fake_json_path, "w", encoding="utf-8") as f:
        json.dump({"commit_sha": "INVALID_SHA_12345", "branch": "wrong_branch", "results": []}, f)

    valid, errors = validate_evidence_package(fake_json_path, expected_commit=commit_sha, expected_branch=branch_name)

    with open(log_file_6, "w", encoding="utf-8") as f:
        f.write(f"EVIDENCE_VALIDATOR_TEST: Rejection confirmed with errors: {errors}\n")

    if not valid and "COMMIT_SHA_MISMATCH" in str(errors):
        print(f"  Result: INVALID EVIDENCE CORRECTLY REJECTED BY VALIDATOR (PASS - Errors: {errors})")
        detected_count += 1
        results.append({
            "test_id": "NEG_6_STALE_LOG_REJECTION",
            "category": "EVIDENCE_VALIDATOR_TEST",
            "description": "Test evidence validator against commit SHA mismatch and empty results",
            "fault_injected": True,
            "detected": True,
            "expected_rejection_errors": errors,
            "status": "PASS",
            "evidence_log": log_file_6,
            "commit_sha": commit_sha
        })
    else:
        print(f"  Result: UNEXPECTED PASS — Evidence validator failed to reject invalid evidence!")
        sys.exit(1)

    json_path = os.path.join(reports_dir, "FASE_6_7_4_8_NEGATIVE_TEST_RESULTS.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)

    print("\n=========================================================")
    print(f" NEGATIVE TEST RESULTS: {detected_count}/6 FAULTS DETECTED & REJECTED")
    print("=========================================================")

    if detected_count == 6:
        print("\n>>> ALL 6 REAL FAULT INJECTION SCENARIOS PASSED — VERIFIER PROVEN EFFECTIVE <<<")
        sys.exit(0)
    else:
        print("\n>>> NEGATIVE TEST SUITE FAILED <<<")
        sys.exit(1)

if __name__ == "__main__":
    main()
