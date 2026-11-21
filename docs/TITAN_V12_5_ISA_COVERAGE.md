# GARUDA TITAN V12.5 — ISA COVERAGE SPECIFICATION
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Milestone:** TITAN V12.5 COMPLETE CPU EXECUTION ENGINE  
**Date:** November 2026  
**Status:** **100% DECODED & VERIFIED**  

---

## 1. Instruction Set Coverage Table

| Opcode | Mnemonic | Format / Semantics | Decoder Support | Execution Engine | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `4'h0` | `NOP` | No Operation | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | IF/ID/EX/MEM/WB | **PASS** |
| `4'h1` | `ADD` | `rd = rs1 + rs2 / imm` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU 64-bit | **PASS** |
| `4'h2` | `SUB` | `rd = rs1 - rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU 64-bit | **PASS** |
| `4'h3` | `LOAD` | `rd = SRAM[rs1 + imm]` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | D-Cache / MMIO | **PASS** |
| `4'h4` | `STORE` | `SRAM[rs1 + imm] = rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | D-Cache / MMIO | **PASS** |
| `4'h5` | `BEQ` | `if (rs1 == rs2) PC = imm` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | EX Branch Flush | **PASS** |
| `4'h6` | `JMP` | `PC = imm` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | EX Jump Target | **PASS** |
| `4'h7` | `MUL` | `rd = rs1 * rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU 64-bit | **PASS** |
| `4'h8` | `AND` | `rd = rs1 & rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU Bitwise | **PASS** |
| `4'h9` | `OR` | `rd = rs1 \| rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU Bitwise | **PASS** |
| `4'hA` | `XOR` | `rd = rs1 ^ rs2` | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | ALU Bitwise | **PASS** |
| `4'hF` | `HALT` | Terminate Pipeline | [garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) | Retirement Latch | **PASS** |
