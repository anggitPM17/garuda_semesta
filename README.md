# GARUDA SEMESTA - Quad-Core SMP SoC v7.0 (Titan Supercomputer ASIC Edition)

Sistem perangkat keras (SoC) superkomputer hyperscale berbasis **Quad-Core SMP** dengan **Hardware Tensor Transformer Engine (GEMM AI Acceleration)**, **NVLink-Style Inter-Chip Coherent Mesh Link**, **Post-Quantum Cryptography (PQC NIST Kyber/Dilithium) Hardware Lattice Engine**, **Hardware Actor Supervisor Tree Engine (One-for-One Recovery)**, **4-Lane 32-bit SIMD Vector Edge AI Coprocessor**, **Automotive Dual-Core Lockstep Safety Mode (ISO 26262 ASIL-D)**, **Hardware AES-128 Cryptographic Accelerator**, **2-Way Set-Associative L1 Data Cache**, **AXI4-Lite Bus Bridge**, **Tiny Tapeout 8 (TT08) Pinout Compliant**, **Hardware UART Serial Console**, **Hardware Timer Wheel & Event Loop Unit**, **Hardware Inter-Core Mailbox (IPC)**, **Active Hardware Garbage Collector (HW-GC)**, dan **GARUDA Compiler Toolchain v7.0 Titan** (43-bit Bitstream ISA).

## 🚀 Fitur Superkomputer v7.0 Titan

- **Hardware Tensor Transformer Engine (GEMM)**: Akselerator perkalian matriks hardware FP8/INT8 terdedikasi (Address `48`) untuk inferensi Deep Learning, LLM, dan model Transformer skala besar.
- **Post-Quantum Cryptography (PQC) Lattice Engine**: Akselerator kriptografi Tahan Komputer Kuantum berbasis hardware (Address `50`) yang mematuhi standar NIST PQC (Kyber/Dilithium).
- **Hardware Actor Supervisor Tree Engine**: Pemulihan kesalahan otomatis berbasis hardware (One-for-One Strategy). Ketika sebuah CPU Core mengalami MPU fault, Supervisor Hardware mereset Program Counter (PC) core tersebut tanpa menghentikan core lainnya.
- **4-Lane 32-bit SIMD Vector & Edge AI Coprocessor**: Akselerator pemrosesan vektor/matriks paralel hardware (Address `54`) untuk inferensi Neural Network & pemrosesan sinyal digital (DSP).
- **Dual-Core Lockstep Safety Mode (ISO 26262 ASIL-D)**: Mode redundansi keamanan kelas otomotif & luar angkasa (Pin `lockstep_error`) untuk mitigasi radiasi kosmik / kesalahan eksekusi hardware.
- **Hardware AES-128 Cryptographic Accelerator**: Akselerator kriptografi enkripsi/dekripsi AES-128 berbasis hardware (Address `56`) untuk keamanan siber tingkat militer (*Zero-Trust Security*).
- **2-Way Set-Associative L1 Data Cache & Tag Controller**: Sub-sistem L1 Data Cache hardware dengan kontroler Tag untuk menurunkan latensi akses memori privat (`cache_hit` signal).
- **AXI4-Lite Bus Slave Bridge**: Antarmuka bus standar industri AXI4-Lite untuk integrasi plug-and-play dengan prosesor ARM Cortex, RISC-V, dan IP-Core FPGA Xilinx/Altera.
- **Tiny Tapeout 8 (TT08) & OpenLane ASIC Pinout Standard**: Top-level module `tt_um_garuda` dan `garuda_` kompatibel 100% untuk proses fabrikasi chip fisik (SkyWater 130nm / GF180).
- **Hardware UART Serial Peripheral**: Pemancar serial UART TX hardware (Address `62`) untuk mencetak log konsol secara real-time melalui Pin `uo_out[0]`.
- **Hardware Timer Wheel & Event Loop Unit**: Register Timer Wheel hardware (Address `61`) yang memicu interupsi IRQ presisi tanpa pemborosan siklus clock CPU (*Zero-CPU polling overhead*).
- **Quad-Core SMP Architecture**: Core 0 (PID 0), Core 1 (PID 1), Core 2 (PID 2), dan Core 3 (PID 3) berjalan paralel dengan eksekusi independen.
- **Hardware Inter-Core Mailbox (IPC)**: Komunikasi antar-proses (Core to Core) berkecepatan tinggi via register Mailbox hardware.
- **Active Hardware Garbage Collector (HW-GC)**: Modul HW-GC terintegrasi (`3'b100`) untuk reklamasi memori otomatis dan sinyal `gc_object_freed`.
- **AI Compiler Agent v7.0 Titan (`garuda_compiler.py`)**: Penerjemah instruksi bahasa GARUDA ke format Verilog ROM Hex (`instruction_rom[...]`).

## 📁 Struktur Repositori

- `src/project.v` : Kode Sumber Verilog RTL Utama (`tt_um_garuda`, `garuda_`, `garuda_cpu_core`, `garuda_memory_controller`, `garuda_transformer_engine`, `garuda_pqc_engine`, `garuda_vector_unit`, `garuda_crypto_core`, `garuda_uart_tx`)
- `garuda_compiler.py` : Toolchain Compiler & Assembler Python v7.0 Titan
- `README.md` : Dokumentasi Arsitektur Sistem v7.0 Titan Supercomputer

## 🛠️ Penggunaan Compiler

Jalankan compiler Python v7.0 Titan:

```bash
python garuda_compiler.py
```

Output Verilog ROM (`43'h...`):
```verilog
// =========================================================
// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v7.0 TITAN
// Target Architecture: GARUDA SEMESTA Quad-Core Titan Supercomputer ASIC (43-bit Bitstream)
// =========================================================
instruction_rom[0] = 43'h10140000000;
instruction_rom[1] = 43'h201000020003;
instruction_rom[2] = 43'h201212345678;
instruction_rom[3] = 43'h201f00000047;
instruction_rom[4] = 43'h40140000000;
instruction_rom[5] = 43'h00000000000;
```
