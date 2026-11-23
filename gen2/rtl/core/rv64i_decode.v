`timescale 1ns / 1ps
module rv64i_decode (
    input  wire [31:0] inst,
    output wire [6:0]  opcode,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [6:0]  funct7,
    output reg  [63:0] imm,
    output reg  [3:0]  alu_op,
    output reg         alu_src,
    output reg         reg_write,
    output reg         mem_read,
    output reg         mem_write,
    output reg         branch,
    output reg         jump,
    output reg         mem_to_reg,
    output reg         is_lui,
    output reg         is_auipc
);
    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    always @(*) begin
        // Immediate Generation
        case (opcode)
            7'b0010011, 7'b0000011, 7'b1100111: // I-type
                imm = {{52{inst[31]}}, inst[31:20]};
            7'b0100011: // S-type
                imm = {{52{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // B-type
                imm = {{51{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b0110111, 7'b0010111: // U-type
                imm = {{32{inst[31]}}, inst[31:12], 12'b0};
            7'b1101111: // J-type
                imm = {{43{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default:
                imm = 64'd0;
        endcase

        // Control Signals
        alu_op     = 4'h0;
        alu_src    = 1'b0;
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        mem_to_reg = 1'b0;
        is_lui     = 1'b0;
        is_auipc   = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_op = (funct7[5]) ? 4'h1 : 4'h0; // SUB : ADD
                    3'b111: alu_op = 4'h2; // AND
                    3'b110: alu_op = 4'h3; // OR
                    3'b100: alu_op = 4'h4; // XOR
                    3'b001: alu_op = 4'h5; // SLL
                    3'b101: alu_op = (funct7[5]) ? 4'h7 : 4'h6; // SRA : SRL
                    3'b010: alu_op = 4'h8; // SLT
                    3'b011: alu_op = 4'h9; // SLTU
                    default: alu_op = 4'h0;
                endcase
            end
            7'b0010011: begin // I-type arithmetic
                reg_write = 1'b1;
                alu_src   = 1'b1;
                case (funct3)
                    3'b000: alu_op = 4'h0; // ADDI
                    3'b111: alu_op = 4'h2; // ANDI
                    3'b110: alu_op = 4'h3; // ORI
                    3'b100: alu_op = 4'h4; // XORI
                    3'b001: alu_op = 4'h5; // SLLI
                    3'b101: alu_op = (funct7[5]) ? 4'h7 : 4'h6; // SRAI : SRLI
                    3'b010: alu_op = 4'h8; // SLTI
                    3'b011: alu_op = 4'h9; // SLTIU
                    default: alu_op = 4'h0;
                endcase
            end
            7'b0000011: begin // Load
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 4'h0; // ADD (base + imm)
            end
            7'b0100011: begin // Store
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 4'h0; // ADD (base + imm)
            end
            7'b1100011: begin // Branch
                branch = 1'b1;
                alu_op = 4'h1; // SUB for comparison
            end
            7'b0110111: begin // LUI
                reg_write = 1'b1;
                is_lui    = 1'b1;
                alu_op    = 4'hA; // Pass imm
            end
            7'b0010111: begin // AUIPC
                reg_write = 1'b1;
                is_auipc  = 1'b1;
                alu_op    = 4'h0; // PC + imm
            end
            7'b1101111: begin // JAL
                reg_write = 1'b1;
                jump      = 1'b1;
            end
            7'b1100111: begin // JALR
                reg_write = 1'b1;
                jump      = 1'b1;
            end
            default: ;
        endcase
    end
endmodule
