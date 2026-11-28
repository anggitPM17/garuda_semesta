# GARUDA SEMESTA GEN2 — FASE 6.7.1 PROTOCOL VERIFICATION & BACKPRESSURE REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Docker Container:** `garuda-goldenway:v1.0`  

---

## 1. TWO-PHASE VALID-READY HANDSHAKE ARCHITECTURE

1. **Request Acceptance Phase (`request_accept`)**:
   - `request_accept = dmem_valid && dmem_ready`.
   - Latches `pending_addr`, `pending_wen`, `pending_funct3`, `pending_wdata`.
   - `dmem_ready` drops to `0` immediately during multi-cycle wait/response states.
   - `read_tx_count` / `write_tx_count` increment **EXACTLY ONCE**.

2. **Response Completion Phase (`response_complete`)**:
   - `response_complete = dmem_resp_valid && dmem_resp_ready`.
   - `dmem_resp_ready = dmem_resp_valid` (asserted by core).
   - `dmem_resp_valid` remains HIGH and `dmem_rdata` remains STABLE as long as `dmem_resp_ready` is LOW.
   - Store commits to memory array **EXACTLY ONCE** (`committed_store_count`).
   - `resp_tx_count` increments **EXACTLY ONCE**.
   - FSM returns to `STATE_IDLE` on the clock edge following response completion.

---

## 2. BACKPRESSURE INJECTION TEST VERIFICATION

During simulation across all latencies (0, 1, 3, 5), a backpressure stall was injected via testbench control `tb_resp_ready_mask = 1'b0`:

```text
PASS: Response valid held stable during backpressure stall.
```

- **Observed Behavior:**
  - When `tb_resp_ready_mask` dropped to 0, `dmem_resp_valid` remained HIGH and `dmem_rdata` remained STABLE.
  - Store commit count (`committed_store_count`) did NOT double-count during the backpressure stall.
  - Transaction response counter (`resp_tx_count`) did NOT double-count.
  - When `tb_resp_ready_mask` returned to 1, transaction completion occurred **EXACTLY ONCE** and the core pipeline resumed cleanly.
