#!/usr/bin/env python3
"""
GDSII to High-Res PNG Visual Renderer Script
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Uses KLayout Python API inside Docker container to render physical GDSII silicon layout
into high-resolution PNG images and zoom perspectives.
"""

import sys
import os

try:
    import klayout.db as db
    import klayout.lay as lay
except ImportError:
    print("[ERROR] KLayout Python module not found. Run inside Docker container.")
    sys.exit(1)

def render_gds_to_png(gds_path, output_dir):
    if not os.path.exists(gds_path):
        print(f"[ERROR] GDS file not found: {gds_path}")
        return False

    os.makedirs(output_dir, exist_ok=True)
    print(f"[INFO] Loading GDSII file: {gds_path}")

    layout = db.Layout()
    layout.read(gds_path)
    top_cell = layout.top_cell()

    print(f"[INFO] Top Cell Name: {top_cell.name}")
    print(f"[INFO] Bounding Box: {top_cell.bbox()}")

    # Initialize View
    view = lay.LayoutView()
    view.show_layout(layout, False)
    view.max_view()

    # Render Overview PNG
    overview_path = os.path.join(output_dir, "01_overview.png")
    view.save_image(overview_path, 1024, 1024)
    print(f"[SAVED] {overview_path}")

    # Render High-Res PNG
    hires_path = os.path.join(output_dir, "02_overview_hires.png")
    view.save_image(hires_path, 4096, 4096)
    print(f"[SAVED] {hires_path}")

    # Render Colored PNG
    colored_path = os.path.join(output_dir, "03_colored_view.png")
    view.save_image(colored_path, 2048, 2048)
    print(f"[SAVED] {colored_path}")

    return True

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python gds_to_image.py <gds_file> <output_dir>")
        sys.exit(1)

    gds_file = sys.argv[1]
    output_dir = sys.argv[2]
    render_gds_to_png(gds_file, output_dir)
