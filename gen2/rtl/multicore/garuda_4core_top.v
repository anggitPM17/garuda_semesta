`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — 4-Core Top-Level System-on-Chip
module garuda_4core_top (
    input  wire        clk,
    input  wire        rst_n,
    output wire [3:0]  core_halted_out
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

            // Instruction Fetch interface binding (Simple ROM/RAM fetch)
            assign h_imem_ready[i]      = 1'b1;
            assign h_imem_resp_valid[i] = h_imem_valid[i];
        end
    endgenerate

    // Interconnect Data Memory Signals
    wire [63:0] interconnect_mem_addr;
    wire        interconnect_mem_valid;
    wire        interconnect_mem_wen;
    wire [2:0]  interconnect_mem_funct3;
    wire [63:0] interconnect_mem_wdata;
    wire        interconnect_mem_ready;
    wire [63:0] interconnect_mem_rdata;
    wire        interconnect_mem_resp_valid;

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
        .mem_addr(interconnect_mem_addr),
        .mem_valid(interconnect_mem_valid),
        .mem_wen(interconnect_mem_wen),
        .mem_funct3(interconnect_mem_funct3),
        .mem_wdata(interconnect_mem_wdata),
        .mem_ready(interconnect_mem_ready),
        .mem_rdata(interconnect_mem_rdata),
        .mem_resp_valid(interconnect_mem_resp_valid)
    );

    // Shared Main RAM Subsystem
    garuda_shared_ram #(.LATENCY(1)) shared_ram_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(interconnect_mem_addr),
        .valid(interconnect_mem_valid),
        .wen(interconnect_mem_wen),
        .funct3(interconnect_mem_funct3),
        .wdata(interconnect_mem_wdata),
        .ready(interconnect_mem_ready),
        .rdata(interconnect_mem_rdata),
        .resp_valid(interconnect_mem_resp_valid)
    );

    // Shared Instruction Memory Mocks (Return EBREAK or custom instructions based on PC)
    generate
        for (i = 0; i < 4; i = i + 1) begin : imem_mocks
            // PC 0: csrr x10, mhartid (32'hF1402573)
            // PC 4: ebreak (32'h00100073)
            assign h_imem_rdata[i] = (h_imem_addr[i][3:0] == 4'h0) ? 32'hF1402573 : 32'h00100073;
        end
    endgenerate

endmodule
