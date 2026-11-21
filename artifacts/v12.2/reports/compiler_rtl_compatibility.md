# GARUDA SEMESTA V12.2 — COMPILER-TO-RTL COMPATIBILITY REPORT
**Author & Chief System Architect:** Anggit Prasetyo Mituhu  
**Date:** November 2026  
**Status:** **PASSED**  

---

## 1. Compiler Output & Encoding Verification

[garuda_compiler.py](file:///D:/richat/garuda_semesta_repo/garuda_compiler.py) emits each 64-bit instruction as two consecutive 32-bit hex lines in `program.hex`:

```asm
MOV r1, 150
MOV r2, 350
ADD r3, r1, r2
STORE r3, [r0 + 0x80000100]
HALT
```

Generated `program.hex`:
- Line 0: `00000096` (Lower 32 bits of `MOV r1, 150`)
- Line 1: `10000040` (Upper 32 bits of `MOV r1, 150`)
- Line 2: `0000015E` (Lower 32 bits of `MOV r2, 350`)
- Line 3: `10000080` (Upper 32 bits of `MOV r2, 350`)
- Line 4: `00000000` (Lower 32 bits of `ADD r3, r1, r2`)
- Line 5: `108800C0` (Upper 32 bits of `ADD r3, r1, r2`)
- Line 6: `80000100` (Lower 32 bits of `STORE r3, [r0 + 0x80000100]`)
- Line 7: `400C0000` (Upper 32 bits of `STORE r3, [r0 + 0x80000100]`)
- Line 8: `00000000` (Lower 32 bits of `HALT`)
- Line 9: `F0000000` (Upper 32 bits of `HALT`)

---

## 2. Hardware Decoder Parsing Verification

[garuda_idecode.v](file:///D:/richat/garuda_semesta_repo/src/cpu/garuda_idecode.v) parses the assembled 64-bit instruction word (`inst_word[63:0]`):
- `opcode = inst_word[63:60]`
- `rs1 = inst_word[59:55]`
- `rs2 = inst_word[54:50]`
- `rd = inst_word[42:38]`
- `imm_data = inst_word[31:0]`

Every instruction field emitted by the compiler matches the RTL decoder definitions 100%.
