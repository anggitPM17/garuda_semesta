# GARUDA SEMESTA — 64-bit ISA Specification V2.3.1

**Document Revision**: 12.3.1-ISA-CONTRACT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Instruction Word Structure (64-bit Fixed Length)

$$\text{Inst}[63:0] = \{ \text{Opcode}[63:60], \text{RS1}[59:55], \text{RS2}[54:50], \text{Reserved}[49:43], \text{RD}[42:38], \text{Reserved}[37:32], \text{Immediate}[31:0] \}$$

---

## 2. Opcode Definitions Table

| Opcode (Hex) | Mnemonic | RS1 | RS2 | RD | Immediate | Description |
| :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `0x0` | `NOP` | - | - | - | - | No Operation |
| `0x1` | `ADD` | `rs1` | `rs2` | `rd` | `imm` | `rd = (rs1_val != 0 ? rs1_val : 0) + (rs2_val != 0 ? rs2_val : imm)` |
| `0x2` | `SUB` | `rs1` | `rs2` | `rd` | `imm` | `rd = rs1_val - (rs2_val != 0 ? rs2_val : imm)` |
| `0x3` | `LOAD` | `rs1` | - | `rd` | `imm` | `rd = SRAM[rs1_val + imm]` |
| `0x4` | `STORE` | `rs1` | `rs2` | - | `imm` | `SRAM[rs1_val + imm] = rs2_val` |
| `0x5` | `BEQ` | `rs1` | `rs2` | - | `target` | `if (rs1_val == rs2_val) PC = target` |
| `0x6` | `JMP` | - | - | - | `target` | `PC = target` |
| `0x7` | `MUL` | `rs1` | `rs2` | `rd` | `imm` | `rd = rs1_val * (rs2_val != 0 ? rs2_val : imm)` |
| `0x8` | `AND` | `rs1` | `rs2` | `rd` | `imm` | `rd = rs1_val & rs2_val` |
| `0x9` | `OR` | `rs1` | `rs2` | `rd` | `imm` | `rd = rs1_val | rs2_val` |
| `0xA` | `XOR` | `rs1` | `rs2` | `rd` | `imm` | `rd = rs1_val ^ rs2_val` |
| `0xF` | `HALT` | - | - | - | - | Pipeline Halt |

---

## 3. Register Specification (32 x 64-bit)

- `r0`: Hardwired Constant Zero (`64'h0`). Writes ignored.
- `r1` - `r31`: General Purpose 64-bit Registers.
