# GARUDA SEMESTA GENERATION 2 — SINGLE-HART INTEGRATION REPORT

**Repository**: `anggitPM17/garuda_semesta`  
**Branch**: `generation-2`  
**Commit SHA**: `93ec2a508f96aea609d4bf5ecbecabc49f613e12`  
**Principal Architect**: Anggit Prasetyo Mituhu  

---

## 1. Executive Summary
This report documents the successful end-to-end integration and execution of the **Garuda Semesta Generation 2 Single-Hart RV64I CPU Core** (`garuda_rv64i_core.v`). All 12 previously audited RTL components have been integrated into a fully functional 5-stage pipelined processor executing genuine RISC-V RV64I machine code through simulated instruction and data memory.

---

## 2. Architecture & Pipeline Stages
- **IF (Instruction Fetch)**: Combines program counter (`pc`), instruction memory interface, and combinational fetch logic with branch/jump redirection.
- **ID (Instruction Decode & Register Read)**: Decodes RV64I 32-bit instructions (`rv64i_decode`), reads 32x64-bit general purpose registers (`rv64i_regfile` with hardwired `x0` zero protection), and detects load-use hazards (`rv64i_hazard_unit`).
- **EX (Execute)**: Resolves operands via forwarding muxes (EX/MEM and MEM/WB bypass), executes arithmetic/logic via `rv64i_alu`, and evaluates control flow branches/jumps.
- **MEM (Memory Access)**: Executes load/store transactions via `rv64i_load_store_unit` with byte lane alignment and sign/zero extension.
- **WB (Writeback)**: Selects writeback data source and commits results to the register file.

---

## 3. Memory Interface & Handshake
- Separate Instruction Memory (`imem`) and Data Memory (`dmem`) models with ready-valid handshake readiness and zero/single-cycle response semantics.
- Request addresses and control signals remain stable during pipeline stalls.

---

## 4. Test Program & Verification Results (`single_hart_program.hex`)
The test program successfully verified:
1. `ADDI`, `ADD`, `SUB` arithmetic operations.
2. `AND`, `OR`, `XOR` logic operations.
3. `SLT`, `SLTU` comparisons.
4. Shift operations (`SLLI`).
5. `LUI`, `AUIPC` immediate/PC loads.
6. `SD` (Store Doubleword) & `LD` (Load Doubleword).
7. Branch taken and branch not taken.
8. `JAL` and `JALR` jumps.
9. EX/MEM & MEM/WB dependency forwarding.
10. Load-use hazard stalling.
11. Writeback results and `x0` register protection.

- **Total Instructions Executed**: 23 machine code instructions.
- **Final Simulation Status**: **SUCCESS (PASS)**.

---

## 5. Reproducible Execution Command
```bash
docker run --rm -v "$(pwd)/gen2:/workspace" garuda-goldenway:v1.0 sh /workspace/scripts/run_single_hart.sh
```
