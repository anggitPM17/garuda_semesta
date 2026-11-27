`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — 4-Core Memory Interconnect Top
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

    // Shared Memory Subsystem Interface
    output reg  [63:0] mem_addr,
    output reg         mem_valid,
    output reg         mem_wen,
    output reg  [2:0]  mem_funct3,
    output reg  [63:0] mem_wdata,
    input  wire        mem_ready,
    input  wire [63:0] mem_rdata,
    input  wire        mem_resp_valid
);

    wire [3:0] req = {h3_valid, h2_valid, h1_valid, h0_valid};
    wire [3:0] grant;
    wire [1:0] owner_id;

    wire [3:0] transaction_done = {
        mem_resp_valid && (owner_id == 2'b11),
        mem_resp_valid && (owner_id == 2'b10),
        mem_resp_valid && (owner_id == 2'b01),
        mem_resp_valid && (owner_id == 2'b00)
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
                mem_addr   = h0_addr;
                mem_valid  = h0_valid && grant[0];
                mem_wen    = h0_wen;
                mem_funct3 = h0_funct3;
                mem_wdata  = h0_wdata;
            end
            2'b01: begin
                mem_addr   = h1_addr;
                mem_valid  = h1_valid && grant[1];
                mem_wen    = h1_wen;
                mem_funct3 = h1_funct3;
                mem_wdata  = h1_wdata;
            end
            2'b10: begin
                mem_addr   = h2_addr;
                mem_valid  = h2_valid && grant[2];
                mem_wen    = h2_wen;
                mem_funct3 = h2_funct3;
                mem_wdata  = h2_wdata;
            end
            2'b11: begin
                mem_addr   = h3_addr;
                mem_valid  = h3_valid && grant[3];
                mem_wen    = h3_wen;
                mem_funct3 = h3_funct3;
                mem_wdata  = h3_wdata;
            end
            default: begin
                mem_addr   = 64'd0;
                mem_valid  = 1'b0;
                mem_wen    = 1'b0;
                mem_funct3 = 3'b0;
                mem_wdata  = 64'd0;
            end
        endcase
    end

    // Hart readiness assignment
    assign h0_ready = mem_ready && grant[0];
    assign h1_ready = mem_ready && grant[1];
    assign h2_ready = mem_ready && grant[2];
    assign h3_ready = mem_ready && grant[3];

    // Response routing
    wire [3:0] hart_resp_valid;
    garuda_response_router router_inst (
        .shared_resp_valid(mem_resp_valid),
        .shared_resp_rdata(mem_rdata),
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
