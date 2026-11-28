# GARUDA SEMESTA GEN2 — FASE 6.7.4 LATENCY-0 DEADLOCK REPAIR REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. LATENCY-0 TRANSACTION SEMANTICS

In `rv64i_memory_model.v`, `LATENCY = 0` represents zero-wait-state combinational memory access. However, externally observable protocol semantics MUST remain identical to multi-cycle memory (`LATENCY = 1, 3, 5`):

1. **Request Acceptance & Response Validity**:
   - `dmem_ready = (LATENCY == 0) ? !tx_committed : (dmem_state == STATE_IDLE)`
   - `dmem_resp_valid = (LATENCY == 0) ? (dmem_valid && !tx_committed) : (dmem_state == STATE_RESPONSE)`
2. **Exactly-Once Commit Register (`tx_committed`)**:
   - When `dmem_valid && dmem_ready && dmem_resp_ready && !tx_committed` occurs on `LATENCY = 0`:
     - `tx_committed <= 1'b1`
     - Store commits to memory array **EXACTLY ONCE** (`committed_store_count <= committed_store_count + 1'b1`)
     - Write transaction count increments **EXACTLY ONCE** (`write_tx_count <= write_tx_count + 1'b1`)
     - Response count increments **EXACTLY ONCE** (`resp_tx_count <= resp_tx_count + 1'b1`)
3. **Reset Condition for `tx_committed`**:
   - `tx_committed` resets to `0` ONLY when `dmem_valid` drops to `0` or when `dmem_addr` / `dmem_wen` changes (indicating EX/MEM pipeline register has advanced to a new instruction).
   - This prevents re-commit if backpressure stalls the pipeline on the same instruction for multiple clock edges.
