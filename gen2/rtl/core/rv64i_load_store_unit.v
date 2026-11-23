`timescale 1ns / 1ps
module rv64i_load_store_unit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [2:0]  funct3,
    input  wire [63:0] addr,
    input  wire [63:0] store_data,
    output reg  [63:0] load_data,
    output wire        misaligned,
    output wire [63:0] mem_addr,
    output wire        mem_wen,
    output wire [63:0] mem_wdata,
    input  wire [63:0] mem_rdata
);
    assign mem_addr = addr;
    assign mem_wen  = mem_write;
    assign mem_wdata = store_data;

    // Misalignment check: halfword (addr[0]!=0), word (addr[1:0]!=0), doubleword (addr[2:0]!=0)
    assign misaligned = (funct3[1:0] == 2'b01 && addr[0] != 1'b0) ||
                        (funct3[1:0] == 2'b10 && addr[1:0] != 2'b0) ||
                        (funct3[1:0] == 2'b11 && addr[2:0] != 3'b0);

    always @(*) begin
        load_data = mem_rdata;
        if (mem_read) begin
            case (funct3)
                3'b000: // LB
                    case (addr[2:0])
                        3'd0: load_data = {{56{mem_rdata[7]}}, mem_rdata[7:0]};
                        3'd1: load_data = {{56{mem_rdata[15]}}, mem_rdata[15:8]};
                        3'd2: load_data = {{56{mem_rdata[23]}}, mem_rdata[23:16]};
                        3'd3: load_data = {{56{mem_rdata[31]}}, mem_rdata[31:24]};
                        3'd4: load_data = {{56{mem_rdata[39]}}, mem_rdata[39:32]};
                        3'd5: load_data = {{56{mem_rdata[47]}}, mem_rdata[47:40]};
                        3'd6: load_data = {{56{mem_rdata[55]}}, mem_rdata[55:48]};
                        3'd7: load_data = {{56{mem_rdata[63]}}, mem_rdata[63:56]};
                    endcase
                3'b001: // LH
                    case (addr[2:1])
                        2'd0: load_data = {{48{mem_rdata[15]}}, mem_rdata[15:0]};
                        2'd1: load_data = {{48{mem_rdata[31]}}, mem_rdata[31:16]};
                        2'd2: load_data = {{48{mem_rdata[47]}}, mem_rdata[47:32]};
                        2'd3: load_data = {{48{mem_rdata[63]}}, mem_rdata[63:48]};
                    endcase
                3'b010: // LW
                    case (addr[2])
                        1'd0: load_data = {{32{mem_rdata[31]}}, mem_rdata[31:0]};
                        1'd1: load_data = {{32{mem_rdata[63]}}, mem_rdata[63:32]};
                    endcase
                3'b011: // LD
                    load_data = mem_rdata;
                3'b100: // LBU
                    case (addr[2:0])
                        3'd0: load_data = {56'd0, mem_rdata[7:0]};
                        3'd1: load_data = {56'd0, mem_rdata[15:8]};
                        3'd2: load_data = {56'd0, mem_rdata[23:16]};
                        3'd3: load_data = {56'd0, mem_rdata[31:24]};
                        3'd4: load_data = {56'd0, mem_rdata[39:32]};
                        3'd5: load_data = {56'd0, mem_rdata[47:40]};
                        3'd6: load_data = {56'd0, mem_rdata[55:48]};
                        3'd7: load_data = {56'd0, mem_rdata[63:56]};
                    endcase
                3'b101: // LHU
                    case (addr[2:1])
                        2'd0: load_data = {48'd0, mem_rdata[15:0]};
                        2'd1: load_data = {48'd0, mem_rdata[31:16]};
                        2'd2: load_data = {48'd0, mem_rdata[47:32]};
                        2'd3: load_data = {48'd0, mem_rdata[63:48]};
                    endcase
                3'b110: // LWU
                    case (addr[2])
                        1'd0: load_data = {32'd0, mem_rdata[31:0]};
                        1'd1: load_data = {32'd0, mem_rdata[63:32]};
                    endcase
                default: load_data = mem_rdata;
            endcase
        end
    end
endmodule
