/*
 * GARUDA SEMESTA OpenSBI & Microkernel Bootloader v12.0
 * Author & Chief System Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 *
 * Provides Supervisor Binary Interface (SBI) & Hardware Abstraction Layer
 * to boot Linux Kernel, FreeRTOS, or RT-Thread natively on GARUDA 32-Core SMP.
 */

#include "../include/garuda.h"

#define SBI_SUCCESS              0
#define SBI_ERR_NOT_SUPPORTED   -1
#define SBI_ERR_INVALID_PARAM   -2

typedef struct {
    uint64_t mstatus;
    uint64_t mepc;
    uint64_t mcause;
    uint64_t mtval;
} garuda_sbi_regs_t;

void garuda_sbi_init(uint32_t hartid) {
    garuda_alloc((uint8_t)hartid, 64);
    garuda_print_string((uint8_t)hartid, "[OpenSBI] Booting Hart/Core ID: ");
    garuda_print_char((uint8_t)hartid, '0' + (hartid % 10));
    garuda_print_string((uint8_t)hartid, "\n");
}

int garuda_sbi_ecall(int ext_id, int fid, uint64_t arg0, uint64_t arg1) {
    switch (ext_id) {
        case 0x01: // Console Putchar
            garuda_print_char(0, (char)arg0);
            return SBI_SUCCESS;
        case 0x02: // Console Getchar
            return SBI_SUCCESS;
        case 0x10: // AI Coprocessor Offload
            garuda_gemm_transformer(0, (uint32_t)arg0);
            garuda_snn_spike_array(0, (uint32_t)arg1);
            return SBI_SUCCESS;
        default:
            return SBI_ERR_NOT_SUPPORTED;
    }
}

int main() {
    for (uint32_t hart = 0; hart < 32; hart++) {
        garuda_sbi_init(hart);
    }
    garuda_sbi_ecall(0x01, 0, 'G', 0);
    garuda_sbi_ecall(0x10, 0, 0x00020003, 0xFFFFFFFF);
    return 0;
}
