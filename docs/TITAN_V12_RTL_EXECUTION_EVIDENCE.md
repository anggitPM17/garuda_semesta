# GARUDA SEMESTA — TITAN V12 RTL EXECUTION EVIDENCE REPORT

**Document Revision**: 12.0-EVIDENCE-VERIFIED  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**Project Owner**: **AnggitPM17**  
**Repository**: [https://github.com/AnggitPM17/garuda_semesta](https://github.com/AnggitPM17/garuda_semesta)  
**Working Branch**: `engineering/titan-v12-real-chip-integration`  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Verilog VVP Simulator Raw Log Output

```text
=========================================================================
GARUDA SEMESTA — EDA DOCKER WORKSTATION CONTAINER v12.3.2-R6.4
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================

[EDA CONTAINER INFO] Verifying Installed Hardware EDA Tools...
  - Python Version  : Python 3.10.12
  - Icarus Verilog : iverilog: no source files.
  - VVP Runtime    : Icarus Verilog runtime version 11.0 (stable) ()
  - GTKWave        : Could not initialize GTK!  Is DISPLAY env var/xhost set?
=========================================================================

[GARUDA COMPILER PIPELINE v2.4.6] INFO: [STAGE 1/8] Executing Real Compiler Pipeline...
[GARUDA COMPILER PIPELINE v2.4.6] INFO: Compiled 5 instructions -> Emitted program.hex (SHA-256: 0e8b376fa399d5ed...)
[GARUDA COMPILER PIPELINE v2.4.6] INFO: [STAGE 2/8] Toolchain Audit: iverilog=True, vvp=True, verilator=False, yosys=False
[GARUDA COMPILER PIPELINE v2.4.6] WARNING: [STAGE 3/8] Verilator not in PATH. Skipping verilator lint stage.
[GARUDA COMPILER PIPELINE v2.4.6] WARNING: [STAGE 4/8] Yosys not in PATH. Skipping logic synthesis stage.
[GARUDA COMPILER PIPELINE v2.4.6] INFO: [STAGE 5/8] Compiling RTL via Icarus Verilog (iverilog)...
[GARUDA COMPILER PIPELINE v2.4.6] INFO: [STAGE 6/8] Executing Simulation via VVP...
[GARUDA COMPILER PIPELINE v2.4.6] INFO: [STAGE 7/8] Negative Test Verification (Opcode 0xE Exception)...
=========================================================================
GARUDA SEMESTA — TITAN V12 REAL CHIP INTEGRATION RUNNER
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================

WARNING: /workspace/src/cpu/garuda_cpu_pipeline_top.v:58: $readmemh(program.hex): Not enough words in the file for the requested range [0:127].
VCD info: dumpfile rtl_waveform.vcd opened for output.
=========================================================================
GARUDA SEMESTA — VERTICAL SLICE VERILOG RTL TESTBENCH v12.4.6
Architect & Author: Anggit Prasetyo Mituhu
=========================================================================

[STAGE 1] Reset Released. 5-Stage CPU Fetching Compiled Instructions...
[SRAM CONTROLLER LOG] READ addr=0x80000000, word_idx=    0, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000000, word_idx=    0, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000000, word_idx=    0, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000000, word_idx=    0, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000008, word_idx=    2, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000008, word_idx=    2, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000010, word_idx=    4, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000010, word_idx=    4, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000018, word_idx=    6, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000018, word_idx=    6, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000020, word_idx=    8, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000020, word_idx=    8, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000020, word_idx=    8, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000020, word_idx=    8, data=         0
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[SRAM CONTROLLER LOG] WRITE addr=0x80000100, word_idx=   64, data=       500
[STAGE 2] Clock Cycles Executed: CPU HALTED at PC = 0x80000040
[SRAM CONTROLLER LOG] READ addr=0x80000040, word_idx=   16, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000040, word_idx=   16, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000040, word_idx=   16, data=         0
[STAGE 3] Performing Independent DMA Readback from SRAM 0x80000100...
[SRAM CONTROLLER LOG] READ addr=0x80000040, word_idx=   16, data=         0
[SRAM CONTROLLER LOG] READ addr=0x80000100, word_idx=   64, data=       500
[SRAM CONTROLLER LOG] READ addr=0x80000100, word_idx=   64, data=       500
[STAGE 4] Strict Assertion: Asserting SRAM[0x80000100] == 500...
PASS: REAL RTL SRAM READBACK VERIFIED (SRAM[0x80000100] == 500)

=========================================================================
 TITAN V12 INTEGRATION RUNNER STATUS: PASS (Exit Code: 0)
 EVIDENCE REPORT SAVED TO: '/workspace/artifacts/titan-v12-integration/reports/v12_integration_report.json'
=========================================================================
```

---

## 2. Machine-Readable Evidence JSON (`v12_integration_report.json`)

```json
{
  "project": "GARUDA SEMESTA",
  "milestone": "GARUDA TITAN V12 — REAL CHIP INTEGRATION RECOVERY",
  "timestamp_utc": "2026-11-20T16:12:32Z",
  "host_environment": "linux",
  "tool_versions": {
    "python": "3.10.12",
    "iverilog": "/usr/bin/iverilog",
    "vvp": "/usr/bin/vvp",
    "verilator": "BLOCKED",
    "yosys": "BLOCKED"
  },
  "overall_status": "PASS",
  "exit_code": 0,
  "details": {
    "compiler_pipeline": "PASS",
    "hex_sha256": "0e8b376fa399d5edc6da7e8be947b2abe794168a79d1f9b903c55f88286843ff",
    "instructions_compiled": 5,
    "sram_target_address": "0x80000100",
    "sram_expected_value": 500
  }
}
```
