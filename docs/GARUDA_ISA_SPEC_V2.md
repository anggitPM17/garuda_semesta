# GARUDA SEMESTA — 64-bit ISA Specification V2

**Document Revision**: 12.0-ISA-SPEC-V2  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Instruction Word Encoding (64-bit Fixed Length)

The GARUDA Instruction Set Architecture uses a 64-bit fixed-length instruction word structure:

$$\text{Inst}[63:0] = \{ \text{Opcode}[63:60], \text{RS1}[59:55], \text{RS2}[54:50], \text{Reserved}[49:43], \text{RD}[42:38], \text{Reserved}[37:32], \text{Immediate}[31:0] \}$$

---

## 2. Opcode Table

| Opcode (Hex) | Instruction Mnemonic | Description | ALU / Execution Behavior |
| :---: | :--- | :--- | :--- |
| `0x0` | `NOP` | No Operation | Advance PC by 8 bytes |
| `0x1` | `ADD` | Arithmetic Addition | `rd = rs1 + (rs2 != 0 ? rs2 : imm)` |
| `0x2` | `SUB` | Arithmetic Subtraction | `rd = rs1 - (rs2 != 0 ? rs2 : imm)` |
| `0x3` | `LOAD` | Memory Load | `rd = mem[rs1 + imm]` |
| `0x4` | `STORE` | Memory Store | `mem[rs1 + imm] = rs2` |
| `0x5` | `BEQ` | Branch Equal | `if (rs1 == rs2) PC += imm` |
| `0x6` | `JMP` | Unconditional Jump | `PC = imm` |
| `0x7` | `MUL` | 64-bit Multiplication | `rd = rs1 * (rs2 != 0 ? rs2 : imm)` |
| `0x8` | `AND` | Bitwise AND | `rd = rs1 & rs2` |
| `0x9` | `OR` | Bitwise OR | `rd = rs1 | rs2` |
| `0xA` | `XOR` | Bitwise XOR | `rd = rs1 ^ rs2` |
| `0xF` | `HALT` | Pipeline Halt | Stop PC increment and set `halted = 1` |

---

## 3. Register Specification (32 x 64-bit)

- `r0`: Constant Zero (Hardwired to `64'h0`, writes ignored).
- `r1` - `r31`: General-Purpose 64-bit Integer Registers.
