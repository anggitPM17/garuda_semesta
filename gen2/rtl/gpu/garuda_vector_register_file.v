`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — Vector Register File (VRF)
// 16 Vector Registers, each 128 bits wide (4 x 32-bit elements or 2 x 64-bit elements)
module garuda_vector_register_file (
    input  wire        clk,
    input  wire        rst_n,

    // Read Port 1
    input  wire [3:0]  rs1_addr,
    output wire [127:0] rs1_data,

    // Read Port 2
    input  wire [3:0]  rs2_addr,
    output wire [127:0] rs2_data,

    // Write Port
    input  wire [3:0]  rd_addr,
    input  wire [127:0] rd_data,
    input  wire        rd_write_en
);

    reg [127:0] vregs [0:15];
    integer i;

    assign rs1_data = vregs[rs1_addr];
    assign rs2_data = vregs[rs2_addr];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 16; i = i + 1) begin
                vregs[i] <= 128'd0;
            end
        end else if (rd_write_en && (rd_addr != 4'd0)) begin
            vregs[rd_addr] <= rd_data;
        end
    end

endmodule
