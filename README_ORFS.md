# 🛠️ Panduan Sintesis Chip Raksasa (2000+ Pin) dengan OpenROAD Flow

Karena chip **GARUDA EXCALIBUR v10.0** memiliki ukuran *die* **15x15mm** dan **2110 Pin**, desain ini melampaui batas *cloud sandbox* gratis. Oleh karena itu, kita harus melakukan sintesis secara lokal di mesin (*Workstation/Server*) Anda.

## 📋 Persyaratan Sistem (System Requirements)
- **Sistem Operasi**: Linux (Ubuntu 22.04+) atau Windows dengan **WSL2** (Ubuntu).
- **Perangkat Lunak**: **Docker** (atau Docker Desktop untuk Windows/Mac).
- **RAM**: Minimal 32GB (Direkomendasikan 64GB untuk perutean 15x15mm).
- **Penyimpanan**: Minimal 20GB SSD bebas.

## 🚀 Langkah-langkah Eksekusi (Lokal)

### 1. Kloning Repositori OpenROAD Flow Scripts (ORFS)
Buka terminal Linux / WSL2 Anda dan jalankan:
```bash
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
```

### 2. Salin Konfigurasi GARUDA ke dalam ORFS
Salin folder proyek ini ke dalam direktori `designs/` di OpenROAD:
```bash
# Asumsikan Anda berada di dalam folder OpenROAD-flow-scripts
mkdir -p designs/sky130hd/garuda_excalibur
cp /path/to/garuda_semesta/orfs_workspace/garuda_excalibur/config.mk designs/sky130hd/garuda_excalibur/
cp /path/to/garuda_semesta/src/project.v designs/sky130hd/garuda_excalibur/
```
*(Ubah `/path/to/garuda_semesta` dengan path repositori ini di komputer Anda).*

### 3. Mulai Proses Fabrikasi Silikon Virtual!
Pastikan Docker sudah berjalan. Eksekusi perintah ini untuk memulai sintesis dari RTL ke GDSII:
```bash
make DESIGN_CONFIG=designs/sky130hd/garuda_excalibur/config.mk
```

### 4. Tunggu & Lihat Hasilnya
Proses ini akan berjalan melalui langkah Sintesis (Yosys), Penempatan Sel & Routing (OpenROAD), dan DRC/LVS. 
Karena skalanya 15x15mm, **proses ini bisa memakan waktu 4 hingga 8 jam** tergantung kecepatan CPU Anda.
Setelah selesai, hasil akhirnya berupa **file `.gds` dan visual `.png`** akan muncul di folder `results/sky130hd/garuda_excalibur/base/`.
