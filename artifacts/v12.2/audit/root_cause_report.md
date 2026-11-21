# GARUDA SEMESTA V12.2 — FORENSIC ROOT CAUSE ANALYSIS REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** V12.2 REAL RTL EXECUTION RECOVERY  
**Date:** November 2026  
**Status:** **RESOLVED**  

---

## 1. Executive Summary

This document details the forensic root-cause analysis and hardware remediation executed during milestone **GARUDA SEMESTA V12.2**.

---

## 2. Identified Hardware Anomalies & Root Causes

### Anomaly 1: Simulation Timeout & I-Cache Prefetch Stall Loop
- **Root Cause:** In `garuda_l1_icache.v`, `stall` was assigned via non-blocking signal updates (`stall <= 1'b1;`), introducing a 1-clock-cycle delay during cache misses. This allowed `garuda_pc` to advance past `0x80000000` to `0x80000008` during Line 0 refill, corrupting the target refill base address and stalling the pipeline indefinitely.
- **Remediation:** Implemented zero-lag combinational stall logic (`assign stall = (state == ST_IDLE && req_valid && !tag_match) || (state == ST_COMPARE && !tag_match) || (state == ST_REFILL);`), ensuring the PC freezes instantly at the exact missing instruction address.

### Anomaly 2: Bus Adapter Handshake Freeze
- **Root Cause:** In `garuda_bus_adapter_64to32.v`, the state machine trapped in `ST_REQ_L` waiting for `!s_resp_valid` while L2 Cache was returning `s_resp_valid = 1`.
- **Remediation:** Re-architected `garuda_bus_adapter_64to32.v` into a clean 4-state FSM (`ST_IDLE` $\rightarrow$ `ST_READ_L` $\rightarrow$ `ST_READ_H` $\rightarrow$ `ST_DONE`) that executes twin 32-bit burst reads for lower (`addr + 0`) and upper (`addr + 4`) words sequentially.

### Anomaly 3: L1 D-Cache Output Address Alignment
- **Root Cause:** Output registers `mem_addr` and `mem_write_data` were updated on `posedge clk` while the L1-to-L2 Arbiter evaluated `dcache_mem_valid` on that same clock edge, latching address `0x0` instead of `0x80000100`.
- **Remediation:** Added hybrid combinational/latched memory assignments (`assign mem_addr = (state == ST_IDLE || state == ST_COMPARE) ? req_addr : latched_mem_addr;`), driving the arbiter immediately during `ST_COMPARE`.

### Anomaly 4: D-Cache Store Re-trigger Loop
- **Root Cause:** When `dcache_valid` un-stalled the CPU, `ex_mem_mem_write` remained high for 1 cycle as the pipeline un-stalled, causing D-Cache to immediately re-trigger a second store transaction for the same instruction.
- **Remediation:** Integrated `dcache_done` latching in `garuda_cpu_pipeline_top.v` (`assign dcache_req_valid = (ex_mem_mem_read || ex_mem_mem_write) && !dcache_done;`), suppressing re-triggering until the instruction leaves the MEM stage.

---

## 3. Verification Verdict
All four hardware timing and handshake defects have been fully resolved. Real RTL simulation execution completes with 100% data integrity and zero timeouts.
