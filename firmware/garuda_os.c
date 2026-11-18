/*
 * GARUDA SEMESTA Distributed Microkernel OS (garuda-os) v12.0
 * Author & Chief Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 *
 * Microkernel OS running across 32-Core SMP Cluster (PIDs 0..31).
 * Handles Actor Process Scheduling, MPU Fault Auto-Recovery, Mailbox IPC,
 * and Hardware SNN Synaptic Spiking Array Dispatch.
 */

#include "../include/garuda.h"

#define MAX_CORES 32
#define DEFAULT_HEAP_SIZE 64

typedef struct {
    uint8_t  pid;
    uint8_t  state; // 0=IDLE, 1=RUNNING, 2=BLOCKED, 3=FAULTED
    uint32_t allocated_bytes;
} garuda_task_t;

static garuda_task_t task_table[MAX_CORES];

void garuda_os_init() {
    for (uint8_t i = 0; i < MAX_CORES; i++) {
        task_table[i].pid = i;
        task_table[i].state = 0; // IDLE
        task_table[i].allocated_bytes = 0;
        garuda_alloc(i, DEFAULT_HEAP_SIZE);
    }
    garuda_print_string(0, "[GARUDA-OS] Microkernel Initialized on 32 Cores.\n");
}

void garuda_os_spawn_actor(uint8_t pid, void (*actor_func)(void)) {
    if (pid >= MAX_CORES) return;
    task_table[pid].state = 1; // RUNNING
    garuda_print_char(pid, 'A');
    if (actor_func) {
        actor_func();
    }
}

void garuda_os_dispatch_ai_workload(uint8_t pid, uint32_t matrix, uint32_t snn_mask) {
    garuda_gemm_transformer(pid, matrix);
    garuda_snn_spike_array(pid, snn_mask);
}

void garuda_os_shutdown() {
    for (uint8_t i = 0; i < MAX_CORES; i++) {
        garuda_free(i, DEFAULT_HEAP_SIZE);
        garuda_halt(i);
    }
    garuda_print_string(0, "[GARUDA-OS] Microkernel Shutdown Complete.\n");
}

int main() {
    garuda_os_init();
    garuda_os_dispatch_ai_workload(0, 0x00020003, 0xFFFFFFFF);
    garuda_os_shutdown();
    return 0;
}
