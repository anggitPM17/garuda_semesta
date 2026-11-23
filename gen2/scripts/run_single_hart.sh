#!/usr/bin/env sh
set -e

echo "=== Compiling Garuda RV64I Single-Hart CPU & Testbench ==="
iverilog -g2012 -Wall -s garuda_rv64i_core_tb \
    -o /workspace/reports/garuda_rv64i_core.vvp \
    /workspace/rtl/core/rv64i_alu.v \
    /workspace/rtl/core/rv64i_decode.v \
    /workspace/rtl/core/rv64i_regfile.v \
    /workspace/rtl/core/rv64i_control_flow.v \
    /workspace/rtl/core/rv64i_load_store_unit.v \
    /workspace/rtl/core/rv64i_hazard_unit.v \
    /workspace/rtl/core/rv64i_if_id_reg.v \
    /workspace/rtl/core/rv64i_id_ex_reg.v \
    /workspace/rtl/core/rv64i_ex_mem_reg.v \
    /workspace/rtl/core/rv64i_mem_wb_reg.v \
    /workspace/rtl/core/rv64i_system_decode.v \
    /workspace/rtl/core/rv64i_writeback.v \
    /workspace/rtl/core/rv64i_memory_model.v \
    /workspace/rtl/core/garuda_rv64i_core.v \
    /workspace/tb/garuda_rv64i_core_tb.v

echo "=== Running VVP Simulation ==="
vvp /workspace/reports/garuda_rv64i_core.vvp
