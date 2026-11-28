# GARUDA SEMESTA GEN2 — FASE 6.7.4.3 HANDSHAKE ARCHITECTURE SPECIFICATION

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. UNIFIED TWO-PHASE VALID-READY HANDSHAKE PROTOCOL

```
[CORE EX/MEM] -------- dmem_valid --------> [MEMORY MODEL]
              <------- dmem_ready --------

[CORE MEM]    <----- dmem_resp_valid ------ [MEMORY MODEL]
              ------ dmem_resp_ready -----> (via dmem_resp_ready_in)
```

### Phase 1: Request Acceptance (`request_fire`)
- **Event Condition:** `request_fire = dmem_valid && dmem_ready`
- **Behavior:**
  - Memory model latches request address (`pending_addr`), write enable (`pending_wen`), function code (`pending_funct3`), and write data (`pending_wdata`).
  - `dmem_ready` drops to `0` immediately after acceptance during wait/response states.
  - Request counters (`read_tx_count` / `write_tx_count`) increment **EXACTLY ONCE**.

### Phase 2: Response Completion (`response_fire`)
- **Event Condition:** `response_fire = dmem_resp_valid && dmem_resp_ready`
- **Unified Core Signal:** `assign dmem_resp_ready = (ex_mem_mem_read || ex_mem_mem_write) && dmem_resp_ready_in;`
- **Unified Core Pipeline Stall:** `assign dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !response_fire;`
- **Behavior:**
  - Memory model enters `STATE_RESPONSE` and asserts `dmem_resp_valid = 1`.
  - Memory model holds `dmem_resp_valid = 1` and `dmem_rdata` STABLE as long as `dmem_resp_ready` is LOW (`0`).
  - Core holds pipeline stall `dmem_stall = 1` as long as `dmem_resp_ready` is LOW (`0`).
  - Store commits to memory array **EXACTLY ONCE** when `response_fire` occurs (`dmem_resp_valid && dmem_resp_ready`).
  - `committed_store_count` and `resp_tx_count` increment **EXACTLY ONCE**.
  - FSM returns to `STATE_IDLE` on `posedge clk` following `response_fire`.
