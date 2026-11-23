# GARUDA SEMESTA GEN2 — FASE 6.6 SOURCE AUDIT REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  
**Commit SHA:** `becfafc` / `9569662` / `e90f593`  

---

## 1. SOURCE TREE AUDIT & CONSOLIDATION

### A. Pre-Audit Findings
Audit of branch `generation-2` revealed that duplicate nested paths (`gen2/gen2/`) existed alongside root `gen2/`.
- Root path: `gen2/rtl/core/...`, `gen2/tb/...`, `gen2/scripts/...`
- Nested path: `gen2/gen2/rtl/core/...`

### B. Resolution Actions
1. Purged `gen2/gen2/` nested tree from VCS index using `git rm -r --cached gen2/gen2`.
2. Permanently deleted local nested `gen2/gen2/` directories.
3. Established `gen2/` as the **sole canonical root** for all Gen2 RTL, testbenches, scripts, and reports.

---

## 2. CANONICAL STRUCTURE MATRIX

| Component | Canonical Directory Path | Active Files | Status |
| :--- | :--- | :--- | :--- |
| **RTL Core** | `gen2/rtl/core/` | `garuda_rv64i_core.v`, `rv64i_memory_model.v`, `rv64i_*.v` | **CANONICAL (ACTIVE)** |
| **Testbench** | `gen2/tb/` | `garuda_rv64i_core_tb.v`, `tb_rv64i_*.v` | **CANONICAL (ACTIVE)** |
| **Scripts** | `gen2/scripts/` | `run_latency_tests.py`, `run_single_hart.sh` | **CANONICAL (ACTIVE)** |
| **Tests** | `gen2/tests/programs/` | `generate_program.py` | **CANONICAL (ACTIVE)** |
| **Reports** | `gen2/reports/` | `FASE_6_6_SOURCE_AUDIT.md`, `FASE_6_6_FINAL_REPORT.md`, `sim_latency_*.log` | **CANONICAL (ACTIVE)** |

---

## 3. VERIFICATION OF SINGLE SOURCE TREE

- Running `git status` verifies `working tree clean`.
- Running `Get-ChildItem -Recurse -Depth 2 gen2` confirms no nested `gen2/gen2` tree exists.
- All Docker run commands target strictly `/workspace/rtl/core/`, `/workspace/tb/`, and `/workspace/scripts/` mounted from `gen2/`.
