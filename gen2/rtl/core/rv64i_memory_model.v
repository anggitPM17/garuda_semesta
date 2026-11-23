`timescale 1ns / 1ps
module rv64i_memory_model #(
    parameter LATENCY = 0 // Configurable memory latency (0, 1, 3, 5 cycles)
)(
    input  wire        clk,
    input  wire        rst_n,

    // Instruction Memory Port (Read-Only)
    input  wire [63:0] imem_addr,
    input  wire        imem_valid,
    output reg         imem_ready,
    output reg [31:0]  imem_rdata,
    output reg         imem_resp_valid,

    // Data Memory Port (Read/Write)
    input  wire [63:0] dmem_addr,
    input  wire        dmem_valid,
    input  wire        dmem_wen,
    input  wire [2:0]  dmem_funct3,
    input  wire [63:0] dmem_wdata,
    output reg         dmem_ready,
    output reg [63:0]  dmem_rdata,
    output reg         dmem_resp_valid
);

    reg [31:0] imem [0:1023];
    reg [7:0]  dmem [0:16383];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) imem[i] = 32'h00000013; // NOP
        for (i = 0; i < 16384; i = i + 1) dmem[i] = 8'h0;
    end

    // Combinational Instruction Memory Read
    always @(*) begin
        imem_ready      = 1'b1;
        imem_resp_valid = 1'b1;
        if (imem_addr[11:2] < 1024)
            imem_rdata = imem[imem_addr[11:2]];
        else
            imem_rdata = 32'h00000013;
    end

    // Combinational Data Memory Read (Zero-latency load for SRAM model)
    always @(*) begin
        dmem_ready      = 1'b1;
        dmem_resp_valid = 1'b1;
        if (dmem_addr < 64'd16376) begin
            dmem_rdata = {
                dmem[dmem_addr + 7], dmem[dmem_addr + 6], dmem[dmem_addr + 5], dmem[dmem_addr + 4],
                dmem[dmem_addr + 3], dmem[dmem_addr + 2], dmem[dmem_addr + 1], dmem[dmem_addr]
            };
        end else begin
            dmem_rdata = 64'd0;
        end
    end

    // Synchronous Data Memory Write
    always @(posedge clk or negedge rst_n) begin
        if (rst_n && dmem_valid && dmem_wen) begin
            case (dmem_funct3[1:0])
                2'b00: if (dmem_addr < 16384) dmem[dmem_addr] <= dmem_wdata[7:0];
                2'b01: if (dmem_addr < 16383) begin
                    dmem[dmem_addr]     <= dmem_wdata[7:0];
                    dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                end
                2'b10: if (dmem_addr < 16381) begin
                    dmem[dmem_addr]     <= dmem_wdata[7:0];
                    dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                    dmem[dmem_addr + 2] <= dmem_wdata[23:16];
                    dmem[dmem_addr + 3] <= dmem_wdata[31:24];
                end
                2'b11: if (dmem_addr < 16376) begin
                    dmem[dmem_addr]     <= dmem_wdata[7:0];
                    dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                    dmem[dmem_addr + 2] <= dmem_wdata[23:16];
                    dmem[dmem_addr + 3] <= dmem_wdata[31:24];
                    dmem[dmem_addr + 4] <= dmem_wdata[39:32];
                    dmem[dmem_addr + 5] <= dmem_wdata[47:40];
                    dmem[dmem_addr + 6] <= dmem_wdata[55:48];
                    dmem[dmem_addr + 7] <= dmem_wdata[63:56];
                end
            endcase
        end
    end

    task load_hex(input string filename);
        $readmemh(filename, imem);
    endtask

endmodule
