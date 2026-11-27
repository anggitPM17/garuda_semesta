`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — 4-Core Memory Interconnect with CLINT & Mailbox Address Decoding
module garuda_memory_interconnect (
    input  wire        clk,
    input  wire        rst_n,

    // Hart 0..3 Request Ports
    input  wire [63:0] h0_addr, input wire h0_valid, input wire h0_wen, input wire [2:0] h0_funct3, input wire [63:0] h0_wdata,
    input  wire [63:0] h1_addr, input wire h1_valid, input wire h1_wen, input wire [2:0] h1_funct3, input wire [63:0] h1_wdata,
    input  wire [63:0] h2_addr, input wire h2_valid, input wire h2_wen, input wire [2:0] h2_funct3, input wire [63:0] h2_wdata,
    input  wire [63:0] h3_addr, input wire h3_valid, input wire h3_wen, input wire [2:0] h3_funct3, input wire [63:0] h3_wdata,

    // Hart 0..3 Readiness outputs
    output wire        h0_ready, output wire [63:0] h0_rdata, output wire h0_resp_valid,
    output wire        h1_ready, output wire [63:0] h1_rdata, output wire h1_resp_valid,
    output wire        h2_ready, output wire [63:0] h2_rdata, output wire h2_resp_valid,
    output wire        h3_ready, output wire [63:0] h3_rdata, output wire h3_resp_valid,

    // Shared RAM Subsystem Interface
    output reg  [63:0] ram_addr,
    output reg         ram_valid,
    output reg         ram_wen,
    output reg  [2:0]  ram_funct3,
    output reg  [63:0] ram_wdata,
    input  wire        ram_ready,
    input  wire [63:0] ram_rdata,
    input  wire        ram_resp_valid,

    // CLINT Subsystem Interface
    output reg  [63:0] clint_addr,
    output reg         clint_valid,
    output reg         clint_wen,
    output reg  [2:0]  clint_funct3,
    output reg  [63:0] clint_wdata,
    input  wire        clint_ready,
    input  wire [63:0] clint_rdata,
    input  wire        clint_resp_valid,

    // Mailbox Subsystem Interface
    output reg  [63:0] mbox_addr,
    output reg         mbox_valid,
    output reg         mbox_wen,
    output reg  [2:0]  mbox_funct3,
    output reg  [63:0] mbox_wdata,
    input  wire        mbox_ready,
    input  wire [63:0] mbox_rdata,
    input  wire        mbox_resp_valid
);

    wire [3:0] req = {h3_valid, h2_valid, h1_valid, h0_valid};
    wire [3:0] grant;
    wire [1:0] owner_id;

    // Selected raw request from arbiter owner
    reg  [63:0] sel_addr;
    reg         sel_valid;
    reg         sel_wen;
    reg  [2:0]  sel_funct3;
    reg  [63:0] sel_wdata;

    // Address decoding signals
    wire is_clint = (sel_addr[19:16] == 4'h2); // 0x0002_0000 - 0x0002_FFFF
    wire is_mbox  = (sel_addr[19:16] == 4'h0 && sel_addr[15:12] == 4'h2); // 0x0000_2000 - 0x0000_20FF

    wire selected_ready = is_clint ? clint_ready :
                          is_mbox  ? mbox_ready  : ram_ready;

    wire [3:0] transaction_done = {
        ((is_clint ? clint_resp_valid : is_mbox ? mbox_resp_valid : ram_resp_valid)) && (owner_id == 2'b11),
        ((is_clint ? clint_resp_valid : is_mbox ? mbox_resp_valid : ram_resp_valid)) && (owner_id == 2'b10),
        ((is_clint ? clint_resp_valid : is_mbox ? mbox_resp_valid : ram_resp_valid)) && (owner_id == 2'b01),
        ((is_clint ? clint_resp_valid : is_mbox ? mbox_resp_valid : ram_resp_valid)) && (owner_id == 2'b00)
    };

    garuda_bus_arbiter arbiter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .transaction_done(transaction_done),
        .grant(grant),
        .owner_id(owner_id)
    );

    // Request multiplexer based on owner_id grant
    always @(*) begin
        case (owner_id)
            2'b00: begin
                sel_addr   = h0_addr;
                sel_valid  = h0_valid && grant[0];
                sel_wen    = h0_wen;
                sel_funct3 = h0_funct3;
                sel_wdata  = h0_wdata;
            end
            2'b01: begin
                sel_addr   = h1_addr;
                sel_valid  = h1_valid && grant[1];
                sel_wen    = h1_wen;
                sel_funct3 = h1_funct3;
                sel_wdata  = h1_wdata;
            end
            2'b10: begin
                sel_addr   = h2_addr;
                sel_valid  = h2_valid && grant[2];
                sel_wen    = h2_wen;
                sel_funct3 = h2_funct3;
                sel_wdata  = h2_wdata;
            end
            2'b11: begin
                sel_addr   = h3_addr;
                sel_valid  = h3_valid && grant[3];
                sel_wen    = h3_wen;
                sel_funct3 = h3_funct3;
                sel_wdata  = h3_wdata;
            end
            default: begin
                sel_addr   = 64'd0;
                sel_valid  = 1'b0;
                sel_wen    = 1'b0;
                sel_funct3 = 3'b0;
                sel_wdata  = 64'd0;
            end
        endcase
    end

    // Subsystem demuxing
    always @(*) begin
        ram_addr   = sel_addr;
        ram_valid  = sel_valid && !is_clint && !is_mbox;
        ram_wen    = sel_wen;
        ram_funct3 = sel_funct3;
        ram_wdata  = sel_wdata;

        clint_addr   = sel_addr;
        clint_valid  = sel_valid && is_clint;
        clint_wen    = sel_wen;
        clint_funct3 = sel_funct3;
        clint_wdata  = sel_wdata;

        mbox_addr   = sel_addr;
        mbox_valid  = sel_valid && is_mbox;
        mbox_wen    = sel_wen;
        mbox_funct3 = sel_funct3;
        mbox_wdata  = sel_wdata;
    end

    // Hart readiness assignment
    assign h0_ready = selected_ready && grant[0];
    assign h1_ready = selected_ready && grant[1];
    assign h2_ready = selected_ready && grant[2];
    assign h3_ready = selected_ready && grant[3];

    // Response routing
    wire        shared_resp_valid = is_clint ? clint_resp_valid : is_mbox ? mbox_resp_valid : ram_resp_valid;
    wire [63:0] shared_resp_rdata = is_clint ? clint_rdata      : is_mbox ? mbox_rdata      : ram_rdata;

    wire [3:0] hart_resp_valid;
    garuda_response_router router_inst (
        .shared_resp_valid(shared_resp_valid),
        .shared_resp_rdata(shared_resp_rdata),
        .owner_id(owner_id),
        .hart_resp_valid(hart_resp_valid),
        .hart0_rdata(h0_rdata),
        .hart1_rdata(h1_rdata),
        .hart2_rdata(h2_rdata),
        .hart3_rdata(h3_rdata)
    );

    assign h0_resp_valid = hart_resp_valid[0];
    assign h1_resp_valid = hart_resp_valid[1];
    assign h2_resp_valid = hart_resp_valid[2];
    assign h3_resp_valid = hart_resp_valid[3];

endmodule
