/*
 * GARUDA MCU IoT & Smart Device Microcontroller C-SDK v1.0
 * Author & Chief System Architect: Anggit Prasetyo Mituhu
 * Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
 * Licensed under the Apache License, Version 2.0
 */

#ifndef GARUDA_MCU_H
#define GARUDA_MCU_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// 24-bit High-Precision Analog ADC/DAC Sensor API
uint32_t garudaMcuReadAdcChannel(uint8_t channel);
void     garudaMcuSetDacVoltage(uint8_t channel, uint16_t millivolts);

// Integrated Wireless BLE 5.4 / Wi-Fi 7 Baseband API
void garudaMcuSendBlePacket(const uint8_t* payload, uint8_t len);
void garudaMcuConnectWifi(const char* ssid, const char* pass);

// Ultra-Low-Power Deep Sleep PMU Control
void garudaMcuEnterDeepSleep(uint32_t duration_ms);

#ifdef __cplusplus
}
#endif

#endif // GARUDA_MCU_H
