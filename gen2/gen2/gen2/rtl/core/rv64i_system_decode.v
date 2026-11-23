`timescale 1ns / 1ps
module rv64i_system_decode (
    input  wire [31:0] inst,
    output reg         is_ecall,
    output reg         is_ebreak,
    output reg         is_mret,
    output reg         is_fence
);
    always @(*) begin
        is_ecall  = (inst == 32'h00000073);
        is_ebreak = (inst == 32'h00100073);
        is_mret   = (inst == 32'h30200073);
        is_fence  = (inst[6:0] == 7'b0001111);
    end
endmodule
