# GARUDA SEMESTA - Quad-Core SMP SoC v1.0 & AI Compiler Toolchain

Sistem perangkat keras (SoC) mikroelektronika berbasis **Quad-Core SMP** dengan isolasi memori privat hardware-level, **Hardware Inter-Core Mailbox (IPC)**, **Active Hardware Garbage Collector (HW-GC)**, dan **GARUDA Compiler Toolchain v1.0** (43-bit Bitstream ISA).

## 🚀 Fitur Utama

- **Quad-Core SMP Architecture**: Core 0 (PID 0), Core 1 (PID 1), Core 2 (PID 2), dan Core 3 (PID 3) berjalan paralel dengan eksekusi independen.
- **Hardware Inter-Core Mailbox (IPC)**: Komunikasi antar-proses (Core to Core) berkecepatan tinggi via register Mailbox hardware tanpa mengunci bus.
- **Active Hardware Garbage Collector (HW-GC)**: Modul HW-GC terintegrasi (`3'b100`) untuk reklamasi memori otomatis dan mengibarkan sinyal `gc_object_freed`.
- **Isolasi Memori MPU Per-PID**: *Memory Controller* menjaga ruang alamat heap privat (`heap_ptr_0` .. `heap_ptr_3`) secara independen untuk proteksi keamanan fisik chip.
- **4-Way Round-Robin Bus Arbiter**: Penggiliran bus memori terpusat yang adil (*fair scheduling*) untuk 4 CPU Core.
- **Format Instruksi Bitstream 43-Bit**:
  - `Opcode (3b)` | `PID (2b)` | `Addr (6b)` | `Size (4b)` | `Data (32b)`
- **AI Compiler Agent (`garuda_compiler.py`)**: Penerjemah instruksi bahasa GARUDA ke format Verilog ROM Hex (`instruction_rom[...]`).

## 📁 Struktur Repositori

- `src/project.v` : Kode Sumber Verilog RTL Utama (`garuda_`, `garuda_cpu_core`, `garuda_memory_controller`)
- `garuda_compiler.py` : Toolchain Compiler & Assembler Python (43-bit Bitstream Generator)
- `README.md` : Dokumentasi Arsitektur Sistem v1.0

## 🛠️ Penggunaan Compiler

Jalankan compiler Python untuk membuat Verilog ROM:

```bash
python garuda_compiler.py
```

Output Verilog ROM (`43'h...`):
```verilog
// =========================================================
// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v1.0
// Target Architecture: GARUDA SEMESTA Quad-Core SoC (43-bit Bitstream)
// =========================================================
instruction_rom[0] = 43'h10140000000;
instruction_rom[1] = 43'h201411111111;
instruction_rom[2] = 43'h203dCAFEBABE;
instruction_rom[3] = 43'h40140000000;
instruction_rom[4] = 43'h00000000000;
```
