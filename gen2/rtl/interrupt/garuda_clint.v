`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — Core Local Interruptor (CLINT)
module garuda_clint (
    input  wire        clk,
    input  wire        rst_n,

    // MMIO Interface
    input  wire [63:0] addr,
    input  wire        valid,
    input  wire        wen,
    input  wire [2:0]  funct3,
    input  wire [63:0] wdata,
    output reg         ready,
    output reg  [63:0] rdata,
    output reg         resp_valid,

    // Interrupt Outputs to 4 Harts
    output reg  [3:0]  timer_interrupt,
    output reg  [3:0]  software_interrupt
);

    // CLINT Registers
    reg [63:0] mtime;
    reg [63:0] mtimecmp [0:3];
    reg [31:0] msip [0:3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mtime <= 64'd0;
            mtimecmp[0] <= 64'hFFFF_FFFF_FFFF_FFFF;
            mtimecmp[1] <= 64'hFFFF_FFFF_FFFF_FFFF;
            mtimecmp[2] <= 64'hFFFF_FFFF_FFFF_FFFF;
            mtimecmp[3] <= 64'hFFFF_FFFF_FFFF_FFFF;
            msip[0] <= 32'd0;
            msip[1] <= 32'd0;
            msip[2] <= 32'd0;
            msip[3] <= 32'd0;
            ready <= 1'b1;
            rdata <= 64'd0;
            resp_valid <= 1'b0;
        end else begin
            mtime <= mtime + 64'd1; // Increment system timer every cycle
            resp_valid <= 1'b0;
            ready <= 1'b1;

            if (valid) begin
                resp_valid <= 1'b1;
                if (wen) begin
                    // Write requests
                    case (addr[15:0])
                        16'h0000: msip[0] <= wdata[31:0];
                        16'h0004: msip[1] <= wdata[31:0];
                        16'h0008: msip[2] <= wdata[31:0];
                        16'h000C: msip[3] <= wdata[31:0];

                        16'h4000: mtimecmp[0] <= wdata;
                        16'h4008: mtimecmp[1] <= wdata;
                        16'h4010: mtimecmp[2] <= wdata;
                        16'h4018: mtimecmp[3] <= wdata;

                        16'hBFF8: mtime <= wdata; // mtime write
                        default: ;
                    endcase
                end else begin
                    // Read requests
                    case (addr[15:0])
                        16'h0000: rdata <= {32'd0, msip[0]};
                        16'h0004: rdata <= {32'd0, msip[1]};
                        16'h0008: rdata <= {32'd0, msip[2]};
                        16'h000C: rdata <= {32'd0, msip[3]};

                        16'h4000: rdata <= mtimecmp[0];
                        16'h4008: rdata <= mtimecmp[1];
                        16'h4010: rdata <= mtimecmp[2];
                        16'h4018: rdata <= mtimecmp[3];

                        16'hBFF8: rdata <= mtime;
                        default: rdata <= 64'd0;
                    endcase
                end
            end

            // Interrupt generation logic
            timer_interrupt[0]    <= (mtime >= mtimecmp[0]);
            timer_interrupt[1]    <= (mtime >= mtimecmp[1]);
            timer_interrupt[2]    <= (mtime >= mtimecmp[2]);
            timer_interrupt[3]    <= (mtime >= mtimecmp[3]);

            software_interrupt[0] <= (msip[0][0] != 1'b0);
            software_interrupt[1] <= (msip[1][0] != 1'b0);
            software_interrupt[2] <= (msip[2][0] != 1'b0);
            software_interrupt[3] <= (msip[3][0] != 1'b0);
        end
    end

endmodule
