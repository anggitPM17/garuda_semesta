# GARUDA SEMESTA GEN2 — FASE 6.7.3 PIPELINE STABILITY REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. PIPELINE STALL & RETIREMENT SPECIFICATION

During memory transaction wait states or external backpressure stalls (`dmem_resp_ready_in = 0`):

1. **PC Stage**:
   - `stall_core = imem_stall || dmem_stall || stall_hazard`.
   - PC register holds previous value: `if (!core_halted && !stall_core) pc <= next_pc;`.

2. **IF/ID Register (`rv64i_if_id_reg.v`)**:
   - `.stall(stall_core)` prevents capturing new instructions during memory stalls.

3. **ID/EX Register (`rv64i_id_ex_reg.v`)**:
   - `.stall(imem_stall || dmem_stall)` holds decoding state.
   - `.flush(flush_pipeline || stall_hazard || core_halted)` flushes ID/EX to NOP during load-use hazards, preventing pipeline deadlocks.

4. **EX/MEM Register (`rv64i_ex_mem_reg.v`)**:
   - `.stall(dmem_stall)` holds memory address, write data, funct3, and write enable stable throughout multi-cycle memory latency and backpressure stalls.

5. **MEM/WB Register (`rv64i_mem_wb_reg.v`)**:
   - `.stall(dmem_stall)` prevents premature load writeback before response completion.

---

## 2. EBREAK RETIREMENT IN WRITEBACK

- Sinyal `is_ebreak` dipropagasikan secara sekuensial melalui pipeline registers (`if_id` -> `id_ex` -> `ex_mem` -> `mem_wb`).
- `core_halted = 1` triggered ONLY when `mem_wb_is_ebreak = 1`, ensuring that all prior memory transactions and register writebacks retire completely before core halt.
