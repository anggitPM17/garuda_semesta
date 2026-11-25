#!/usr/bin/env python3
import os
import json
import hashlib
import sys

def sha256_file(filepath):
    if not os.path.exists(filepath):
        return None
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def validate_evidence_package(json_path, expected_commit=None, expected_branch=None, expected_manifest_path=None):
    errors = []

    if not os.path.exists(json_path):
        return False, ["EVIDENCE_FILE_NOT_FOUND"]

    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        return False, [f"JSON_PARSE_ERROR: {str(e)}"]

    if isinstance(data, dict):
        commit = data.get("commit_sha")
        branch = data.get("branch")
        results = data.get("results", [])
        timestamp = data.get("run_timestamp_utc")
        toolchain = data.get("toolchain")
        manifest = data.get("source_manifest")
    elif isinstance(data, list):
        commit = None
        branch = None
        results = data
        timestamp = None
        toolchain = None
        manifest = None
    else:
        return False, ["INVALID_EVIDENCE_FORMAT"]

    if expected_commit and commit != expected_commit:
        errors.append(f"COMMIT_SHA_MISMATCH: expected {expected_commit}, got {commit}")

    if expected_branch and branch != expected_branch:
        errors.append(f"BRANCH_MISMATCH: expected {expected_branch}, got {branch}")

    if not results:
        errors.append("EMPTY_RESULTS")

    # Validate individual simulation logs and SHA-256 integrity
    for item in results:
        status = item.get("result") or item.get("status")
        if status not in ["PASS", "FAIL"]:
            errors.append(f"INVALID_STATUS: {status}")

        log_path = item.get("evidence_log") or item.get("sim_log")
        if log_path:
            abs_log_path = os.path.abspath(log_path)
            if not os.path.exists(abs_log_path):
                errors.append(f"MISSING_LOG_FILE: {log_path}")
            else:
                log_sha = sha256_file(abs_log_path)
                if not log_sha:
                    errors.append(f"CORRUPTED_LOG_FILE: {log_path}")

    # Validate source manifest integrity if expected
    if expected_manifest_path and os.path.exists(expected_manifest_path):
        try:
            with open(expected_manifest_path, "r", encoding="utf-8") as f:
                ref_manifest = json.load(f)
            if manifest and manifest != ref_manifest:
                errors.append("SOURCE_MANIFEST_MISMATCH")
        except Exception:
            errors.append("MANIFEST_READ_ERROR")

    if errors:
        return False, errors
    return True, []

if __name__ == "__main__":
    if len(sys.argv) > 1:
        valid, errs = validate_evidence_package(sys.argv[1])
        print(f"Valid: {valid}, Errors: {errs}")
