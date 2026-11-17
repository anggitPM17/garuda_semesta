# GARUDA SEMESTA - Dual-Core SMP SoC v0.9 & AI Compiler Toolchain

Sistem perangkat keras (SoC) berbasis **Dual-Core SMP** dengan isolasi memori privat hardware-level dan **GARUDA Compiler Toolchain** 43-bit.

## 🚀 Fitur Utama

- **Dual-Core SMP Architecture**: Core 0 (PID 0) dan Core 1 (PID 1) berjalan paralel dengan eksekusi independen.
- **Isolasi Memori Per-PID**: *Memory Controller* menjaga ruang alamat heap privat (`heap_ptr_0` .. `heap_ptr_3`) secara otomatis.
- **Shared Bus Arbiter**: Mekanisme *Round-Robin Bus Arbiter* untuk mencegah persaingan bus memori antar CPU Core.
- **Format Instruksi Bitstream 43-Bit**:
  - `Opcode (3b)` | `PID (2b)` | `Addr (6b)` | `Size (4b)` | `Data (32b)`
- **AI Compiler Agent (`garuda_compiler.py`)**: Penerjemah instruksi bahasa GARUDA ke Verilog ROM hex format (`instruction_rom[...]`).

## 📁 Struktur Repositori

- `garuda_compiler.py` : Toolchain Compiler & Assembler Python (43-bit Bitstream Generator)
- `src/project.v` : Kode Sumber Verilog RTL (`garuda_soc_top`, `garuda_cpu_core`, `garuda_memory_controller`)
- `README.md` : Dokumentasi Arsitektur Sistem

## 🛠️ Penggunaan Compiler

Jalankan compiler Python untuk membuat Verilog ROM:

```bash
python garuda_compiler.py
```

Output Verilog ROM (`43'h...`):
```verilog
// =========================================================
// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT
// Target Architecture: GARUDA SEMESTA SoC (43-bit Bitstream)
// =========================================================
instruction_rom[0] = 43'h10140000400;
instruction_rom[1] = 43'h2014DEADBEEF;
instruction_rom[2] = 43'h30140000000;
instruction_rom[3] = 43'h40140000000;
instruction_rom[4] = 43'h00000000000;
```
