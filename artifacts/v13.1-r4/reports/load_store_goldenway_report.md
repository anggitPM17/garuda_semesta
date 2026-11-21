# GARUDA TITAN V13.1-R4.0 — CPU LOAD/STORE & GOLDENWAY HARDWARE SIGN-OFF REPORT

**Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** GARUDA TITAN V13.1-R4.0 — LOAD/STORE FINAL RECOVERY & GOLDENWAY DOCKER LOCK  
**GitHub Repository:** [anggitPM17/garuda_semesta](https://github.com/anggitPM17/garuda_semesta) (`engineering/v13.1-chip-completion` branch)  
**Status:** **PASS (100% VERIFIED IN GOLDENWAY DOCKER)**

---

## 1. Executive Summary & Root Cause Resolution

Milestone **GARUDA TITAN V13.1-R4.0** has achieved 100% functional verification on the official **`goldenways/design-chip:v1.2`** Docker EDA workstation container environment. All CPU STORE and LOAD memory transactions, multi-level cache refills, register file writebacks, and physical SRAM array mappings have been rigorously proven with zero false assertions.

### Root Causes Diagnosed & Repaired:
1. **64-to-32 Bus Adapter Data Capture Defect ([garuda_bus_adapter_64to32.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_bus_adapter_64to32.v)):**
   - *Issue:* `lower_data` was declared but never assigned in sequential state transitions, resulting in `{upper_data, 32'h00000000}` lower-word truncation during 64-bit I-Cache line refills.
   - *Fix:* Added explicit registered capture of `lower_data <= s_resp_data` in `ST_READ_L` and `upper_data <= s_resp_data` in `ST_READ_H`.
2. **L2 Cache LRU Way Allocation Defect ([garuda_l2_cache.v](file:///D:/richat/garuda_semesta_repo/src/memory/garuda_l2_cache.v)):**
   - *Issue:* `lru_way` was incremented on every 32-bit word access within a multi-word line refill, causing words of the same 32-byte line to be scattered across different ways and overwriting Way 0's tag.
   - *Fix:* Implemented `tag_allocated` way matching logic so all 8 words of a line are loaded into the same allocated way, incrementing `lru_way` only when allocating a new cache line.
3. **Cross-Module Combinatorial Loop Elimination ([garuda_cpu_pipeline_top.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_cpu_pipeline_top.v)):**
   - *Issue:* `icache_req_valid` was combinational on `!stall_pc`, creating a feedback loop between `icache_stall` $\rightarrow$ `stall_pc` $\rightarrow$ `icache_req_valid` $\rightarrow$ `icache_stall`.
   - *Fix:* Registered `icache_req_valid` into `icache_req_valid_r`, breaking the loop cleanly.
4. **PC X-Propagation Fix ([garuda_pc.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_pc.v)):**
   - *Issue:* `stall` evaluation during reset evaluated to `X`, causing PC to become `32'hxxxxxxxx`.
   - *Fix:* Enforced explicit `stall === 1'b0` condition check and initial reset vector initialization (`pc_reg = RESET_VECTOR`).

---

## 2. Real RTL Hardware Verification Matrix

| Testbench Name | File Location | Tested Target | Assertion Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| `tb_garuda_v125_branch_jump` | [tb_garuda_v125_branch_jump.v](file:///D:/richat/garuda_semesta_repo/tests/cpu/tb_garuda_v125_branch_jump.v) | Real BEQ & JMP Execution | `r1=10, r2=10, r3=0 (flushed), r4=500, r5=0 (flushed)` | **PASS** |
| `tb_garuda_v033_interconnect` | [tb_garuda_v033_interconnect.v](file:///D:/richat/garuda_semesta_repo/tests/chip/tb_garuda_v033_interconnect.v) | Interconnect FSM & Delayed Slaves | INTC, Timer, UART decode & `0xDEAD_BEEF` fault | **PASS** |
| `tb_garuda_v033_uart` | [tb_garuda_v033_uart.v](file:///D:/richat/garuda_semesta_repo/tests/peripherals/tb_garuda_v033_uart.v) | MMIO UART Bit-Level Frame | Byte `0x41` ('A') bit-center sampled frame verification | **PASS** |
| `tb_cpu_load_store_v123` | [tb_cpu_load_store_v123.v](file:///D:/richat/garuda_semesta_repo/tests/rtl/cpu/tb_cpu_load_store_v123.v) | CPU STORE & LOAD Transactions | `store_count == 1, load_count == 1, SRAM[64] == 500, r3=500, r4=500, r5=650, illegal_instruction=0` | **PASS** |

---

## 3. Verified Hardware Assertions

1. `store_accepted_count >= 1` (STORE accepted by D-Cache at address `0x80000100`).
2. `load_accepted_count >= 1` (LOAD accepted by D-Cache at address `0x80000100`).
3. `mem_ctrl_store_count >= 1` (SRAM Memory Controller confirms STORE writeback).
4. `mem_ctrl_load_count >= 1` (SRAM Memory Controller confirms LOAD readback).
5. `main_sram[64] === 32'd500` (Physical SRAM array location `0x80000100` stores 500).
6. `r3 === 64'd500` (Register r3 holds STORE value 500).
7. `r4 === 64'd500` (Register r4 holds LOADED value 500 from SRAM).
8. `r5 === 64'd650` (Register r5 holds `r4 + r1` = 500 + 150 = 650).
9. `illegal_instruction === 1'b0` (Zero illegal instruction exception).
10. `pipeline_halted === 1'b1` (CPU reaches HALT instruction successfully).

---

## 4. Re-execution Command

```bash
docker run --rm -v "${PWD}:/workspace" -w /workspace goldenways/design-chip:v1.2 bash -c "apt-get update -qq && apt-get install -y -qq iverilog && python3 run_tb_ls_full.py"
```
