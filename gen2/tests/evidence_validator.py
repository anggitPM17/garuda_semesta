#!/usr/bin/env python3
import os
import json
import hashlib
import sys

REQUIRED_FIELDS = [
    "schema_version",
    "commit_sha",
    "branch",
    "run_timestamp_utc",
    "toolchain",
    "source_manifest",
    "results"
]

def sha256_file(filepath):
    if not os.path.exists(filepath):
        return None
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def validate_evidence_package(json_path, expected_commit=None, expected_branch=None, repo_dir=None, require_clean=False):
    errors = []

    if not os.path.exists(json_path):
        return False, ["EVIDENCE_FILE_NOT_FOUND"]

    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        return False, [f"MALFORMED_JSON: {str(e)}"]

    if not isinstance(data, dict):
        return False, ["INVALID_EVIDENCE_FORMAT: top-level JSON must be an object"]

    # 1. Mandatory Field Presence Checks
    for field in REQUIRED_FIELDS:
        if field not in data or data[field] is None:
            errors.append(f"MISSING_REQUIRED_FIELD: {field}")

    if errors:
        return False, errors

    commit = data.get("commit_sha")
    branch = data.get("branch")
    timestamp = data.get("run_timestamp_utc")
    toolchain = data.get("toolchain")
    manifest = data.get("source_manifest")
    results = data.get("results", [])
    is_dirty = data.get("is_dirty", False)

    # 2. Commit SHA & Branch Match
    if not commit or len(commit) != 40:
        errors.append("INVALID_COMMIT_SHA_FORMAT")
    elif expected_commit and commit != expected_commit:
        errors.append(f"COMMIT_SHA_MISMATCH: expected {expected_commit}, got {commit}")

    if expected_branch and branch != expected_branch:
        errors.append(f"BRANCH_MISMATCH: expected {expected_branch}, got {branch}")

    # 3. Clean Tree Requirement
    if require_clean and is_dirty:
        errors.append("DIRTY_SOURCE_TREE: refusing to accept evidence from uncommitted workspace")

    # 4. Timestamp & Toolchain Integrity
    if not timestamp or not isinstance(timestamp, str):
        errors.append("MISSING_RUN_TIMESTAMP")

    if not toolchain or not isinstance(toolchain, dict) or not toolchain.get("compiler"):
        errors.append("MISSING_TOOLCHAIN_METADATA")

    # 5. Source Manifest Hashing Verification
    if not manifest or not isinstance(manifest, dict):
        errors.append("MISSING_SOURCE_MANIFEST")
    elif repo_dir:
        for rel_path, expected_hash in manifest.items():
            abs_path = os.path.join(repo_dir, rel_path)
            if not os.path.exists(abs_path):
                errors.append(f"MISSING_MANIFEST_SOURCE_FILE: {rel_path}")
            else:
                actual_hash = sha256_file(abs_path)
                if actual_hash != expected_hash:
                    errors.append(f"SOURCE_HASH_MISMATCH: {rel_path}")

    # 6. Results & Matrix Integrity
    if not results or not isinstance(results, list):
        errors.append("EMPTY_RESULTS")
    else:
        seen_ids = set()
        has_fail = False

        for item in results:
            cfg_id = item.get("config_id") or item.get("test_id")
            if not cfg_id:
                errors.append("MISSING_RESULT_ID")
            elif cfg_id in seen_ids:
                errors.append(f"DUPLICATE_RESULT_ID: {cfg_id}")
            else:
                seen_ids.add(cfg_id)

            status = item.get("result") or item.get("status")
            if status not in ["PASS", "FAIL"]:
                errors.append(f"INVALID_STATUS_VALUE: {status}")
            if status == "FAIL":
                has_fail = True

            # Check log existence and SHA-256 match
            sim_log = item.get("sim_log") or item.get("evidence_log")
            recorded_sha = item.get("sim_log_sha256")

            if sim_log:
                abs_log = os.path.abspath(sim_log) if repo_dir is None else os.path.join(repo_dir, sim_log)
                if not os.path.exists(abs_log):
                    errors.append(f"MISSING_LOG_FILE: {sim_log}")
                elif recorded_sha:
                    actual_sha = sha256_file(abs_log)
                    if actual_sha != recorded_sha:
                        errors.append(f"LOG_HASH_MISMATCH: {sim_log}")

        # Check for forged aggregate PASS when individual items failed
        aggregate_status = data.get("aggregate_status")
        if aggregate_status == "PASS" and has_fail:
            errors.append("FORGED_AGGREGATE_PASS: aggregate status claims PASS but individual tests failed")

    if errors:
        return False, errors
    return True, []

if __name__ == "__main__":
    if len(sys.argv) > 1:
        valid, errs = validate_evidence_package(sys.argv[1])
        print(f"Valid: {valid}, Errors: {errs}")
