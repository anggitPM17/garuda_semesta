#!/usr/bin/env python3
"""
GARUDA SEMESTA — UNIT TEST: 3D MESH NoC INTERCONNECT (FASE 5)
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

from src.noc.verify_garuda_noc import GarudaNocPacket, GarudaNocRouterModel

class TestGarudaNocInterconnect(unittest.TestCase):
    def setUp(self):
        self.router = GarudaNocRouterModel(node_x=0, node_y=0)

    def test_packet_encoding(self):
        pkt = GarudaNocPacket(0x0002, src_x=0, src_y=0, dest_x=1, dest_y=0, payload=0xCAFEF00D)
        encoded = pkt.encode()
        self.assertEqual(encoded[0], 0x0002)
        self.assertEqual(encoded[3], 0xCAFEF00D)

    def test_xy_routing_direction(self):
        pkt = GarudaNocPacket(0x0002, src_x=0, src_y=0, dest_x=1, dest_y=0)
        direction = self.router.route_packet(pkt)
        self.assertEqual(direction, "EAST")

if __name__ == "__main__":
    unittest.main()
