# =========================================================================
# GARUDA SEMESTA — OFFICIAL EDA WORKSTATION DOCKERFILE v12.4.0
# Author & Chief System Architect: Anggit Prasetyo Mituhu
# Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
# Licensed under the Apache License, Version 2.0
#
# Reproducible Hardware EDA Toolchain Environment:
# - Ubuntu 22.04 LTS Base
# - Python 3.10+, pip, setuptools
# - Icarus Verilog (iverilog & vvp runtime v11.0)
# - GTKWave VCD Signal Analyzer (v3.4.0)
# - Make, Git, GCC/Clang Build Essentials
# =========================================================================

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install EDA Tools & Build Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    iverilog \
    gtkwave \
    make \
    git \
    build-essential \
    ca-certificates \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy Entrypoint Verification Script
COPY docker/eda/entrypoint.sh /usr/local/bin/garuda-eda-entrypoint
RUN chmod +x /usr/local/bin/garuda-eda-entrypoint

ENTRYPOINT ["/usr/local/bin/garuda-eda-entrypoint"]
CMD ["python3", "src/verification/garuda_real_rtl_runner.py"]
