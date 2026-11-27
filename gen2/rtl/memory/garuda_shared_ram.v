`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — Shared Main RAM Subsystem
module garuda_shared_ram #(
    parameter integer LATENCY = 1
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire [63:0] addr,
    input  wire        valid,
    input  wire        wen,
    input  wire [2:0]  funct3,
    input  wire [63:0] wdata,
    output reg         ready,
    output reg [63:0] rdata,
    output reg         resp_valid
);

    reg [7:0] dmem [0:32767]; // 32KB shared RAM for multi-hart test programs
    reg [3:0] latency_counter;
    reg       busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            latency_counter <= 4'd0;
            busy            <= 1'b0;
            ready           <= 1'b1;
            rdata           <= 64'd0;
            resp_valid      <= 1'b0;
        end else begin
            resp_valid <= 1'b0;
            if (!busy) begin
                ready <= 1'b1;
                if (valid) begin
                    busy            <= 1'b1;
                    ready           <= 1'b0;
                    latency_counter <= (LATENCY == 0) ? 4'd0 : LATENCY[3:0];
                    if (LATENCY == 0) begin
                        // Zero latency atomic response
                        resp_valid <= 1'b1;
                        busy       <= 1'b0;
                        ready      <= 1'b1;
                        if (wen) begin
                            case (funct3[1:0])
                                2'b00: if (addr < 32768) dmem[addr] <= wdata[7:0];
                                2'b01: if (addr < 32767) begin dmem[addr] <= wdata[7:0]; dmem[addr+1] <= wdata[15:8]; end
                                2'b10: if (addr < 32765) begin dmem[addr] <= wdata[7:0]; dmem[addr+1] <= wdata[15:8]; dmem[addr+2] <= wdata[23:16]; dmem[addr+3] <= wdata[31:24]; end
                                2'b11: if (addr < 32761) begin
                                    dmem[addr]   <= wdata[7:0];   dmem[addr+1] <= wdata[15:8];
                                    dmem[addr+2] <= wdata[23:16]; dmem[addr+3] <= wdata[31:24];
                                    dmem[addr+4] <= wdata[39:32]; dmem[addr+5] <= wdata[47:40];
                                    dmem[addr+6] <= wdata[55:48]; dmem[addr+7] <= wdata[63:56];
                                end
                            endcase
                        end else begin
                            case (funct3[1:0])
                                2'b00: rdata <= {{56{dmem[addr][7]}}, dmem[addr]};
                                2'b01: rdata <= {{48{dmem[addr+1][7]}}, dmem[addr+1], dmem[addr]};
                                2'b10: rdata <= {{32{dmem[addr+3][7]}}, dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
                                2'b11: rdata <= {dmem[addr+7], dmem[addr+6], dmem[addr+5], dmem[addr+4], dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
                            endcase
                        end
                    end
                end
            end else begin
                // Multi-cycle latency counter
                if (latency_counter > 4'd1) begin
                    latency_counter <= latency_counter - 4'd1;
                end else begin
                    resp_valid <= 1'b1;
                    busy       <= 1'b0;
                    ready      <= 1'b1;
                    if (wen) begin
                        case (funct3[1:0])
                            2'b00: if (addr < 32768) dmem[addr] <= wdata[7:0];
                            2'b01: if (addr < 32767) begin dmem[addr] <= wdata[7:0]; dmem[addr+1] <= wdata[15:8]; end
                            2'b10: if (addr < 32765) begin dmem[addr] <= wdata[7:0]; dmem[addr+1] <= wdata[15:8]; dmem[addr+2] <= wdata[23:16]; dmem[addr+3] <= wdata[31:24]; end
                            2'b11: if (addr < 32761) begin
                                dmem[addr]   <= wdata[7:0];   dmem[addr+1] <= wdata[15:8];
                                dmem[addr+2] <= wdata[23:16]; dmem[addr+3] <= wdata[31:24];
                                dmem[addr+4] <= wdata[39:32]; dmem[addr+5] <= wdata[47:40];
                                dmem[addr+6] <= wdata[55:48]; dmem[addr+7] <= wdata[63:56];
                            end
                        endcase
                    end else begin
                        case (funct3[1:0])
                            2'b00: rdata <= {{56{dmem[addr][7]}}, dmem[addr]};
                            2'b01: rdata <= {{48{dmem[addr+1][7]}}, dmem[addr+1], dmem[addr]};
                            2'b10: rdata <= {{32{dmem[addr+3][7]}}, dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
                            2'b11: rdata <= {dmem[addr+7], dmem[addr+6], dmem[addr+5], dmem[addr+4], dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
                        endcase
                    end
                end
            end
        end
    end

    task load_hex(input string filename);
        $readmemh(filename, dmem);
    endtask

endmodule
