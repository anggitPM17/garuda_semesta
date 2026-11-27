`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — 4-Core Top-Level SoC with CLINT & Mailbox
module garuda_4core_top (
    input  wire        clk,
    input  wire        rst_n,
    output wire [3:0]  core_halted_out,
    output wire [3:0]  timer_interrupt_out,
    output wire [3:0]  software_interrupt_out
);

    // Hart 0..3 memory interfaces
    wire [63:0] h_imem_addr [0:3];
    wire        h_imem_valid [0:3];
    wire        h_imem_ready [0:3];
    wire [31:0] h_imem_rdata [0:3];
    wire        h_imem_resp_valid [0:3];

    wire [63:0] h_dmem_addr [0:3];
    wire        h_dmem_valid [0:3];
    wire        h_dmem_wen [0:3];
    wire [2:0]  h_dmem_funct3 [0:3];
    wire [63:0] h_dmem_wdata [0:3];
    wire        h_dmem_ready [0:3];
    wire [63:0] h_dmem_rdata [0:3];
    wire        h_dmem_resp_valid [0:3];
    wire        h_dmem_resp_ready [0:3];

    // Instantiate 4 Hart Wrappers
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : harts
            garuda_hart_wrapper #(
                .HART_ID(i[1:0])
            ) wrapper_inst (
                .clk(clk),
                .rst_n(rst_n),
                .hart_id_in(i[1:0]),
                .imem_addr(h_imem_addr[i]),
                .imem_valid(h_imem_valid[i]),
                .imem_ready(h_imem_ready[i]),
                .imem_rdata(h_imem_rdata[i]),
                .imem_resp_valid(h_imem_resp_valid[i]),
                .dmem_addr(h_dmem_addr[i]),
                .dmem_valid(h_dmem_valid[i]),
                .dmem_wen(h_dmem_wen[i]),
                .dmem_funct3(h_dmem_funct3[i]),
                .dmem_wdata(h_dmem_wdata[i]),
                .dmem_ready(h_dmem_ready[i]),
                .dmem_rdata(h_dmem_rdata[i]),
                .dmem_resp_valid(h_dmem_resp_valid[i]),
                .dmem_resp_ready_in(1'b1),
                .dmem_resp_ready(h_dmem_resp_ready[i]),
                .core_halted(core_halted_out[i]),
                .effective_hart_id()
            );

            assign h_imem_ready[i]      = 1'b1;
            assign h_imem_resp_valid[i] = h_imem_valid[i];
            // PC 0: csrr x10, mhartid (32'hF1402573)
            // PC 4: ebreak (32'h00100073)
            assign h_imem_rdata[i] = (h_imem_addr[i][3:0] == 4'h0) ? 32'hF1402573 : 32'h00100073;
        end
    endgenerate

    // Interconnect Memory Subsystem Interfaces
    wire [63:0] ram_addr, clint_addr, mbox_addr;
    wire        ram_valid, clint_valid, mbox_valid;
    wire        ram_wen, clint_wen, mbox_wen;
    wire [2:0]  ram_funct3, clint_funct3, mbox_funct3;
    wire [63:0] ram_wdata, clint_wdata, mbox_wdata;
    wire        ram_ready, clint_ready, mbox_ready;
    wire [63:0] ram_rdata, clint_rdata, mbox_rdata;
    wire        ram_resp_valid, clint_resp_valid, mbox_resp_valid;

    garuda_memory_interconnect interconnect_inst (
        .clk(clk),
        .rst_n(rst_n),
        .h0_addr(h_dmem_addr[0]), .h0_valid(h_dmem_valid[0]), .h0_wen(h_dmem_wen[0]), .h0_funct3(h_dmem_funct3[0]), .h0_wdata(h_dmem_wdata[0]),
        .h1_addr(h_dmem_addr[1]), .h1_valid(h_dmem_valid[1]), .h1_wen(h_dmem_wen[1]), .h1_funct3(h_dmem_funct3[1]), .h1_wdata(h_dmem_wdata[1]),
        .h2_addr(h_dmem_addr[2]), .h2_valid(h_dmem_valid[2]), .h2_wen(h_dmem_wen[2]), .h2_funct3(h_dmem_funct3[2]), .h2_wdata(h_dmem_wdata[2]),
        .h3_addr(h_dmem_addr[3]), .h3_valid(h_dmem_valid[3]), .h3_wen(h_dmem_wen[3]), .h3_funct3(h_dmem_funct3[3]), .h3_wdata(h_dmem_wdata[3]),
        .h0_ready(h_dmem_ready[0]), .h0_rdata(h_dmem_rdata[0]), .h0_resp_valid(h_dmem_resp_valid[0]),
        .h1_ready(h_dmem_ready[1]), .h1_rdata(h_dmem_rdata[1]), .h1_resp_valid(h_dmem_resp_valid[1]),
        .h2_ready(h_dmem_ready[2]), .h2_rdata(h_dmem_rdata[2]), .h2_resp_valid(h_dmem_resp_valid[2]),
        .h3_ready(h_dmem_ready[3]), .h3_rdata(h_dmem_rdata[3]), .h3_resp_valid(h_dmem_resp_valid[3]),
        .ram_addr(ram_addr), .ram_valid(ram_valid), .ram_wen(ram_wen), .ram_funct3(ram_funct3), .ram_wdata(ram_wdata),
        .ram_ready(ram_ready), .ram_rdata(ram_rdata), .ram_resp_valid(ram_resp_valid),
        .clint_addr(clint_addr), .clint_valid(clint_valid), .clint_wen(clint_wen), .clint_funct3(clint_funct3), .clint_wdata(clint_wdata),
        .clint_ready(clint_ready), .clint_rdata(clint_rdata), .clint_resp_valid(clint_resp_valid),
        .mbox_addr(mbox_addr), .mbox_valid(mbox_valid), .mbox_wen(mbox_wen), .mbox_funct3(mbox_funct3), .mbox_wdata(mbox_wdata),
        .mbox_ready(mbox_ready), .mbox_rdata(mbox_rdata), .mbox_resp_valid(mbox_resp_valid)
    );

    // Shared Main RAM
    garuda_shared_ram #(.LATENCY(1)) shared_ram_inst (
        .clk(clk), .rst_n(rst_n),
        .addr(ram_addr), .valid(ram_valid), .wen(ram_wen), .funct3(ram_funct3), .wdata(ram_wdata),
        .ready(ram_ready), .rdata(ram_rdata), .resp_valid(ram_resp_valid)
    );

    // CLINT Subsystem
    garuda_clint clint_inst (
        .clk(clk), .rst_n(rst_n),
        .addr(clint_addr), .valid(clint_valid), .wen(clint_wen), .funct3(clint_funct3), .wdata(clint_wdata),
        .ready(clint_ready), .rdata(clint_rdata), .resp_valid(clint_resp_valid),
        .timer_interrupt(timer_interrupt_out),
        .software_interrupt(software_interrupt_out)
    );

    // Mailbox Subsystem
    garuda_mailbox mailbox_inst (
        .clk(clk), .rst_n(rst_n),
        .addr(mbox_addr), .valid(mbox_valid), .wen(mbox_wen), .funct3(mbox_funct3), .wdata(mbox_wdata),
        .ready(mbox_ready), .rdata(mbox_rdata), .resp_valid(mbox_resp_valid)
    );

endmodule
