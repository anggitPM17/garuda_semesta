#!/usr/bin/env python3
import os

def encode_i(opcode, rd, rs1, imm, funct3):
    return ((imm & 0xFFF) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 7) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)

def encode_r(opcode, rd, rs1, rs2, funct3, funct7):
    return ((funct7 & 0x7F) << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 7) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)

def encode_s(opcode, rs1, rs2, imm, funct3):
    imm_hi = (imm >> 5) & 0x7F
    imm_lo = imm & 0x1F
    return (imm_hi << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 7) << 12) | (imm_lo << 7) | (opcode & 0x7F)

def encode_b(opcode, rs1, rs2, imm, funct3):
    i = imm & 0x1FFF
    b12 = (i >> 12) & 1
    b10_5 = (i >> 5) & 0x3F
    b4_1 = (i >> 1) & 0xF
    b11 = (i >> 11) & 1
    return (b12 << 31) | (b10_5 << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 7) << 12) | (b4_1 << 8) | (b11 << 7) | (opcode & 0x7F)

def encode_u(opcode, rd, imm):
    return ((imm & 0xFFFFF) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)

def encode_j(opcode, rd, imm):
    i = imm & 0x1FFFFF
    b20 = (i >> 20) & 1
    b10_1 = (i >> 1) & 0x3FF
    b11 = (i >> 11) & 1
    b19_12 = (i >> 12) & 0xFF
    return (b20 << 31) | (b19_12 << 12) | (b11 << 20) | (b10_1 << 21) | ((rd & 0x1F) << 7) | (opcode & 0x7F)

def main():
    instructions = [
        encode_i(0x13, 1, 0, 10, 0),    # 0x00: addi x1, x0, 10 (x1 = 10)
        encode_i(0x13, 2, 0, 20, 0),    # 0x04: addi x2, x0, 20 (x2 = 20)
        encode_r(0x33, 3, 1, 2, 0, 0),  # 0x08: add x3, x1, x2 (x3 = 30)
        0x00000013,                     # 0x0c: NOP
        0x00000013,                     # 0x10: NOP
        encode_r(0x33, 4, 2, 1, 0, 32), # 0x14: sub x4, x2, x1 (x4 = 10)
        encode_r(0x33, 5, 1, 2, 7, 0),  # 0x18: and x5, x1, x2 (x5 = 0)
        encode_r(0x33, 6, 1, 2, 6, 0),  # 0x1c: or x6, x1, x2 (x6 = 30)
        encode_r(0x33, 7, 2, 1, 4, 0),  # 0x20: xor x7, x2, x1 (x7 = 30)
        encode_r(0x33, 8, 1, 2, 2, 0),  # 0x24: slt x8, x1, x2 (x8 = 1)
        encode_r(0x33, 9, 2, 1, 3, 0),  # 0x28: sltu x9, x2, x1 (x9 = 0)
        encode_i(0x13, 10, 1, 2, 1),    # 0x2c: slli x10, x1, 2 (x10 = 40)
        encode_u(0x37, 11, 0x12345),    # 0x30: lui x11, 0x12345
        encode_u(0x17, 12, 0x1000),     # 0x34: auipc x12, 0x1000
        encode_s(0x23, 0, 3, 0, 3),     # 0x38: sd x3, 0(x0) (mem[0] = 30)
        encode_s(0x23, 0, 1, 8, 2),     # 0x3c: sw x1, 8(x0) (mem[8] = 10)
        encode_s(0x23, 0, 2, 16, 1),    # 0x40: sh x2, 16(x0) (mem[16] = 20)
        encode_s(0x23, 0, 1, 24, 0),    # 0x44: sb x1, 24(x0) (mem[24] = 10)
        encode_i(0x03, 13, 0, 0, 3),    # 0x48: ld x13, 0(x0) (x13 = 30)
        encode_i(0x03, 19, 0, 8, 2),    # 0x4c: lw x19, 8(x0) (x19 = 10)
        encode_i(0x03, 20, 0, 16, 1),   # 0x50: lh x20, 16(x0) (x20 = 20)
        encode_i(0x03, 21, 0, 24, 0),   # 0x54: lb x21, 24(x0) (x21 = 10)
        encode_r(0x33, 14, 13, 1, 0, 0),# 0x58: add x14, x13, x1 (x14 = 40)
        encode_b(0x63, 1, 2, 8, 0),     # 0x5c: beq x1, x2, 8 (not taken)
        encode_b(0x63, 1, 1, 8, 0),     # 0x60: beq x1, x1, 8 (taken)
        encode_i(0x13, 15, 0, 99, 0),   # 0x64: addi x15, x0, 99 (skipped)
        encode_i(0x13, 15, 0, 77, 0),   # 0x68: addi x15, x0, 77 (target)
        encode_j(0x6f, 16, 12),         # 0x6c: jal x16, 12
        encode_i(0x13, 17, 0, 55, 0),   # 0x70: addi x17, x0, 55 (skipped)
        encode_i(0x13, 17, 0, 56, 0),   # 0x74: addi x17, x0, 56 (skipped)
        encode_i(0x13, 17, 0, 88, 0),   # 0x78: addi x17, x0, 88 (JAL target)
        encode_u(0x17, 16, 0),          # 0x7c: auipc x16, 0 (x16 = PC)
        encode_i(0x13, 16, 16, 12, 0),  # 0x80: addi x16, x16, 12 (x16 points to ebreak at 0x8c)
        encode_i(0x67, 18, 16, 0, 0),   # 0x84: jalr x18, 0(x16) (jump to ebreak)
        encode_i(0x13, 0, 0, 123, 0),   # 0x88: addi x0, x0, 123 (skipped by jalr)
        0x00100073                      # 0x8c: ebreak (halt)
    ]

    repo_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)
    hex_path = os.path.join(reports_dir, "single_hart_program.hex")

    with open(hex_path, "w", encoding="utf-8") as f:
        for inst in instructions:
            f.write(f"{inst:08x}\n")

    print(f"Generated {len(instructions)} RV64I instructions into {hex_path}")

if __name__ == "__main__":
    main()
