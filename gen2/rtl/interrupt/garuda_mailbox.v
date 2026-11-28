`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — Hardware Mailbox & Atomic Mutex Lock Module
module garuda_mailbox (
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
    output reg         resp_valid
);

    reg [63:0] mailbox_regs [0:3]; // Mailbox message registers for Hart 0..3
    reg [3:0]  lock_regs;          // Atomic mutex lock registers (0 = free, 1 = locked)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mailbox_regs[0] <= 64'd0;
            mailbox_regs[1] <= 64'd0;
            mailbox_regs[2] <= 64'd0;
            mailbox_regs[3] <= 64'd0;
            lock_regs       <= 4'b0000;
            ready           <= 1'b1;
            rdata           <= 64'd0;
            resp_valid      <= 1'b0;
        end else begin
            resp_valid <= 1'b0;
            ready <= 1'b1;

            if (valid) begin
                resp_valid <= 1'b1;
                if (wen) begin
                    // Write requests
                    case (addr[3:0])
                        4'h0: mailbox_regs[0] <= wdata;
                        4'h8: mailbox_regs[1] <= wdata;
                        4'hC: mailbox_regs[2] <= wdata;
                        4'hE: mailbox_regs[3] <= wdata;
                        4'h4: begin
                            // Lock register write (0 = release, 1 = acquire)
                            if (wdata[0] == 1'b0)
                                lock_regs[addr[5:4]] <= 1'b0;
                            else
                                lock_regs[addr[5:4]] <= 1'b1;
                        end
                        default: ;
                    endcase
                end else begin
                    // Read requests (Atomic Read-To-Acquire for locks)
                    case (addr[3:0])
                        4'h0: rdata <= mailbox_regs[0];
                        4'h8: rdata <= mailbox_regs[1];
                        4'hC: rdata <= mailbox_regs[2];
                        4'hE: rdata <= mailbox_regs[3];
                        4'h4: begin
                            // Read lock: returns current state and atomically sets to locked (1)
                            rdata                <= {63'd0, lock_regs[addr[5:4]]};
                            lock_regs[addr[5:4]] <= 1'b1;
                        end
                        default: rdata <= 64'd0;
                    endcase
                end
            end
        end
    end

endmodule
