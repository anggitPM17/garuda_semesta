/*
 * GARUDA SECURE Hardware Wallet & Vault C-SDK v1.0
 * Author & Chief System Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 */

#ifndef GARUDA_SECURE_H
#define GARUDA_SECURE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Hardware TRNG Quantum Entropy Generator
uint64_t garudaSecureGetRandomEntropy(uint8_t engine_id);

// NIST Post-Quantum Signature & Verification
void garudaSecurePqcSignTransaction(uint8_t engine_id, const uint8_t* tx_hash, uint8_t* signature_out);
int  garudaSecurePqcVerifySignature(uint8_t engine_id, const uint8_t* pubkey, const uint8_t* signature);

// Military Encryption & Anti-Tamper Zeroization
void garudaSecureAesGcmEncrypt(uint8_t engine_id, const uint8_t* plaintext, uint8_t* ciphertext, const uint8_t* key);
void garudaSecureTriggerHardwareZeroization(void);

#ifdef __cplusplus
}
#endif

#endif // GARUDA_SECURE_H
