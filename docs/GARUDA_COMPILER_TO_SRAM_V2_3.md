# GARUDA SEMESTA — Compiler-to-SRAM Integration Specification V2.3

**Document Revision**: 12.3-COMPILER-TO-SRAM  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Integration Execution Path

$$\mathbf{\text{GARUDA Assembly Source}} \xrightarrow{\texttt{garuda\_compiler.py}} \mathbf{\text{program.hex}} \xrightarrow{\text{I-Cache}} \mathbf{\text{CPU 5-Stage Pipeline RTL}} \xrightarrow{\text{L1/L2 Cache}} \mathbf{\text{Memory Controller}} \xrightarrow{\text{SRAM } \texttt{0x80000100}} = \mathbf{500}$$

---

## 2. Source Code & Binary Mapping

- **GARUDA Assembly Input Program**:
  ```assembly
  MOV r1, 150
  MOV r2, 350
  ADD r3, r1, r2
  STORE r3, [r0 + 0x80000100]
  HALT
  ```

- **Emitted Machine Code (`program.hex`)**:
  ```text
  1000004000000096
  100000800000015E
  108800C000000000
  400C000080000100
  F000000000000000
  ```

- **SRAM Independent Readback Assertion**:
  `assert(SRAM[0x80000100] == 500)` -> **PASSED 100%**
