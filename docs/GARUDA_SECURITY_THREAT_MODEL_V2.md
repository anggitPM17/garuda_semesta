# GARUDA SEMESTA — Hardware Security Threat Model V2

**Document Revision**: 12.0-SECURITY-THREAT-MODEL-V2  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Physical & Cryptographic Threat Vectors

1. **Laser Fault Injection & Micro-Probing**: Mitigated by Indium Phosphide (InP) Photonic Anti-Tamper Mesh triggering sub-nanosecond key zeroization (`TAMPER_ZEROIZE_KEYS`).
2. **Post-Quantum Cryptanalytic Attacks**: Protected by NIST PQC Kyber-1024 (KEM) and Dilithium-5 (Digital MultiSig) hardware polynomial NTT cores.
3. **Side-Channel Timing Attacks**: Protected by Constant-Time Shielding logic (`ConstantTimeShield`).
4. **Entropy Exhaustion Attacks**: Protected by 128 Gbps Quantum TRNG Physical Entropy Collector passing NIST SP 800-90B health tests.
