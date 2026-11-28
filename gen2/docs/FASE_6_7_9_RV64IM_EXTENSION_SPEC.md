# GARUDA SEMESTA GEN2 — FASE 6.7.9 RV64IM EXTENSION SPECIFICATION

**Document Version:** 1.0.0  
**Date:** November 26, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Status:** **SPECIFICATION & DESIGN — RV64IM UPGRADE**  

---

## 1. OBJECTIVE

Upgrade the **Garuda Semesta Gen2 4-Core RV64I Multiprocessor** to support the **RISC-V 'M' Standard Extension for Integer Multiplication and Division**, transforming the architecture into an **RV64IM Quad-Core Processor**.

---

## 2. RV64IM INSTRUCTION SET MAPPING

| Instruction | Opcode | Funct3 | Funct7 | ALU Operation (`alu_op`) | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`MUL`** | `0110011` | `000` | `0000001` | `4'hB` | Multiply (Lower 64 bits of 128-bit product) |
| **`MULH`** | `0110011` | `001` | `0000001` | `4'hC` | Multiply High (Signed x Signed) |
| **`MULHU`** | `0110011` | `011` | `0000001` | `4'hD` | Multiply High Unsigned (Unsigned x Unsigned) |
| **`DIV`** | `0110011` | `100` | `0000001` | `4'hE` | Divide Signed |
| **`DIVU`** | `0110011` | `101` | `0000001` | `4'hF` | Divide Unsigned |
| **`REM`** | `0110011` | `110` | `0000001` | `4'h10` | Remainder Signed |
| **`REMU`** | `0110011` | `111` | `0000001` | `4'h11` | Remainder Unsigned |

---

## 3. RTL MODIFICATION PLAN

1. **`gen2/rtl/core/rv64i_decode.v`**:
   - Detect `funct7 == 7'b0000001` (M-Extension indicator).
   - Decode `funct3` for `MUL`, `MULH`, `MULHU`, `DIV`, `DIVU`, `REM`, `REMU` and set corresponding `alu_op` values.
2. **`gen2/rtl/core/rv64i_alu.v`**:
   - Extend `alu_op` width to 5 bits (`[4:0]`).
   - Implement hardware multiplication (`*`, `{128{...}}` for high product bits) and division/remainder (`/`, `%`).
3. **Verification**:
   - Create multi-hart RV64IM arithmetic testbench verifying multiplication and division accuracy across Hart 0..3.
