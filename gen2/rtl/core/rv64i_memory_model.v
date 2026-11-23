`timescale 1ns / 1ps
module rv64i_memory_model (
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

    // 32-bit Instruction Memory (1024 words = 4KB)
    reg [31:0] imem [0:1023];
    // 8-bit Data Memory (16KB)
    reg [7:0]  dmem [0:16383];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) imem[i] = 32'h00000013; // NOP
        for (i = 0; i < 16384; i = i + 1) dmem[i] = 8'h0;
    end

    // Combinational Instruction Memory Read (Zero-latency fetch)
    always @(*) begin
        imem_ready      = 1'b1;
        imem_resp_valid = 1'b1;
        if (imem_addr[11:2] < 1024)
            imem_rdata = imem[imem_addr[11:2]];
        else
            imem_rdata = 32'h00000013;
    end

    // Data Memory Read / Write (Synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready      <= 1'b1;
            dmem_rdata      <= 64'd0;
            dmem_resp_valid <= 1'b0;
        end else begin
            dmem_ready <= 1'b1;
            if (dmem_valid && dmem_ready) begin
                if (dmem_wen) begin
                    case (dmem_funct3[1:0])
                        2'b00: begin // SB
                            if (dmem_addr < 64'd16384)
                                dmem[dmem_addr] <= dmem_wdata[7:0];
                        end
                        2'b01: begin // SH
                            if (dmem_addr < 64'd16383) begin
                                dmem[dmem_addr]     <= dmem_wdata[7:0];
                                dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                            end
                        end
                        2'b10: begin // SW
                            if (dmem_addr < 64'd16381) begin
                                dmem[dmem_addr]     <= dmem_wdata[7:0];
                                dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                                dmem[dmem_addr + 2] <= dmem_wdata[23:16];
                                dmem[dmem_addr + 3] <= dmem_wdata[31:24];
                            end
                        end
                        2'b11: begin // SD
                            if (dmem_addr < 64'd16376) begin
                                dmem[dmem_addr]     <= dmem_wdata[7:0];
                                dmem[dmem_addr + 1] <= dmem_wdata[15:8];
                                dmem[dmem_addr + 2] <= dmem_wdata[23:16];
                                dmem[dmem_addr + 3] <= dmem_wdata[31:24];
                                dmem[dmem_addr + 4] <= dmem_wdata[39:32];
                                dmem[dmem_addr + 5] <= dmem_wdata[47:40];
                                dmem[dmem_addr + 6] <= dmem_wdata[55:48];
                                dmem[dmem_addr + 7] <= dmem_wdata[63:56];
                            end
                        end
                    endcase
                end else begin
                    if (dmem_addr < 64'd16376) begin
                        dmem_rdata <= {
                            dmem[dmem_addr + 7], dmem[dmem_addr + 6], dmem[dmem_addr + 5], dmem[dmem_addr + 4],
                            dmem[dmem_addr + 3], dmem[dmem_addr + 2], dmem[dmem_addr + 1], dmem[dmem_addr]
                        };
                    end else begin
                        dmem_rdata <= 64'd0;
                    end
                end
                dmem_resp_valid <= 1'b1;
            end else begin
                dmem_resp_valid <= 1'b0;
            end
        end
    end

    // Task to load hex into IMEM
    task load_hex(input string filename);
        $readmemh(filename, imem);
    endtask

endmodule
