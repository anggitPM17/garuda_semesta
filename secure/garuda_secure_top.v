// =========================================================
// GARUDA SEMESTA — SECURE CRYPTO VAULT TOP LEVEL VERILOG RTL v12.0
// Target Architecture: GARUDA SECURE Crypto Vault BGA-6144
// Author & Chief System Architect: Anggit Prasetyo Mituhu
// Copyright (c) 2026 Anggit Prasetyo Mituhu. All rights reserved.
// Licensed under the Apache License, Version 2.0
// =========================================================

`timescale 1ns / 1ps

module garuda_secure_top (
    input wire clk_sys,
    input wire rst_n,
    input wire [63:0] trng_entropy_in,
    output wire [63:0] key_vault_out,
    output wire secure_armed
);

    assign key_vault_out = trng_entropy_in ^ 64'hA5A5A5A5A5A5A5A5;
    assign secure_armed = rst_n;

endmodule
