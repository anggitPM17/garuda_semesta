# GARUDA SEMESTA V12.2 — EDA SYNTHESIS READINESS REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** **AUDITED & SYNTHESIS-READY**  

---

## 1. Synthesis Readiness Audit

The **GARUDA SEMESTA V12.2** Verilog codebase has been audited for synthesis readiness:
- **Standard Verilog-2012 Constructs:** Uses standard `always @(posedge clk or negedge rst_n)`, `always @(*)`, and synchronous resets.
- **No Latch Inferences:** All combinational logic blocks default-assign outputs at the top of the block.
- **Single Synchronous Clock Domain:** Driven by 100 MHz `clk` with active-low `rst_n`.

---

## 2. Tool Availability Matrix

| Tool | Status in Container | Action Taken |
| :--- | :--- | :--- |
| **Icarus Verilog (`iverilog`)** | Available (`v11.0`) | Primary RTL compiler |
| **VVP Runtime (`vvp`)** | Available (`v11.0`) | Primary simulation engine |
| **Verilator (`verilator`)** | Not installed in container image | **SKIPPED** (Target for V12.3) |
| **Yosys Synthesis (`yosys`)** | Not installed in container image | **SKIPPED** (Target for V12.3) |
