/*
 * GARUDA SEMESTA SoC v12.0 TITAN-TITANIUM — C/C++ Header SDK
 * Author & Chief System Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 */

#ifndef GARUDA_H
#define GARUDA_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Core System & Heap Allocation
void garuda_alloc(uint8_t pid, uint16_t size);
void garuda_free(uint8_t pid, uint16_t size);
void garuda_halt(uint8_t pid);

// Hardware Coprocessor Accelerators
void garuda_snn_spike_array(uint8_t pid, uint32_t synapse_mask);
void garuda_gemm_transformer(uint8_t pid, uint32_t matrix_data);
void garuda_pqc_encrypt(uint8_t pid, uint32_t input_data);
void garuda_aes_encrypt(uint8_t pid, uint32_t key_data);
void garuda_vector_simd(uint8_t pid, uint32_t operand);

// Peripherals & IPC
void garuda_print_char(uint8_t pid, char ch);
void garuda_print_string(uint8_t pid, const char* str);
void garuda_send_mailbox(uint8_t src_pid, uint8_t target_pid, uint32_t payload);

#ifdef __cplusplus
}
#endif

#endif // GARUDA_H
