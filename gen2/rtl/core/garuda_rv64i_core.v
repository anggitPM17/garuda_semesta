`timescale 1ns / 1ps
module garuda_rv64i_core (
    input  wire        clk,
    input  wire        rst_n,

    // Instruction Memory Interface (with ready/valid handshake)
    output wire [63:0] imem_addr,
    output wire        imem_valid,
    input  wire        imem_ready,
    input  wire [31:0] imem_rdata,
    input  wire        imem_resp_valid,

    // Data Memory Interface (with ready/valid handshake)
    output wire [63:0] dmem_addr,
    output wire        dmem_valid,
    output wire        dmem_wen,
    output wire [2:0]  dmem_funct3,
    output wire [63:0] dmem_wdata,
    input  wire        dmem_ready,
    input  wire [63:0] dmem_rdata,
    input  wire        dmem_resp_valid,

    // Core Status (Halt / Ebreak detected)
    output reg         core_halted
);

    // PC and IF Stage
    reg  [63:0] pc;
    wire [63:0] next_pc;
    wire        branch_taken_ex;
    wire [63:0] branch_target_ex;

    // Memory handshake stall signals
    wire        imem_stall = imem_valid && (!imem_ready || !imem_resp_valid);
    wire        dmem_stall = ((ex_mem_mem_read || ex_mem_mem_write) && (!dmem_ready || !dmem_resp_valid));

    // Hazard Unit Wires
    wire        stall_hazard;
    wire        flush_pipeline;
    wire        stall_core = imem_stall || dmem_stall || stall_hazard;

    assign next_pc    = branch_taken_ex ? branch_target_ex : (pc + 4);
    assign imem_addr  = pc;
    assign imem_valid = rst_n && !core_halted;

    // IF/ID Pipeline Wires
    wire [63:0] if_id_pc;
    wire [31:0] if_id_inst;
    wire        if_id_is_ebreak;

    // ID Stage Wires
    wire [6:0]  id_opcode;
    wire [4:0]  id_rd, id_rs1, id_rs2;
    wire [2:0]  id_funct3;
    wire [6:0]  id_funct7;
    wire [63:0] id_imm;
    wire [3:0]  id_alu_op;
    wire        id_alu_src, id_reg_write, id_mem_read, id_mem_write, id_branch, id_jump, id_mem_to_reg, id_is_lui, id_is_auipc, id_is_jalr;

    wire [63:0] rs1_data_raw, rs2_data_raw;

    // Forwarding Wires
    wire [1:0]  forward_a, forward_b;

    // ID/EX Pipeline Wires
    wire [63:0] id_ex_pc, id_ex_rs1_val, id_ex_rs2_val, id_ex_imm;
    wire [4:0]  id_ex_rs1, id_ex_rs2, id_ex_rd;
    wire [3:0]  id_ex_alu_op;
    wire        id_ex_alu_src, id_ex_reg_write, id_ex_mem_read, id_ex_mem_write, id_ex_is_ebreak;

    reg         id_ex_branch, id_ex_jump, id_ex_mem_to_reg, id_ex_is_auipc, id_ex_is_jalr;
    reg  [2:0]  id_ex_funct3;

    // EX Stage Wires
    reg  [63:0] alu_operand_a, alu_operand_b;
    wire [63:0] alu_result_ex;
    wire        alu_zero_ex;
    wire [63:0] ex_mem_alu_in;

    // EX/MEM Pipeline Wires
    wire [63:0] ex_mem_alu_result, ex_mem_rs2_val;
    wire [4:0]  ex_mem_rd;
    wire        ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write, ex_mem_is_ebreak;
    reg         ex_mem_mem_to_reg;
    reg  [2:0]  ex_mem_funct3;

    // MEM Stage Wires
    wire [63:0] mem_load_data;
    wire        mem_misaligned;

    // MEM/WB Pipeline Wires
    wire [63:0] mem_wb_mem_data, mem_wb_alu_result;
    wire [4:0]  mem_wb_rd;
    wire        mem_wb_reg_write, mem_wb_mem_to_reg, mem_wb_is_ebreak;

    // WB Stage Wires
    wire [63:0] wb_data;
    wire        wb_write_en;

    // Forwarding Mux Wires
    wire [63:0] ex_rs1_forwarded = (forward_a == 2'b10) ? ex_mem_alu_result :
                                  (forward_a == 2'b01) ? wb_data : id_ex_rs1_val;
    wire [63:0] ex_rs2_forwarded = (forward_b == 2'b10) ? ex_mem_alu_result :
                                  (forward_b == 2'b01) ? wb_data : id_ex_rs2_val;

    // Branch and JALR Target Evaluation in EX
    reg branch_taken_calc;
    reg [63:0] target_pc_calc;
    always @(*) begin
        branch_taken_calc = 1'b0;
        target_pc_calc = id_ex_pc + 4;

        if (id_ex_branch) begin
            case (id_ex_funct3)
                3'b000: branch_taken_calc = (ex_rs1_forwarded == ex_rs2_forwarded); // BEQ
                3'b001: branch_taken_calc = (ex_rs1_forwarded != ex_rs2_forwarded); // BNE
                3'b100: branch_taken_calc = ($signed(ex_rs1_forwarded) < $signed(ex_rs2_forwarded)); // BLT
                3'b101: branch_taken_calc = ($signed(ex_rs1_forwarded) >= $signed(ex_rs2_forwarded)); // BGE
                3'b110: branch_taken_calc = (ex_rs1_forwarded < ex_rs2_forwarded); // BLTU
                3'b111: branch_taken_calc = (ex_rs1_forwarded >= ex_rs2_forwarded); // BGEU
                default: branch_taken_calc = 1'b0;
            endcase
            if (branch_taken_calc)
                target_pc_calc = id_ex_pc + id_ex_imm;
        end else if (id_ex_jump) begin
            branch_taken_calc = 1'b1;
            if (id_ex_is_jalr)
                target_pc_calc = (ex_rs1_forwarded + id_ex_imm) & ~64'd1; // JALR target: (rs1 + imm) & ~1
            else
                target_pc_calc = id_ex_pc + id_ex_imm; // JAL target
        end
    end

    assign branch_taken_ex  = branch_taken_calc;
    assign branch_target_ex = target_pc_calc;
    assign flush_pipeline   = branch_taken_ex;

    // PC Update Logic and EBREAK WB Halt
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc          <= 64'd0;
            core_halted <= 1'b0;
        end else begin
            if (mem_wb_is_ebreak) begin
                core_halted <= 1'b1;
            end
            if (!core_halted && !stall_core) begin
                pc <= next_pc;
            end
        end
    end

    // IF/ID Register
    rv64i_if_id_reg if_id_reg (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_core),
        .flush(flush_pipeline || core_halted),
        .pc_in(pc),
        .inst_in(imem_rdata),
        .pc_out(if_id_pc),
        .inst_out(if_id_inst),
        .is_ebreak_out(if_id_is_ebreak)
    );

    // ID Stage: Decoder & Register File
    rv64i_decode decode_inst (
        .inst(if_id_inst),
        .opcode(id_opcode),
        .rd(id_rd),
        .funct3(id_funct3),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .funct7(id_funct7),
        .imm(id_imm),
        .alu_op(id_alu_op),
        .alu_src(id_alu_src),
        .reg_write(id_reg_write),
        .mem_read(id_mem_read),
        .mem_write(id_mem_write),
        .branch(id_branch),
        .jump(id_jump),
        .mem_to_reg(id_mem_to_reg),
        .is_lui(id_is_lui),
        .is_auipc(id_is_auipc),
        .is_jalr(id_is_jalr)
    );

    rv64i_regfile regfile_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(id_rs1),
        .rs1_data(rs1_data_raw),
        .rs2_addr(id_rs2),
        .rs2_data(rs2_data_raw),
        .rd_addr(mem_wb_rd),
        .rd_data(wb_data),
        .rd_write_en(wb_write_en)
    );

    // Hazard Unit
    rv64i_hazard_unit hazard_inst (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(id_rs1),
        .if_id_rs2(id_rs2),
        .branch_taken(branch_taken_ex),
        .stall(stall_hazard),
        .flush(),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2)
    );

    // ID/EX Register: Stall ONLY on memory stalls; Flush on load-use hazard stall or branch taken!
    rv64i_id_ex_reg id_ex_reg (
        .clk(clk),
        .rst_n(rst_n),
        .stall(imem_stall || dmem_stall),
        .flush(flush_pipeline || stall_hazard || core_halted),
        .is_ebreak_in(if_id_is_ebreak),
        .pc_in(if_id_pc),
        .rs1_val_in(rs1_data_raw),
        .rs2_val_in(rs2_data_raw),
        .imm_in(id_imm),
        .rs1_in(id_rs1),
        .rs2_in(id_rs2),
        .rd_in(id_rd),
        .alu_op_in(id_alu_op),
        .alu_src_in(id_alu_src),
        .reg_write_in(id_reg_write && !flush_pipeline && !stall_hazard),
        .mem_read_in(id_mem_read && !flush_pipeline && !stall_hazard),
        .mem_write_in(id_mem_write && !flush_pipeline && !stall_hazard),
        .is_ebreak_out(id_ex_is_ebreak),
        .pc_out(id_ex_pc),
        .rs1_val_out(id_ex_rs1_val),
        .rs2_val_out(id_ex_rs2_val),
        .imm_out(id_ex_imm),
        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),
        .alu_op_out(id_ex_alu_op),
        .alu_src_out(id_ex_alu_src),
        .reg_write_out(id_ex_reg_write),
        .mem_read_out(id_ex_mem_read),
        .mem_write_out(id_ex_mem_write)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush_pipeline || stall_hazard || core_halted) begin
            id_ex_branch     <= 1'b0;
            id_ex_jump       <= 1'b0;
            id_ex_mem_to_reg <= 1'b0;
            id_ex_is_auipc   <= 1'b0;
            id_ex_is_jalr    <= 1'b0;
            id_ex_funct3     <= 3'b0;
        end else if (!imem_stall && !dmem_stall) begin
            id_ex_branch     <= id_branch;
            id_ex_jump       <= id_jump;
            id_ex_mem_to_reg <= id_mem_to_reg;
            id_ex_is_auipc   <= id_is_auipc;
            id_ex_is_jalr    <= id_is_jalr;
            id_ex_funct3     <= id_funct3;
        end
    end

    // EX Stage: ALU & Forwarding Muxes
    always @(*) begin
        case (forward_a)
            2'b00: alu_operand_a = id_ex_rs1_val;
            2'b10: alu_operand_a = ex_mem_alu_result;
            2'b01: alu_operand_a = wb_data;
            default: alu_operand_a = id_ex_rs1_val;
        endcase

        case (forward_b)
            2'b00: alu_operand_b = id_ex_rs2_val;
            2'b10: alu_operand_b = ex_mem_alu_result;
            2'b01: alu_operand_b = wb_data;
            default: alu_operand_b = id_ex_rs2_val;
        endcase

        if (id_ex_is_auipc)
            alu_operand_a = id_ex_pc;

        if (id_ex_alu_src)
            alu_operand_b = id_ex_imm;
    end

    rv64i_alu alu_inst (
        .alu_op(id_ex_alu_op),
        .operand_a(alu_operand_a),
        .operand_b(alu_operand_b),
        .result(alu_result_ex),
        .zero_flag(alu_zero_ex)
    );

    assign ex_mem_alu_in = (id_ex_jump) ? (id_ex_pc + 4) : alu_result_ex;

    // EX/MEM Register
    rv64i_ex_mem_reg ex_mem_reg (
        .clk(clk),
        .rst_n(rst_n),
        .stall(dmem_stall),
        .flush(1'b0),
        .is_ebreak_in(id_ex_is_ebreak),
        .alu_result_in(ex_mem_alu_in),
        .rs2_val_in(ex_rs2_forwarded),
        .rd_in(id_ex_rd),
        .reg_write_in(id_ex_reg_write),
        .mem_read_in(id_ex_mem_read),
        .mem_write_in(id_ex_mem_write),
        .is_ebreak_out(ex_mem_is_ebreak),
        .alu_result_out(ex_mem_alu_result),
        .rs2_val_out(ex_mem_rs2_val),
        .rd_out(ex_mem_rd),
        .reg_write_out(ex_mem_reg_write),
        .mem_read_out(ex_mem_mem_read),
        .mem_write_out(ex_mem_mem_write)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_mem_mem_to_reg <= 1'b0;
            ex_mem_funct3     <= 3'b0;
        end else if (!dmem_stall) begin
            ex_mem_mem_to_reg <= id_ex_mem_to_reg;
            ex_mem_funct3     <= id_ex_funct3;
        end
    end

    // MEM Stage: Load-Store Unit & Data Memory Interface
    assign dmem_addr   = ex_mem_alu_result;
    assign dmem_valid  = (ex_mem_mem_read || ex_mem_mem_write) && rst_n;
    assign dmem_wen    = ex_mem_mem_write;
    assign dmem_funct3 = ex_mem_funct3;
    assign dmem_wdata  = ex_mem_rs2_val;

    rv64i_load_store_unit lsu_inst (
        .clk(clk),
        .rst_n(rst_n),
        .mem_read(ex_mem_mem_read),
        .mem_write(ex_mem_mem_write),
        .funct3(ex_mem_funct3),
        .addr(ex_mem_alu_result),
        .store_data(ex_mem_rs2_val),
        .load_data(mem_load_data),
        .misaligned(mem_misaligned),
        .mem_addr(),
        .mem_wen(),
        .mem_wdata(),
        .mem_rdata(dmem_rdata)
    );

    // MEM/WB Register
    rv64i_mem_wb_reg mem_wb_reg (
        .clk(clk),
        .rst_n(rst_n),
        .stall(dmem_stall),
        .flush(1'b0),
        .is_ebreak_in(ex_mem_is_ebreak),
        .mem_data_in(mem_load_data),
        .alu_result_in(ex_mem_alu_result),
        .rd_in(ex_mem_rd),
        .reg_write_in(ex_mem_reg_write),
        .mem_to_reg_in(ex_mem_mem_to_reg),
        .is_ebreak_out(mem_wb_is_ebreak),
        .mem_data_out(mem_wb_mem_data),
        .alu_result_out(mem_wb_alu_result),
        .rd_out(mem_wb_rd),
        .reg_write_out(mem_wb_reg_write),
        .mem_to_reg_out(mem_wb_mem_to_reg)
    );

    // WB Stage: Writeback Unit
    rv64i_writeback writeback_inst (
        .alu_result(mem_wb_alu_result),
        .mem_data(mem_wb_mem_data),
        .pc_plus_4(64'd0),
        .mem_to_reg(mem_wb_mem_to_reg),
        .is_jump(1'b0),
        .rd_addr(mem_wb_rd),
        .wb_data(wb_data),
        .wb_write_en(wb_write_en),
        .reg_write_in(mem_wb_reg_write)
    );

endmodule
