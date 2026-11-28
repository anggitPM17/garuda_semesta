`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — Vector Processing Unit (VPU) Top
module garuda_vpu_top (
    input  wire        clk,
    input  wire        rst_n,

    // Command / Instruction Interface from Host CPU
    input  wire        v_valid,
    input  wire [2:0]  vop,
    input  wire [3:0]  vs1_addr,
    input  wire [3:0]  vs2_addr,
    input  wire [3:0]  vd_addr,
    output wire        v_ready,
    output reg         v_done
);

    wire [127:0] rs1_data, rs2_data, v_alu_result;

    garuda_vector_register_file vrf_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(vs1_addr),
        .rs1_data(rs1_data),
        .rs2_addr(vs2_addr),
        .rs2_data(rs2_data),
        .rd_addr(vd_addr),
        .rd_data(v_alu_result),
        .rd_write_en(v_valid)
    );

    garuda_vector_alu valu_inst (
        .vop(vop),
        .v_op_a(rs1_data),
        .v_op_b(rs2_data),
        .v_result(v_alu_result)
    );

    assign v_ready = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_done <= 1'b0;
        end else begin
            v_done <= v_valid;
        end
    end

endmodule
