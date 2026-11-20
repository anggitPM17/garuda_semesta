#!/usr/bin/env python3
"""
GARUDA SEMESTA — MASTER VERIFICATION TEST RUNNER
Author & Chief System Architect: Anggit Prasetyo Mituhu
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0
"""

import sys
import os
import unittest

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

def run_master_test_suite():
    print("=========================================================================")
    print("GARUDA SEMESTA — MASTER UNIT & INTEGRATION TEST RUNNER v12.0")
    print("Architect & Author: Anggit Prasetyo Mituhu")
    print("=========================================================================\n")

    loader = unittest.TestLoader()
    suite = loader.discover(start_dir=os.path.dirname(__file__), pattern="test_*.py")
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    print("\n=========================================================================")
    print(f" TEST RUNNER SUMMARY: {result.testsRun} Tests Executed.")
    print(f" SUCCESSES: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f" FAILURES: {len(result.failures)}")
    print(f" ERRORS: {len(result.errors)}")
    print("=========================================================================\n")

    return result.wasSuccessful()

if __name__ == "__main__":
    success = run_master_test_suite()
    sys.exit(0 if success else 1)
