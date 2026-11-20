#!/usr/bin/env python3
"""
GARUDA SEMESTA — UNIT TEST: MEMORY ARCHITECTURE SUBSYSTEM (FASE 2)
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

from src.memory.verify_garuda_memory import GarudaL1DCacheModel, GarudaL2CacheModel

class TestGarudaMemorySubsystem(unittest.TestCase):
    def setUp(self):
        self.dcache = GarudaL1DCacheModel()
        self.l2cache = GarudaL2CacheModel()

    def test_l1_dcache_read_write(self):
        addr = 0x80000100
        val = 0xDEADBEEF
        hit_w, w_res = self.dcache.write_data(addr, val)
        hit_r, r_res = self.dcache.read_data(addr)
        self.assertTrue(hit_r)
        self.assertEqual(r_res, 0xDEADBEEF)

    def test_l1_dcache_byte_enable(self):
        addr = 0x80000100
        self.dcache.write_data(addr, 0x0000CAFE, byte_enable=0x3)
        _, r_res = self.dcache.read_data(addr)
        self.assertEqual(r_res & 0xFFFF, 0xCAFE)

    def test_l2_cache_4way_hit(self):
        addr = 0x80000200
        miss = self.l2cache.access(addr, 0x12345678, is_write=True)
        hit = self.l2cache.access(addr, is_write=False)
        self.assertFalse(miss)
        self.assertTrue(hit)

if __name__ == "__main__":
    unittest.main()
