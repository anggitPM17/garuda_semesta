import subprocess

subprocess.run(['apt-get', 'update', '-qq'])
subprocess.run(['apt-get', 'install', '-y', '-qq', 'iverilog'])

cmd = [
    'iverilog', '-g2012', '-Wall', '-s', 'tb_cpu_load_store_v123', '-o', 'build/tb_cpu_load_store_v123.vvp',
    'src/memory/garuda_bus_adapter_64to32.v', 'src/memory/garuda_l1_icache.v', 'src/memory/garuda_l1_dcache.v',
    'src/memory/garuda_l2_cache.v', 'src/memory/garuda_memory_arbiter.v', 'src/memory/garuda_memory_controller.v',
    'src/memory/garuda_memory_subsystem_top.v', 'src/cpu/garuda_pc.v', 'src/cpu/garuda_idecode.v',
    'src/cpu/garuda_regfile.v', 'src/cpu/garuda_alu.v', 'src/cpu/garuda_cpu_pipeline_top.v',
    'src/integration/garuda_vertical_slice_top.v', 'tests/rtl/cpu/tb_cpu_load_store_v123.v'
]
res_c = subprocess.run(cmd, capture_output=True, text=True)
print("Compile returncode:", res_c.returncode)
if res_c.returncode != 0:
    print("Compile stderr:", res_c.stderr)
else:
    res_s = subprocess.run(['vvp', 'build/tb_cpu_load_store_v123.vvp'], capture_output=True, text=True, timeout=120)
    print("VVP exit code:", res_s.returncode)
    print("VVP stdout:\n", res_s.stdout)
    print("VVP stderr:\n", res_s.stderr)
