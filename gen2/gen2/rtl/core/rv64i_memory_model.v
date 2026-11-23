`timescale 1ns / 1ps

`ifndef MEM_LATENCY
  `define MEM_LATENCY 0
`endif

module rv64i_memory_model (
    input  wire        clk,
    input  wire        rst_n,

    // Instruction Memory Port
    input  wire [63:0] imem_addr,
    input  wire        imem_valid,
    output reg         imem_ready,
    output reg [31:0]  imem_rdata,
    output reg         imem_resp_valid,

    // Data Memory Port
    input  wire [63:0] dmem_addr,
    input  wire        dmem_valid,
    input  wire        dmem_wen,
    input  wire [2:0]  dmem_funct3,
    input  wire [63:0] dmem_wdata,
    output reg         dmem_ready,
    output reg [63:0]  dmem_rdata,
    output reg         dmem_resp_valid,

    // Transaction Counters for Verification
    output reg [31:0]  read_tx_count,
    output reg [31:0]  write_tx_count
);

    localparam LATENCY = `MEM_LATENCY;

    reg [31:0] imem [0:1023];
    reg [7:0]  dmem [0:16383];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) imem[i] = 32'h00000013;
        for (i = 0; i < 16384; i = i + 1) dmem[i] = 8'h0;
    end

    // FSM States for Data Memory Transaction
    localparam STATE_IDLE     = 2'b00;
    localparam STATE_ACCEPT   = 2'b01;
    localparam STATE_WAIT     = 2'b10;
    localparam STATE_RESPONSE = 2'b11;

    reg [1:0] dmem_state;
    reg [3:0] dmem_counter;

    // Combinational Read Data & Ready
    always @(*) begin
        imem_ready = 1'b1;
        dmem_ready = (LATENCY == 0) ? 1'b1 : (dmem_state == STATE_IDLE);

        if (imem_addr[11:2] < 1024)
            imem_rdata = imem[imem_addr[11:2]];
        else
            imem_rdata = 32'h00000013;

        if (dmem_addr < 64'd16376) begin
            dmem_rdata = {
                dmem[dmem_addr + 7], dmem[dmem_addr + 6], dmem[dmem_addr + 5], dmem[dmem_addr + 4],
                dmem[dmem_addr + 3], dmem[dmem_addr + 2], dmem[dmem_addr + 1], dmem[dmem_addr]
            };
        end else begin
            dmem_rdata = 64'd0;
        end

        imem_resp_valid = imem_valid;
    end

    // Instruction Memory and Data Memory FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            imem_resp_valid <= 1'b0;
            dmem_resp_valid <= 1'b0;
            dmem_state      <= STATE_IDLE;
            dmem_counter    <= 4'd0;
            read_tx_count   <= 32'd0;
            write_tx_count  <= 32'd0;
        end else begin
            imem_resp_valid <= imem_valid;

            if (LATENCY == 0) begin
                dmem_resp_valid <= dmem_valid;
                if (dmem_valid) begin
                    if (dmem_wen) begin
                        write_tx_count <= write_tx_count + 1'b1;
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
                    end else begin
                        read_tx_count <= read_tx_count + 1'b1;
                    end
                end
            end else begin
                // Multi-cycle FSM for LATENCY > 0
                case (dmem_state)
                    STATE_IDLE: begin
                        dmem_resp_valid <= 1'b0;
                        if (dmem_valid) begin
                            dmem_state   <= STATE_WAIT;
                            dmem_counter <= 4'd0;
                            if (dmem_wen)
                                write_tx_count <= write_tx_count + 1'b1;
                            else
                                read_tx_count  <= read_tx_count + 1'b1;
                        end
                    end

                    STATE_WAIT: begin
                        if (dmem_counter >= LATENCY[3:0] - 1'b1) begin
                            dmem_state      <= STATE_RESPONSE;
                            dmem_resp_valid <= 1'b1;

                            if (dmem_wen) begin
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
                        end else begin
                            dmem_counter <= dmem_counter + 1'b1;
                        end
                    end

                    STATE_RESPONSE: begin
                        dmem_resp_valid <= 1'b0;
                        if (!dmem_valid) begin
                            dmem_state <= STATE_IDLE;
                        end
                    end

                    default: dmem_state <= STATE_IDLE;
                endcase
            end
        end
    end

    task load_hex(input string filename);
        $readmemh(filename, imem);
    endtask

endmodule
