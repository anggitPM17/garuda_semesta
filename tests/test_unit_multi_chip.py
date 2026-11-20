#!/usr/bin/env python3
"""
GARUDA SEMESTA — UNIT TEST: MULTI-CHIP HARDWARE (GPU, NPU, SECURE, MCU)
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

from src.gpu.verify_garuda_gpu_hardware import GarudaGpuSimdCoreModel, GarudaGpuRaytracerModel
from src.npu.verify_garuda_npu_hardware import GarudaNpuSystolicArrayModel
from src.secure.verify_garuda_secure_hardware import GarudaSecureCryptoEngineModel
from src.mcu.verify_garuda_mcu_hardware import GarudaMcuPeripheralModel

class TestGarudaMultiChipHardware(unittest.TestCase):
    def test_gpu_wmma_gemm(self):
        gpu = GarudaGpuSimdCoreModel()
        success, tflops = gpu.execute_wmma_gemm()
        self.assertTrue(success)
        self.assertEqual(tflops, 98.4)

    def test_gpu_raytracer_bvh(self):
        raytracer = GarudaGpuRaytracerModel()
        hit, dist_t = raytracer.intersect_ray_triangle((0,0,0), (0,0,1), (-10,-10,250), (10,-10,250), (0,10,250))
        self.assertTrue(hit)
        self.assertEqual(dist_t, 250.0)

    def test_npu_systolic_array(self):
        npu = GarudaNpuSystolicArrayModel()
        mat_a = [[1 for _ in range(16)] for _ in range(16)]
        mat_b = [[2 for _ in range(16)] for _ in range(16)]
        res = npu.multiply_accumulate(mat_a, mat_b)
        self.assertEqual(res[0][0], 32)

    def test_secure_pqc_ntt(self):
        secure = GarudaSecureCryptoEngineModel()
        coeff_out = secure.ntt_polynomial_mul(100, 17)
        self.assertEqual(coeff_out, 1700)

    def test_mcu_sub_nanowatt_sleep(self):
        mcu = GarudaMcuPeripheralModel()
        in_sleep, current_na = mcu.enter_sub_nanowatt_sleep()
        self.assertTrue(in_sleep)
        self.assertLess(current_na, 0.1)

if __name__ == "__main__":
    unittest.main()
