# GARUDA SEMESTA - Quad-Core SMP SoC v4.0 (Ultimate Enterprise ASIC Edition)

Sistem perangkat keras (SoC) mikroelektronika enterprise berbasis **Quad-Core SMP** dengan **Hardware AES-128 Cryptographic Accelerator**, **2-Way Set-Associative L1 Data Cache**, **AXI4-Lite Bus Bridge**, **Tiny Tapeout 8 (TT08) Pinout Compliant**, **Hardware UART Serial Console**, **Hardware Timer Wheel & Event Loop Unit**, **Hardware Inter-Core Mailbox (IPC)**, **Active Hardware Garbage Collector (HW-GC)**, dan **GARUDA Compiler Toolchain v4.0 Ultimate** (43-bit Bitstream ISA).

## 🚀 Fitur Enterprise v4.0 Ultimate

- **Hardware AES-128 Cryptographic Accelerator**: Akselerator kriptografi enkripsi/dekripsi AES-128 berbasis hardware (Address `56`) untuk keamanan siber tingkat militer (*Zero-Trust Security*).
- **2-Way Set-Associative L1 Data Cache & Tag Controller**: Sub-sistem L1 Data Cache hardware dengan kontroler Tag untuk menurunkan latensi akses memori privat (`cache_hit` signal).
- **AXI4-Lite Bus Slave Bridge**: Antarmuka bus standar industri AXI4-Lite untuk integrasi plug-and-play dengan prosesor ARM Cortex, RISC-V, dan IP-Core FPGA Xilinx/Altera.
- **Tiny Tapeout 8 (TT08) & OpenLane ASIC Pinout Standard**: Top-level module `tt_um_garuda` dan `garuda_` kompatibel 100% untuk proses fabrikasi chip fisik (SkyWater 130nm / GF180).
- **Hardware UART Serial Peripheral**: Pemancar serial UART TX hardware (Address `62`) untuk mencetak log konsol secara real-time melalui Pin `uo_out[0]`.
- **Hardware Timer Wheel & Event Loop Unit**: Register Timer Wheel hardware (Address `61`) yang memicu interupsi IRQ presisi tanpa pemborosan siklus clock CPU (*Zero-CPU polling overhead*).
- **Quad-Core SMP Architecture**: Core 0 (PID 0), Core 1 (PID 1), Core 2 (PID 2), dan Core 3 (PID 3) berjalan paralel dengan eksekusi independen.
- **Hardware Inter-Core Mailbox (IPC)**: Komunikasi antar-proses (Core to Core) berkecepatan tinggi via register Mailbox hardware.
- **Active Hardware Garbage Collector (HW-GC)**: Modul HW-GC terintegrasi (`3'b100`) untuk reklamasi memori otomatis dan sinyal `gc_object_freed`.
- **Isolasi Memori MPU Per-PID**: *Memory Controller* menjaga ruang alamat heap privat (`heap_ptr_0` .. `heap_ptr_3`) untuk proteksi keamanan fisik chip.
- **AI Compiler Agent v4.0 Ultimate (`garuda_compiler.py`)**: Penerjemah instruksi bahasa GARUDA ke format Verilog ROM Hex (`instruction_rom[...]`).

## 📁 Struktur Repositori

- `src/project.v` : Kode Sumber Verilog RTL Utama (`tt_um_garuda`, `garuda_`, `garuda_cpu_core`, `garuda_memory_controller`, `garuda_crypto_core`, `garuda_uart_tx`)
- `garuda_compiler.py` : Toolchain Compiler & Assembler Python v4.0 Ultimate
- `README.md` : Dokumentasi Arsitektur Sistem v4.0 Enterprise

## 🛠️ Penggunaan Compiler

Jalankan compiler Python v4.0 Ultimate:

```bash
python garuda_compiler.py
```

Output Verilog ROM (`43'h...`):
```verilog
// =========================================================
// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v4.0 ULTIMATE
// Target Architecture: GARUDA SEMESTA Quad-Core Enterprise SoC (43-bit Bitstream)
// =========================================================
instruction_rom[0] = 43'h10140000000;
instruction_rom[1] = 43'h2018A5A5A5A5;
instruction_rom[2] = 43'h201f00000047;
instruction_rom[3] = 43'h203dCAFEBABE;
instruction_rom[4] = 43'h40140000000;
instruction_rom[5] = 43'h00000000000;
```
