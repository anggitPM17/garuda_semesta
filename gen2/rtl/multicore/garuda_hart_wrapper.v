`timescale 1ns / 1ps
module garuda_hart_wrapper #(
    parameter [1:0] HART_ID = 2'b00
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [1:0]  hart_id_in,        // Optional external override port

    // Instruction Memory Interface
    output wire [63:0] imem_addr,
    output wire        imem_valid,
    input  wire        imem_ready,
    input  wire [31:0] imem_rdata,
    input  wire        imem_resp_valid,

    // Data Memory Interface
    output wire [63:0] dmem_addr,
    output wire        dmem_valid,
    output wire        dmem_wen,
    output wire [2:0]  dmem_funct3,
    output wire [63:0] dmem_wdata,
    input  wire        dmem_ready,
    input  wire [63:0] dmem_rdata,
    input  wire        dmem_resp_valid,
    input  wire        dmem_resp_ready_in,
    output wire        dmem_resp_ready,

    // Core Status
    output wire        core_halted,
    output wire [1:0]  effective_hart_id
);

    // Resolve hart ID: parameter takes default unless hart_id_in is explicitly driven
    assign effective_hart_id = (hart_id_in != 2'b00) ? hart_id_in : HART_ID;

    garuda_rv64i_core core_inst (
        .clk(clk),
        .rst_n(rst_n),
        .hart_id(effective_hart_id),
        .imem_addr(imem_addr),
        .imem_valid(imem_valid),
        .imem_ready(imem_ready),
        .imem_rdata(imem_rdata),
        .imem_resp_valid(imem_resp_valid),
        .dmem_addr(dmem_addr),
        .dmem_valid(dmem_valid),
        .dmem_wen(dmem_wen),
        .dmem_funct3(dmem_funct3),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_resp_valid(dmem_resp_valid),
        .dmem_resp_ready_in(dmem_resp_ready_in),
        .dmem_resp_ready(dmem_resp_ready),
        .core_halted(core_halted)
    );

endmodule
