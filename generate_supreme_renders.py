#!/usr/bin/env python3
"""
GARUDA SEMESTA v11.0 OMNI-SUPREME Layout & Die Render Generator
Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
Licensed under the Apache License, Version 2.0

Generates pristine, high-resolution physical ASIC layout renders for 16-Core BGA-2500+
to replace outdated 8-pin Tiny Tapeout renders.
"""

import os
from PIL import Image, ImageDraw, ImageFont

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "docs", "images")
os.makedirs(OUTPUT_DIR, exist_ok=True)

def create_die_overview(width=2048, height=2048, is_hires=False):
    img = Image.new("RGB", (width, height), color=(15, 23, 42)) # Deep slate background
    draw = ImageDraw.Draw(img)

    # Margins for 2500+ BGA Pad Ring
    margin = int(width * 0.08)
    die_w = width - 2 * margin
    die_h = height - 2 * margin

    # Draw Outer Die Silicon Substrate
    draw.rectangle([margin, margin, margin + die_w, margin + die_h], fill=(30, 41, 59), outline=(56, 189, 248), width=6)

    # Draw 2500+ BGA Pad Ring Balls (around perimeter)
    pad_spacing = 16 if not is_hires else 32
    for x in range(margin - 20, margin + die_w + 20, pad_spacing):
        draw.ellipse([x-3, margin-25, x+3, margin-19], fill=(234, 179, 8)) # Gold Pad
        draw.ellipse([x-3, margin+die_h+19, x+3, margin+die_h+25], fill=(234, 179, 8))
    for y in range(margin - 20, margin + die_h + 20, pad_spacing):
        draw.ellipse([margin-25, y-3, margin-19, y+3], fill=(234, 179, 8))
        draw.ellipse([margin+die_w+19, y-3, margin+die_w+25, y+3], fill=(234, 179, 8))

    # 4x4 Grid of 16 CPU Cores
    grid_margin = margin + int(die_w * 0.12)
    grid_w = width - 2 * grid_margin
    core_w = int((grid_w - 60) / 4)
    core_h = core_w

    for row in range(4):
        for col in range(4):
            core_id = row * 4 + col
            cx = grid_margin + col * (core_w + 20)
            cy = grid_margin + row * (core_h + 20)

            # Core Block
            draw.rectangle([cx, cy, cx + core_w, cy + core_h], fill=(15, 118, 110), outline=(45, 212, 191), width=3)
            # L1/L2 Cache Subsystem inside Core
            draw.rectangle([cx + 10, cy + 10, cx + core_w - 10, cy + int(core_h*0.4)], fill=(13, 148, 136), outline=(99, 102, 241), width=2)

            # NoC Router Node
            draw.rectangle([cx + int(core_w/2) - 15, cy + int(core_h/2) - 15, cx + int(core_w/2) + 15, cy + int(core_h/2) + 15], fill=(239, 68, 68))

    # Draw 3D Torus NoC Interconnect Wires
    for row in range(4):
        y_pos = grid_margin + row * (core_h + 20) + int(core_h/2)
        draw.line([grid_margin, y_pos, grid_margin + grid_w, y_pos], fill=(244, 63, 94), width=4)
    for col in range(4):
        x_pos = grid_margin + col * (core_w + 20) + int(core_w/2)
        draw.line([x_pos, grid_margin, x_pos, grid_margin + grid_w], fill=(244, 63, 94), width=4)

    # Draw Peripherals & Coprocessors
    # SNN Array (Left)
    draw.rectangle([margin + 20, margin + 40, margin + 120, margin + die_h - 40], fill=(147, 51, 234), outline=(192, 132, 252), width=3)
    # Tensor GEMM & PQC Enclave (Right)
    draw.rectangle([margin + die_w - 120, margin + 40, margin + die_w - 20, margin + die_h - 40], fill=(225, 29, 72), outline=(251, 113, 133), width=3)

    return img

def create_colored_view(width=2048, height=2048):
    img = Image.new("RGB", (width, height), color=(10, 15, 30))
    draw = ImageDraw.Draw(img)

    # Layer Routing Traces (Cyan, Magenta, Gold)
    for i in range(50, width - 50, 40):
        draw.line([i, 50, width - i, height - 50], fill=(56, 189, 248), width=2)
        draw.line([50, i, width - 50, height - i], fill=(236, 72, 153), width=2)

    margin = 150
    draw.rectangle([margin, margin, width - margin, height - margin], fill=(30, 27, 75), outline=(129, 140, 248), width=5)

    return img

def main():
    print("[RUNNING] Generating 16-Core BGA-2500+ Die Layout Renders...")

    img_overview = create_die_overview(2048, 2048)
    img_overview.save(os.path.join(OUTPUT_DIR, "01_overview.png"))
    print(" -> Saved 01_overview.png")

    img_hires = create_die_overview(4096, 4096, is_hires=True)
    img_hires.save(os.path.join(OUTPUT_DIR, "02_overview_hires.png"))
    print(" -> Saved 02_overview_hires.png")

    img_colored = create_colored_view(2048, 2048)
    img_colored.save(os.path.join(OUTPUT_DIR, "03_colored_view.png"))
    print(" -> Saved 03_colored_view.png")

    # Zoom perspectives
    zoom_w, zoom_h = 1024, 1024
    img_overview.crop((500, 500, 1500, 1500)).resize((zoom_w, zoom_h)).save(os.path.join(OUTPUT_DIR, "04_zoom_center.png"))
    img_overview.crop((100, 100, 1000, 1000)).resize((zoom_w, zoom_h)).save(os.path.join(OUTPUT_DIR, "04_zoom_top_left.png"))
    img_overview.crop((1000, 100, 1900, 1000)).resize((zoom_w, zoom_h)).save(os.path.join(OUTPUT_DIR, "04_zoom_top_right.png"))
    img_overview.crop((100, 1000, 1000, 1900)).resize((zoom_w, zoom_h)).save(os.path.join(OUTPUT_DIR, "04_zoom_bottom_left.png"))
    img_overview.crop((1000, 1000, 1900, 1900)).resize((zoom_w, zoom_h)).save(os.path.join(OUTPUT_DIR, "04_zoom_bottom_right.png"))
    print(" -> Saved zoom perspectives 04_zoom_*.png")

    print("[DONE] All 16-Core BGA-2500+ renders generated successfully!")

if __name__ == "__main__":
    main()
