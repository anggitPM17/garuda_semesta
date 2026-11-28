`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — AMBA AXI4 Crossbar Interconnect (4 Masters, 3 Slaves)
module garuda_axi_crossbar (
    input  wire        clk,
    input  wire        rst_n,

    // Master 0..3 AXI4 Interfaces (Hart 0..3 simplified AXI4 master channels)
    // Write Address Channel (AW)
    input  wire [3:0]  s_awid,
    input  wire [63:0] s_awaddr,
    input  wire        s_awvalid,
    output reg  [3:0]  s_awready,

    // Write Data Channel (W)
    input  wire [63:0] s_wdata,
    input  wire [7:0]  s_wstrb,
    input  wire        s_wvalid,
    output reg  [3:0]  s_wready,

    // Write Response Channel (B)
    output reg  [3:0]  s_bid,
    output reg  [1:0]  s_bresp,
    output reg  [3:0]  s_bvalid,
    input  wire [3:0]  s_bready,

    // Read Address Channel (AR)
    input  wire [3:0]  s_arid,
    input  wire [63:0] s_araddr,
    input  wire        s_arvalid,
    output reg  [3:0]  s_arready,

    // Read Data Channel (R)
    output reg  [3:0]  s_rid,
    output reg  [63:0] s_rdata,
    output reg  [1:0]  s_rresp,
    output reg  [3:0]  s_rvalid,
    input  wire [3:0]  s_rready,

    // Slave Outputs (RAM, CLINT, Mailbox)
    output reg  [63:0] m_addr,
    output reg        m_valid,
    output reg        m_wen,
    output reg  [63:0] m_wdata,
    input  wire       m_ready,
    input  wire [63:0] m_rdata,
    input  wire       m_resp_valid,
    output reg  [1:0] m_target_slave // 00=RAM, 01=CLINT, 10=Mailbox
);

    // Simple round-robin master arbitration for AXI crossbar
    reg [1:0] current_master;
    reg       bus_busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_master <= 2'd0;
            bus_busy       <= 1'b0;
            s_awready      <= 4'b0000;
            s_wready       <= 4'b0000;
            s_arready      <= 4'b0000;
            s_bvalid       <= 4'b0000;
            s_rvalid       <= 4'b0000;
            m_valid        <= 1'b0;
        end else begin
            // Default ready/valid management
            s_bvalid <= 4'b0000;
            s_rvalid <= 4'b0000;

            if (!bus_busy) begin
                if (s_arvalid[current_master] || s_awvalid[current_master]) begin
                    bus_busy <= 1'b1;
                    if (s_arvalid[current_master]) begin
                        m_addr     <= s_araddr;
                        m_valid    <= 1'b1;
                        m_wen      <= 1'b0;
                        s_arready[current_master] <= 1'b1;
                    end else if (s_awvalid[current_master]) begin
                        m_addr     <= s_awaddr;
                        m_valid    <= 1'b1;
                        m_wen      <= 1'b1;
                        m_wdata    <= s_wdata;
                        s_awready[current_master] <= 1'b1;
                        s_wready[current_master]  <= 1'b1;
                    end
                end else begin
                    current_master <= current_master + 2'd1;
                end
            end else begin
                s_arready <= 4'b0000;
                s_awready <= 4'b0000;
                s_wready  <= 4'b0000;
                if (m_resp_valid) begin
                    m_valid <= 1'b0;
                    bus_busy <= 1'b0;
                    if (m_wen) begin
                        s_bvalid[current_master] <= 1'b1;
                        s_bid[current_master]    <= current_master[3:0];
                    end else begin
                        s_rvalid[current_master] <= 1'b1;
                        s_rid[current_master]    <= current_master[3:0];
                        s_rdata                  <= m_rdata;
                    end
                    current_master <= current_master + 2'd1;
                end
            end
        end
    end

endmodule
