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
    input  wire        dmem_resp_ready, // Explicit response consumption from core

    // Verification Scoreboard Counters
    output reg [31:0]  read_tx_count,
    output reg [31:0]  write_tx_count,
    output reg [31:0]  committed_store_count,
    output reg [31:0]  resp_tx_count,
    output reg [31:0]  duplicate_tx_count
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
    localparam STATE_WAIT     = 2'b01;
    localparam STATE_RESPONSE = 2'b10;

    reg [1:0]  dmem_state;
    reg [3:0]  dmem_timer;
    reg [63:0] pending_addr;
    reg        pending_wen;
    reg [2:0]  pending_funct3;
    reg [63:0] pending_wdata;

    // SINGLE DRIVER: Combinational Read Data & Ready
    always @(*) begin
        imem_ready      = 1'b1;
        imem_resp_valid = imem_valid; // Single driver for IMEM

        if (imem_addr[11:2] < 1024)
            imem_rdata = imem[imem_addr[11:2]];
        else
            imem_rdata = 32'h00000013;

        dmem_ready = (LATENCY == 0) ? 1'b1 : (dmem_state == STATE_IDLE);

        if (LATENCY == 0) begin
            dmem_resp_valid = dmem_valid;
            if (dmem_addr < 64'd16376) begin
                dmem_rdata = {
                    dmem[dmem_addr + 7], dmem[dmem_addr + 6], dmem[dmem_addr + 5], dmem[dmem_addr + 4],
                    dmem[dmem_addr + 3], dmem[dmem_addr + 2], dmem[dmem_addr + 1], dmem[dmem_addr]
                };
            end else begin
                dmem_rdata = 64'd0;
            end
        end else begin
            dmem_resp_valid = (dmem_state == STATE_RESPONSE);
            if (pending_addr < 64'd16376) begin
                dmem_rdata = {
                    dmem[pending_addr + 7], dmem[pending_addr + 6], dmem[pending_addr + 5], dmem[pending_addr + 4],
                    dmem[pending_addr + 3], dmem[pending_addr + 2], dmem[pending_addr + 1], dmem[pending_addr]
                };
            end else begin
                dmem_rdata = 64'd0;
            end
        end
    end

    // Sequential Transaction FSM and Single-Store Commit
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_state            <= STATE_IDLE;
            dmem_timer            <= 4'd0;
            read_tx_count         <= 32'd0;
            write_tx_count        <= 32'd0;
            committed_store_count <= 32'd0;
            resp_tx_count         <= 32'd0;
            duplicate_tx_count    <= 32'd0;
            pending_addr          <= 64'd0;
            pending_wen           <= 1'b0;
            pending_funct3        <= 3'b0;
            pending_wdata         <= 64'd0;
        end else begin
            if (LATENCY == 0) begin
                if (dmem_valid && dmem_ready && dmem_resp_ready) begin
                    resp_tx_count <= resp_tx_count + 1'b1;
                    if (dmem_wen) begin
                        write_tx_count        <= write_tx_count + 1'b1;
                        committed_store_count <= committed_store_count + 1'b1;
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
                // Multi-cycle LATENCY > 0 FSM
                case (dmem_state)
                    STATE_IDLE: begin
                        if (dmem_valid && dmem_ready) begin
                            // Capture pending request payload
                            pending_addr   <= dmem_addr;
                            pending_wen    <= dmem_wen;
                            pending_funct3 <= dmem_funct3;
                            pending_wdata  <= dmem_wdata;
                            dmem_timer     <= 4'd0;

                            if (dmem_wen)
                                write_tx_count <= write_tx_count + 1'b1;
                            else
                                read_tx_count  <= read_tx_count + 1'b1;

                            if (LATENCY == 1) begin
                                dmem_state <= STATE_RESPONSE;
                            end else begin
                                dmem_state <= STATE_WAIT;
                            end
                        end
                    end

                    STATE_WAIT: begin
                        if (dmem_timer >= LATENCY[3:0] - 2'd2) begin
                            dmem_state <= STATE_RESPONSE;
                        end else begin
                            dmem_timer <= dmem_timer + 1'b1;
                        end
                    end

                    STATE_RESPONSE: begin
                        // Complete transaction ONLY when core asserts dmem_resp_ready
                        if (dmem_resp_ready) begin
                            resp_tx_count <= resp_tx_count + 1'b1;
                            if (pending_wen) begin
                                committed_store_count <= committed_store_count + 1'b1;
                                case (pending_funct3[1:0])
                                    2'b00: if (pending_addr < 16384) dmem[pending_addr] <= pending_wdata[7:0];
                                    2'b01: if (pending_addr < 16383) begin
                                        dmem[pending_addr]     <= pending_wdata[7:0];
                                        dmem[pending_addr + 1] <= pending_wdata[15:8];
                                    end
                                    2'b10: if (pending_addr < 16381) begin
                                        dmem[pending_addr]     <= pending_wdata[7:0];
                                        dmem[pending_addr + 1] <= pending_wdata[15:8];
                                        dmem[pending_addr + 2] <= pending_wdata[23:16];
                                        dmem[pending_addr + 3] <= pending_wdata[31:24];
                                    end
                                    2'b11: if (pending_addr < 16376) begin
                                        dmem[pending_addr]     <= pending_wdata[7:0];
                                        dmem[pending_addr + 1] <= pending_wdata[15:8];
                                        dmem[pending_addr + 2] <= pending_wdata[23:16];
                                        dmem[pending_addr + 3] <= pending_wdata[31:24];
                                        dmem[pending_addr + 4] <= pending_wdata[39:32];
                                        dmem[pending_addr + 5] <= pending_wdata[47:40];
                                        dmem[pending_addr + 6] <= pending_wdata[55:48];
                                        dmem[pending_addr + 7] <= pending_wdata[63:56];
                                    end
                                endcase
                            end
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
