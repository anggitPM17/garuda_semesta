`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — Response Router (Zero Crosstalk Ownership Steering)
module garuda_response_router (
    input  wire        shared_resp_valid,
    input  wire [63:0] shared_resp_rdata,
    input  wire [1:0]  owner_id,

    // Gated responses to 4 harts
    output wire [3:0]  hart_resp_valid,
    output wire [63:0] hart0_rdata,
    output wire [63:0] hart1_rdata,
    output wire [63:0] hart2_rdata,
    output wire [63:0] hart3_rdata
);

    assign hart_resp_valid[0] = shared_resp_valid && (owner_id == 2'b00);
    assign hart_resp_valid[1] = shared_resp_valid && (owner_id == 2'b01);
    assign hart_resp_valid[2] = shared_resp_valid && (owner_id == 2'b10);
    assign hart_resp_valid[3] = shared_resp_valid && (owner_id == 2'b11);

    assign hart0_rdata = shared_resp_rdata;
    assign hart1_rdata = shared_resp_rdata;
    assign hart2_rdata = shared_resp_rdata;
    assign hart3_rdata = shared_resp_rdata;

endmodule
