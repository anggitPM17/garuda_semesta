/*
 * GARUDA GPU Vulkan & OpenGL Style 3D Graphics C-SDK v1.0
 * Author & Chief System Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 */

#ifndef GARUDA_GPU_H
#define GARUDA_GPU_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// GPU Control & Pipeline Management
void garudaGpuInit(uint32_t width, uint32_t height);
void garudaGpuSetViewport(uint32_t x, uint32_t y, uint32_t w, uint32_t h);

// 3D Ray-Tracing Pipeline API
void garudaGpuTraceRays(uint8_t sm_id, float ray_ox, float ray_oy, float ray_oz, float ray_dx, float ray_dy, float ray_dz);
void garudaGpuBindBvhTree(uint8_t sm_id, uint64_t bvh_root_addr);

// 3D Rasterization & Shading API
void garudaGpuDrawTriangles(uint32_t vertex_count, uint64_t vertex_buffer_addr);
void garudaGpuBindTexture(uint8_t slot, uint64_t tex_addr);

// Framebuffer & Display
void garudaGpuPresentFrame(void);

#ifdef __cplusplus
}
#endif

#endif // GARUDA_GPU_H
