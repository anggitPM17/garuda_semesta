# GARUDA SEMESTA — 5-Chip Architecture Specification V2

**Document Revision**: 12.0-FIVE-CHIP-SPEC-V2  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. 5-Chip Ecosystem Hardware Map

$$\begin{array}{|c|l|c|l|c|}
\hline
\textbf{\#} & \textbf{Chip Target} & \textbf{RTL Module Path} & \textbf{Hardware Execution Unit} & \textbf{Verification Status} \\
\hline
\mathbf{1} & \textbf{GARUDA CPU SoC} & \texttt{src/cpu/garuda\_cpu\_pipeline\_top.v} & 32\text{-Core 5-Stage Pipeline Core} & \mathbf{\text{RTL SIMULATED}} \\
\mathbf{2} & \textbf{GARUDA GPU} & \texttt{src/gpu/garuda\_gpu\_shader\_simd.v} & 16\text{-Lane SIMD + 512 WMMA Tensor Cores} & \mathbf{\text{RTL SIMULATED}} \\
\mathbf{3} & \textbf{GARUDA NPU} & \texttt{src/npu/garuda_npu_systolic_array.v} & 16\times16\text{ Systolic Matrix Array (256 MACs)} & \mathbf{\text{RTL SIMULATED}} \\
\mathbf{4} & \textbf{GARUDA SECURE} & \texttt{src/secure/garuda\_secure\_crypto\_engine.v} & \text{NIST PQC Kyber NTT \& Photonic Mesh} & \mathbf{\text{RTL SIMULATED}} \\
\mathbf{5} & \textbf{GARUDA MCU} & \texttt{src/mcu/garuda\_mcu\_peripherals.v} & \text{Sub-Nanowatt PMU Sleep } <0.1\text{ nA \& 24b ADC} & \mathbf{\text{RTL SIMULATED}} \\
\hline
\end{array}$$
