# GARUDA SEMESTA — Repository Storage Hygiene Report V2.3.3

**Document Revision**: 12.3.3-HYGIENE-REPORT  
**Author & Chief System Architect**: **Anggit Prasetyo Mituhu**  
**License**: Apache License 2.0 (Copyright © 2026 **Anggit Prasetyo Mituhu**)  

---

## 1. Executive Storage Hygiene Audit

1. **Temporary Build Directory (`src/runs/`)**: Verified that `.gitignore` correctly ignores `src/runs/` to prevent temporary OpenLane intermediate artifacts from being committed.
2. **Unrolled Part Files Catalog**: Cataloged 200 unrolled netlist part files (40 files per chip domain) in [`docs/GARUDA_UNROLLED_RTL_CATALOG.md`](GARUDA_UNROLLED_RTL_CATALOG.md) for 100M LOC factory netlist stream tracking.
3. **Executable & Binaries Exclusions**: Ensured binary installers (e.g. `klayout_setup.exe`) are kept separate from Git source control.
4. **Reproducible Artefact Policy**: All reports and VCD waveform outputs are dynamically generated under `reports/` and ignored/tracked reproducibly.
