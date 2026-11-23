#!/usr/bin/env python3
import os

instructions = [
    "00a00093", # 0x00: addi x1, x0, 10
    "01400113", # 0x04: addi x2, x0, 20
    "002081b3", # 0x08: add x3, x1, x2 (30)
    "40110233", # 0x0c: sub x4, x2, x1 (10)
    "0020f2b3", # 0x10: and x5, x1, x2 (0)
    "0020e333", # 0x14: or x6, x1, x2 (30)
    "001143b3", # 0x18: xor x7, x2, x1 (30)
    "0020c433", # 0x1c: slt x8, x1, x2 (1)
    "001134b3", # 0x20: sltu x9, x2, x1 (0)
    "00209513", # 0x24: slli x10, x1, 2 (40)
    "123455b7", # 0x28: lui x11, 0x12345
    "01000617", # 0x2c: auipc x12, 0x1000
    "00303023", # 0x30: sd x3, 0(x0) (mem[0] = 30)
    "00003683", # 0x34: ld x13, 0(x0) (x13 = 30, load-use test)
    "00168733", # 0x38: add x14, x13, x1 (x14 = 30 + 10 = 40, forwarding test)
    "00208463", # 0x3c: beq x1, x2, 8 (not taken)
    "00108463", # 0x40: beq x1, x1, 8 (taken, skips next inst)
    "06300793", # 0x44: addi x15, x0, 99 (skipped)
    "04d00793", # 0x48: addi x15, x0, 77 (target: x15 = 77)
    "008008ef", # 0x4c: jal x16, 8 (jump)
    "03700893", # 0x50: addi x17, x0, 55 (skipped)
    "05800893", # 0x54: addi x17, x0, 88 (target: x17 = 88)
    "00100073"  # 0x58: ebreak (halt)
]

def main():
    repo_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    reports_dir = os.path.join(repo_dir, "reports")
    os.makedirs(reports_dir, exist_ok=True)
    hex_path = os.path.join(reports_dir, "single_hart_program.hex")

    with open(hex_path, "w", encoding="utf-8") as f:
        for inst in instructions:
            # Little endian byte representation or 32-bit hex lines for $readmemh
            # $readmemh reads 32-bit hex words (or bytes). If 32-bit words, each line is 8 hex chars.
            f.write(inst + "\n")

    print(f"Generated single_hart_program.hex at {hex_path} with {len(instructions)} instructions.")

if __name__ == "__main__":
    main()
