# GARUDA SEMESTA GEN2 — FASE 6.7.2 HANDSHAKE ARCHITECTURE SPECIFICATION

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. TWO-PHASE TRANSACTION HANDSHAKE PROTOCOL

The data memory channel uses two independent valid-ready handshakes for Request Acceptance and Response Completion:

```
[CORE EX/MEM] --- dmem_valid ---> [MEMORY MODEL]
              <--- dmem_ready ---

[CORE MEM]    <--- dmem_resp_valid --- [MEMORY MODEL]
              --- dmem_resp_ready --->
```

### Phase 1: Request Acceptance (`request_fire`)
- **Event Condition:** `request_fire = dmem_valid && dmem_ready`
- **Behavior:**
  - Memory model latches request address (`pending_addr <= dmem_addr`), write enable (`pending_wen <= dmem_wen`), function code (`pending_funct3 <= dmem_funct3`), and write data (`pending_wdata <= dmem_wdata`).
  - `dmem_ready` drops to `0` immediately after acceptance during wait/response states.
  - Request counters (`read_tx_count` / `write_tx_count`) increment **EXACTLY ONCE**.

### Phase 2: Response Completion (`response_fire`)
- **Event Condition:** `response_fire = dmem_resp_valid && dmem_resp_ready`
- **Core Signal:** `dmem_resp_ready = (ex_mem_mem_read || ex_mem_mem_write) && dmem_resp_valid && tb_resp_ready_mask`
- **Behavior:**
  - Memory model enters `STATE_RESPONSE` and asserts `dmem_resp_valid = 1`.
  - Memory model holds `dmem_resp_valid = 1` and `dmem_rdata` STABLE as long as `dmem_resp_ready` is LOW (`0`).
  - Core holds pipeline stall `dmem_stall = (ex_mem_mem_read || ex_mem_mem_write) && !(dmem_resp_valid && dmem_resp_ready)` as long as `dmem_resp_ready` is LOW (`0`).
  - Store commits to memory array **EXACTLY ONCE** when `response_fire` occurs (`dmem_resp_valid && dmem_resp_ready`).
  - `committed_store_count` and `resp_tx_count` increment **EXACTLY ONCE**.
  - FSM returns to `STATE_IDLE` on `posedge clk` following `response_fire`.

---

## 2. PIPELINE STABILITY & HOLD ASSURANCES

During response backpressure stalls (`dmem_resp_ready = 0`):
- **PC:** Stays 100% frozen (`!stall_core`).
- **IF/ID Register:** Holds instruction and PC (`.stall(stall_core)`).
- **ID/EX Register:** Holds operands and control (`.stall(imem_stall || dmem_stall)`).
- **EX/MEM Register:** Holds memory address, store data, and control (`.stall(dmem_stall)`).
- **MEM/WB Register:** Holds writeback data (`.stall(dmem_stall)`).
