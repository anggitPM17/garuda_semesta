# GARUDA SEMESTA GEN2 — CANONICAL SOURCE AUDIT & CONSOLIDATION REPORT

**Date:** November 23, 2026  
**Repository:** `anggitPM17/garuda_semesta`  
**Branch:** `generation-2`  

---

## 1. PRE-AUDIT STRUCTURE & CONFLICT ANALYSIS

During the forensic audit of FASE 6.3, two parallel directory trees were identified within the repository:
1. Primary Root Path: `gen2/rtl/core/...`, `gen2/tb/...`, `gen2/scripts/...`
2. Nested Duplicate Path: `gen2/gen2/rtl/core/...`, `gen2/gen2/tb/...`

This nested duplication occurred during recursive path copying and resulted in git commit discrepancies where remote VCS fetches referenced outdated RTL definitions while local builds operated on root files.

---

## 2. CANONICAL STRUCTURE CONSOLIDATION

All duplicate nested directories (`gen2/gen2/`) have been completely pruned and consolidated into the single canonical source hierarchy:

```
gen2/
├── rtl/
│   └── core/
│       ├── garuda_rv64i_core.v
│       ├── rv64i_alu.v
│       ├── rv64i_control_flow.v
│       ├── rv64i_decode.v
│       ├── rv64i_ex_mem_reg.v
│       ├── rv64i_hazard_unit.v
│       ├── rv64i_id_ex_reg.v
│       ├── rv64i_if_id_reg.v
│       ├── rv64i_load_store_unit.v
│       ├── rv64i_memory_model.v
│       ├── rv64i_mem_wb_reg.v
│       ├── rv64i_regfile.v
│       ├── rv64i_system_decode.v
│       └── rv64i_writeback.v
├── tb/
│   ├── garuda_rv64i_core_tb.v
│   └── tb_*.v
├── scripts/
│   ├── run_latency_tests.py
│   └── run_single_hart.sh
├── tests/
│   └── programs/
│       └── generate_program.py
└── reports/
    ├── FASE_6_5_FINAL_REPORT.md
    └── sim_latency_*.log
```

---

## 3. WORKFLOW PATH VERIFICATION

- All Python scripts (`run_latency_tests.py`, `generate_program.py`) dynamically infer `repo_dir` as `os.path.dirname(os.path.dirname(os.path.abspath(__file__)))`, resolving strictly to `gen2/`.
- All Docker mount commands map `-v "$(pwd)/gen2:/workspace"`, targeting the canonical `gen2/` root.
- Duplicate nested directories (`gen2/gen2/`) have been completely purged from git tracking.
