# GARUDA SEMESTA GEN2 — FASE 6.7.5.1 4-CORE MULTI-HART ARCHITECTURE SPECIFICATION

**Document Version:** 1.0.0  
**Date:** November 26, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Status:** **SPECIFICATION COMPLETE (DESIGN ONLY — NO RTL MODIFIED)**  

---

## 1. ARCHITECTURE OVERVIEW & TOPOLOGY

The **Garuda Semesta Gen2 4-Core Multiprocessor** is a shared-memory multi-hart architecture designed for high-throughput, deterministic execution of parallel workloads. It consists of four independent **Garuda RV64I Cores** (Hart 0, Hart 1, Hart 2, and Hart 3) integrated via a **4-Port Crossbar Interconnect**, a **Round-Robin Bus Arbiter**, a **Shared Memory Subsystem**, and a **Core-Local Interruptor (CLINT) / Mailbox** subsystem for inter-hart coordination.

```
+-------------------+  +-------------------+  +-------------------+  +-------------------+
|   GARUDA CORE 0   |  |   GARUDA CORE 1   |  |   GARUDA CORE 2   |  |   GARUDA CORE 3   |
|   (Hart ID 0)     |  |   (Hart ID 1)     |  |   (Hart ID 2)     |  |   (Hart ID 3)     |
+---------+---------+  +---------+---------+  +---------+---------+  +---------+---------+
          |                      |                      |                      |
          +----------------------+----------+-----------+----------------------+
                                            |
                                            v
                      +-------------------------------------------+
                      |   4-PORT MEMORY INTERCONNECT & ROUTER     |
                      +---------------------+---------------------+
                                            |
                                            v
                      +-------------------------------------------+
                      |     ROUND-ROBIN BUS ARBITER (GRANT LOCK)  |
                      +---------------------+---------------------+
                                            |
                                            v
                      +-------------------------------------------+
                      |   SHARED MEMORY SUBSYSTEM & MMIO BUS      |
                      +-------+--------------------+--------------+
                              |                    |
                              v                    v
                      +---------------+   +------------------+
                      | SHARED RAM &  |   | CLINT, TIMER &   |
                      | BOOT ROM      |   | HARDWARE MAILBOX |
                      +---------------+   +------------------+
```

---

## 2. MODULE RESPONSIBILITY MATRIX

| Module Name | File Path | Responsibilities & Functions |
| :--- | :--- | :--- |
| **`garuda_rv64i_core`** | `gen2/rtl/core/garuda_rv64i_core.v` | 5-stage pipelined RV64I core with ready/valid memory handshake and `core_halted` signal. |
| **`garuda_hart_wrapper`** | `gen2/rtl/multicore/garuda_hart_wrapper.v` | Encapsulates single core, injects `hart_id` (`2'b00`..`2 me'b11`), maps `CSR_MHARTID`, isolates per-hart stall/interrupt signals. |
| **`garuda_bus_arbiter`** | `gen2/rtl/multicore/garuda_bus_arbiter.v` | Round-robin arbitration for 4 request ports. Locks grant until transaction completes (`dmem_resp_valid && dmem_resp_ready`). |
| **`garuda_response_router`** | `gen2/rtl/multicore/garuda_response_router.v` | Routes memory response data/valid signals exclusively to the hart owning the active transaction. |
| **`garuda_memory_interconnect`** | `gen2/rtl/multicore/garuda_memory_interconnect.v` | Top-level interconnect wrapper combining Arbiter, Request Multiplexer, and Response Router. |
| **`garuda_shared_ram`** | `gen2/rtl/memory/garuda_shared_ram.v` | 256 KB 64-bit multi-bank shared RAM model supporting 8-byte write enables (`dmem_funct3` decoding). |
| **`garuda_boot_rom`** | `gen2/rtl/memory/garuda_boot_rom.v` | 8 KB read-only memory holding bootloader code for multi-hart startup and park/wake loops. |
| **`garuda_clint`** | `gen2/rtl/interrupt/garuda_clint.v` | Core Local Interruptor: 64-bit `mtime`, per-hart `mtimecmp0..3`, and Software Interrupt pending registers (`msip0..3`). |
| **`garuda_mailbox`** | `gen2/rtl/interrupt/garuda_mailbox.v` | Hardware Mailbox MMIO module with hardware atomic mutex locks (`LOCK_REG[3:0]`) for inter-hart sync without A-extension. |
| **`garuda_4core_top`** | `gen2/rtl/multicore/garuda_4core_top.v` | Top-level System-on-Chip instantiating 4 Hart Wrappers, Interconnect, Shared RAM, ROM, CLINT, and Mailbox. |

---

## 3. CORE ISOLATION & HART IDENTIFICATION

Each hart runs in complete isolation with no shared architectural registers or shared pipeline state:
1. **Independent State**:
   - **PC**: Independent 64-bit Program Counter per hart (`pc0`, `pc1`, `pc2`, `pc3`).
   - **Regfile**: Independent 32 x 64-bit Integer Register File per hart (`x0`..`x31`).
   - **Pipeline Registers**: Independent IF/ID, ID/EX, EX/MEM, MEM/WB pipeline registers per hart.
   - **Core Status**: Independent `core_halted` signal per hart.
2. **Hart ID Injection**:
   - Input port `wire [1:0] hart_id` supplied to `garuda_hart_wrapper`:
     - Core 0: `hart_id = 2'b00`
     - Core 1: `hart_id = 2'b01`
     - Core 2: `hart_id = 2'b10`
     - Core 3: `hart_id = 2'b11`
   - Reading `CSR_MHARTID` (Address `0xF14`) or boot register `x10` (`a0`) returns the hart's zero-extended `hart_id` (`64'd0`, `64'd1`, `64'd2`, `64'd3`).

---

## 4. MEMORY INTERCONNECT & ARBITRATION SPECIFICATION

### 4.1 Interface Signal Specification

Each Hart Wrapper exposes two memory ports to the Interconnect:
- **Instruction Memory Port** (Read-only, 32-bit):
  - `imem_addr` [63:0], `imem_valid`, `imem_ready`, `imem_rdata` [31:0], `imem_resp_valid`
- **Data Memory Port** (Read/Write, 64-bit):
  - `dmem_addr` [63:0], `dmem_valid`, `dmem_wen`, `dmem_funct3` [2:0], `dmem_wdata` [63:0]
  - `dmem_ready`, `dmem_rdata` [63:0], `dmem_resp_valid`, `dmem_resp_ready_in`, `dmem_resp_ready`

### 4.2 Round-Robin Arbitration Protocol
1. **Round-Robin Pointer**: Maintains a 2-bit pointer `arb_ptr` indicating the last served hart ID.
2. **Grant Selection (`grant[3:0]`)**:
   - Evaluates pending requests starting at `(arb_ptr + 1) % 4`.
   - Generates one-hot `grant[3:0]` selecting Hart 0, 1, 2, or 3.
3. **Transaction Grant Lock**:
   - When `grant[i]` is issued for a memory transaction, the arbiter **LOCKS** `grant[3:0]` on Hart `i`.
   - The grant lock remains active until the response handshake completes (`dmem_resp_valid && dmem_resp_ready_core`).
   - Prevents transaction interleaving or mid-transaction grant switching.
4. **Fairness & Starvation Prevention**:
   - After a transaction completes, `arb_ptr` advances to `i`.
   - Any hart experiencing backpressure cannot stall other harts that have acquired the bus.
5. **Outstanding Limit**:
   - Initial constraint: **1 outstanding transaction per hart**.
   - No pipelined out-of-order memory transactions across harts in Version 1.0.

---

## 5. RESPONSE ROUTING & TRANSACTION OWNERSHIP MODEL

To guarantee zero response crosstalk and zero unsolicited response acceptance:
1. **Owner Tag Latching**:
   - When a transaction is granted, `owner_hart_id` [1:0] is latched into the Interconnect's Transaction Owner Register.
2. **Strict Response Steering**:
   - `shared_dmem_rdata` is broadcast to all harts.
   - `shared_dmem_resp_valid` is gated exclusively to Hart `owner_hart_id`:
     ```verilog
     assign hart_dmem_resp_valid[0] = shared_dmem_resp_valid && (owner_hart_id == 2'b00);
     assign hart_dmem_resp_valid[1] = shared_dmem_resp_valid && (owner_hart_id == 2'b01);
     assign hart_dmem_resp_valid[2] = shared_dmem_resp_valid && (owner_hart_id == 2'b10);
     assign hart_dmem_resp_valid[3] = shared_dmem_resp_valid && (owner_hart_id == 2'b11);
     ```
3. **Backpressure Isolation**:
   - If Hart 0 is stalled waiting for response ready, Hart 1, 2, and 3 request interfaces are held in `dmem_ready = 0` until Hart 0 completes its response and releases the grant.

---

## 6. PROPOSED SYSTEM MEMORY MAP

| Address Range | Size | Component / Device | Access Permissions |
| :--- | :--- | :--- | :--- |
| **`0x0000_0000 - 0x0000_1FFF`** | 8 KB | **Boot ROM (Shared)** | Read-Only (Executable) |
| **`0x0000_2000 - 0x0000_200F`** | 16 B | **Hardware Mailbox (MMIO)** | Read/Write (Inter-Hart Sync) |
| **`0x0000_2010 - 0x0000_201F`** | 16 B | **Hardware Atomic Lock Registers** | Read/Write (Mutex Locks) |
| **`0x0002_0000 - 0x0002_000F`** | 16 B | **CLINT MSIP Registers** | Read/Write (Software Interrupts) |
| **`0x0002_4000 - 0x0002_401F`** | 32 B | **CLINT MTIMECMP Registers** | Read/Write (Timer Comparators) |
| **`0x0002_BFF8 - 0x0002_BFFF`** | 8 B | **CLINT MTIME Register** | Read-Only (System Timer) |
| **`0x8000_0000 - 0x8003_FFFF`** | 256 KB | **Shared Main RAM** | Read/Write (Executable) |

---

## 7. RESET, BOOTLOADER & INTER-HART SYNCHRONIZATION

### 7.1 Multi-Hart Reset Behavior
1. Upon `rst_n` deassertion, all 4 harts reset simultaneously with `PC = 0x0000_0000` (Boot ROM entry).

### 7.2 Bootloader Execution Flow
```assembly
// Boot ROM Entry Code for All Harts
boot_entry:
    csrr  a0, mhartid         // Read Hart ID into register a0 (0, 1, 2, 3)
    bnez  a0, secondary_park  // If Hart ID != 0, jump to secondary park loop

primary_boot:
    // Hart 0 initializes Shared RAM data and BSS
    la    sp, _stack_hart0    // Set Hart 0 stack pointer
    call  main_init           // Run primary C/assembly initialization
    li    t0, 0x00020000      // CLINT MSIP0 address for Hart 1 wake-up
    li    t1, 1
    sd    t1, 0(t0)           // Trigger Software Interrupt to wake Hart 1
    j     main_hart0

secondary_park:
    // Harts 1, 2, 3 park loop in Boot ROM
    wfi                       // Wait For Interrupt (low power spin)
    csrr  t0, mip
    andi  t0, t0, 0x08        // Check Software Interrupt Pending bit
    beqz  t0, secondary_park  // Loop until wake-up signal received
    la    sp, _stack_secondary
    j     main_secondary_hart
```

### 7.3 Inter-Hart Synchronization Without A-Extension (LR/SC / AMO)
Since the base RV64I ISA does not include atomic instructions (`LR.D`, `SC.D`, `AMOSWAP`):
1. **Hardware MMIO Mutex Registers (`0x0000_2010`)**:
   - `LOCK_REG0` .. `LOCK_REG3` provide hardware atomic Test-and-Set.
   - Reading `LOCK_REG[i]` returns `1'b0` if lock was free (and atomically acquires the lock, setting state to `1'b1`).
   - Reading `LOCK_REG[i]` returns `1'b1` if lock was already held.
   - Writing `1'b0` to `LOCK_REG[i]` releases the hardware lock.
2. **Future RISC-V A-Extension Roadmap**:
   - Phase 2 upgrade will implement `LR.D` (Load-Reserved) and `SC.D` (Store-Conditional) with an internal Reservation Set monitor in the Interconnect.

---

## 8. MULTICORE VERIFICATION MATRIX

| Test ID | Test Category | Verification Objective & Scenario | Expected Pass Criteria |
| :--- | :--- | :--- | :--- |
| **MC-01** | Simultaneous Requests | All 4 Harts issue memory requests at T=100ns. | Arbiter grants requests sequentially in Round-Robin order (0 -> 1 -> 2 -> 3). |
| **MC-02** | Round-Robin Fairness | Harts 0, 1, 2, 3 continuously flood memory read requests. | Each hart receives exactly 25% bus allocation (+/- 1 transaction). |
| **MC-03** | Response Routing | Hart 2 issues read to `0x8000_1000`; Hart 0 issues read to `0x8000_2000`. | `dmem_rdata` of `0x8000_1000` arrives strictly at Hart 2; zero crosstalk to Hart 0. |
| **MC-04** | Backpressure Isolation | Hart 1 encounters 8-cycle backpressure stall on response. | Harts 0, 2, 3 execute cleanly without corruption once Hart 1 releases grant. |
| **MC-05** | Mixed Read/Write | Hart 0 writes `0x1234` to `0x8000_0000`; Hart 1 reads `0x8000_0000`. | Read returns correct value (`0x1234`) after write commit completes. |
| **MC-06** | Reset During Pending Tx | Reset `rst_n` asserted while Hart 3 transaction is in `STATE_WAIT`. | Interconnect clears `owner_hart_id`, arbiter resets pointer, all harts restart at PC 0. |
| **MC-07** | Duplicate Response Rejection | Fake response injected for idle Hart 3. | Response Router gates response; Hart 3 scoreboard registers zero duplicate responses. |
| **MC-08** | Mailbox Inter-Hart Sync | Hart 0 writes wake-up token to Mailbox; Hart 1 reads token. | Hart 1 detects token and exits secondary park loop. |
| **MC-09** | CLINT Timer Interrupt | MTIME reaches MTIMECMP1 for Hart 1. | Hart 1 asserts Timer Interrupt Pending; enters interrupt handler. |
| **MC-10** | Hardware Lock Mutex | Hart 0 and Hart 1 read `LOCK_REG0` simultaneously. | Exactly one hart receives `0` (lock acquired); the other receives `1` (lock busy). |
| **MC-11** | Parallel Program Execution | All 4 harts run independent sorting algorithm on separate RAM arrays. | All 4 harts reach `EBREAK` successfully; all 4 memory arrays correctly sorted. |

---

## 9. RISKS, LIMITATIONS & ARCHITECTURAL DECISIONS

1. **Bus Contention Overhead**:
   - With 4 harts sharing a single 64-bit bus without L1 instruction/data caches, memory bandwidth limits peak IPC per core to ~0.25 under heavy memory traffic.
   - *Mitigation Plan*: Implement private L1 Instruction and Data Caches in Phase 6.7.5.4 to filter 90%+ of memory requests.
2. **Atomic Instruction Absence**:
   - Lack of RV64A extension requires software spin-locks to use MMIO Hardware Mutex registers.
   - *Mitigation Plan*: Define clear MMIO Mutex API in C runtime.
3. **No Unrelated RTL Changes**:
   - Single-hart core (`garuda_rv64i_core.v`) remains 100% untouched.

---

## 10. SPECIFICATION VERDICT

- **Architecture Status**: **`FASE 6.7.5.1 SPECIFICATION COMPLETE`**
- **Next Recommended Phase**: **`FASE 6.7.5.2 — HART ID & CORE WRAPPER IMPLEMENTATION`**
