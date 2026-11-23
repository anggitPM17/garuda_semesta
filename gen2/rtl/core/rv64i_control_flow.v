`timescale 1ns / 1ps
module rv64i_control_flow (
    input  wire [63:0] pc_current,
    input  wire [63:0] rs1_val,
    input  wire [63:0] rs2_val,
    input  wire [63:0] imm,
    input  wire [2:0]  funct3,
    input  wire [6:0]  opcode,
    output reg         branch_taken,
    output reg [63:0]  target_pc
);
    always @(*) begin
        branch_taken = 1'b0;
        target_pc = pc_current + 4;

        case (opcode)
            7'b1100011: begin // Branch
                case (funct3)
                    3'b000: branch_taken = (rs1_val == rs2_val); // BEQ
                    3'b001: branch_taken = (rs1_val != rs2_val); // BNE
                    3'b100: branch_taken = ($signed(rs1_val) < $signed(rs2_val)); // BLT
                    3'b101: branch_taken = ($signed(rs1_val) >= $signed(rs2_val)); // BGE
                    3'b110: branch_taken = (rs1_val < rs2_val); // BLTU
                    3'b111: branch_taken = (rs1_val >= rs2_val); // BGEU
                    default: branch_taken = 1'b0;
                endcase
                if (branch_taken)
                    target_pc = pc_current + imm;
            end
            7'b1101111: begin // JAL
                branch_taken = 1'b1;
                target_pc = pc_current + imm;
            end
            7'b1100111: begin // JALR
                branch_taken = 1'b1;
                target_pc = (rs1_val + imm) & ~64'd1; // JALR target: (rs1 + imm) & ~1
            end
            default: begin
                branch_taken = 1'b0;
                target_pc = pc_current + 4;
            end
        endcase
    end
endmodule
