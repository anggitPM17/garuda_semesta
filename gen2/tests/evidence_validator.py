#!/usr/bin/env python3
import os
import json

def validate_evidence_package(json_path, expected_commit=None, expected_branch=None):
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
    elif isinstance(data, list):
        commit = None
        branch = None
        results = data
    else:
        return False, ["INVALID_EVIDENCE_FORMAT"]

    if expected_commit and commit != expected_commit:
        errors.append(f"COMMIT_SHA_MISMATCH: expected {expected_commit}, got {commit}")

    if expected_branch and branch != expected_branch:
        errors.append(f"BRANCH_MISMATCH: expected {expected_branch}, got {branch}")

    if not results:
        errors.append("EMPTY_RESULTS")

    for item in results:
        status = item.get("result") or item.get("status")
        if status not in ["PASS", "FAIL"]:
            errors.append(f"INVALID_STATUS: {status}")

    if errors:
        return False, errors
    return True, []

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        valid, errs = validate_evidence_package(sys.argv[1])
        print(f"Valid: {valid}, Errors: {errs}")
