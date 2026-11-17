# GARUDA SEMESTA - Octa-Core SMP SoC v10.0 (EXCALIBUR BGA-2000+ Enterprise Edition)

Sistem perangkat keras (SoC) mikroelektronika kelas kakap (*hyperscale*) berskala industri yang meruntuhkan batasan *Tiny Tapeout*, melangkah maju sebagai desain **Enterprise-Grade Independent Tapeout** dengan konfigurasi **Grid BGA 2000+ Pin**. 

Ditenagai oleh **Octa-Core SMP Network-on-Chip (NoC)**, **Antarmuka Memori Eksternal DDR5**, jalur *high-speed* **PCIe Gen 5.0**, dan Instruksi Arsitektur (ISA) **64-Bit Enterprise**, chip ini dirancang khusus untuk bersaing langsung dengan arsitektur server kelas dunia seperti Nvidia Grace, AWS Graviton, dan AMD Epyc.

**Arsitek Sistem & Pencipta**: **Anggit Prasetyo Mituhu**

---

## 🚀 Fitur EXCALIBUR v10.0 (Hyperscale Level)

- **Grid BGA 2000+ Pin & 15x15mm Die Area**: Desain *pad-ring* masif independen yang melepaskan batasan I/O sempit, mendukung bandwidth memori dan interkoneksi super besar untuk *data center*.
- **Octa-Core (8-Core) SMP Network-on-Chip (NoC)**: Menggantikan *bus arbiter* tradisional dengan *2D Mesh Router* yang mampu menangani perutean jutaan paket pesan antar-aktor secara simultan.
- **Ekspansi Instruksi 64-Bit Enterprise ISA**: Instruksi diperlebar menjadi 64-bit (`[Opcode:4][PID:4][Addr:12][Size:12][Data:32]`), mendukung hingga 16 PID aktif berbarengan, pengalamatan register raksasa, dan presisi payload absolut.
- **Antarmuka DDR5 PHY Controller**: Pin khusus untuk pengontrol memori eksternal DDR5 (256-bit *wide-burst* data bus) untuk kapasitas RAM terabyte.
- **PCIe Gen 5.0 x16 SerDes**: Jalur I/O *high-speed differential* untuk komunikasi GPU (*Multi-Accelerator Link*) atau jaringan 10GbE MAC.
- **Neuromorphic SNN & Tensor Transformer GEMM**: Akselerator terintegrasi untuk kecerdasan buatan (*generative AI* & jaringan saraf tiruan otak).
- **Post-Quantum Cryptography (PQC)**: Mesin Enkripsi Lattice tahan kuantum standar NIST (Kyber/Dilithium).

## 📁 Struktur Repositori Enterprise

- `src/project.v` : Kode Sumber Verilog RTL Utama (Modul `garuda_excalibur_top`, `garuda_cpu_core64`, `garuda_noc_router_memory_controller`)
- `openlane/config.json` : Skrip Konfigurasi Sintesis Fisik Macro Scale (Target 15x15 mm)
- `garuda_compiler.py` : Toolchain Compiler Python v10.0 EXCALIBUR (Generator Bitstream 64-bit)
- `LICENSE` : Lisensi Resmi Apache 2.0 (Hak Cipta © 2026 Anggit Prasetyo Mituhu)

## 🛠️ Output Toolchain Compiler 64-Bit

Output Verilog ROM (`64'h...`) dari instruksi GARUDA level tinggi:
```verilog
// =========================================================
// AUTO-GENERATED GARUDA ROM BY AI COMPILER AGENT v10.0 EXCALIBUR
// Target Architecture: GARUDA SEMESTA Octa-Core BGA-2000 NoC ASIC (64-bit Bitstream)
// =========================================================
instruction_rom[0] = 64'h1000004000000000;
instruction_rom[1] = 64'h2004800000020003;
instruction_rom[2] = 64'h2005000012345678;
instruction_rom[3] = 64'h2006200000000047;
instruction_rom[4] = 64'h4000004000000000;
instruction_rom[5] = 64'h0000000000000000;
```

## 📄 Lisensi & Hak Cipta

Dipublikasikan di bawah **Apache License 2.0**.
Hak Cipta © 2026 **Anggit Prasetyo Mituhu**. Seluruh hak dilindungi undang-undang.
