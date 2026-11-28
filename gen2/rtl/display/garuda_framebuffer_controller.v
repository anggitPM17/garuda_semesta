`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — DMA Framebuffer & Video Timing Generator (VGA/HDMI RGB)
module garuda_framebuffer_controller (
    input  wire        clk,
    input  wire        rst_n,

    // MMIO Control Registers
    input  wire [63:0] addr,
    input  wire        valid,
    input  wire        wen,
    input  wire [63:0] wdata,
    output reg         ready,
    output reg  [63:0] rdata,
    output reg         resp_valid,

    // Video Output Signals
    output reg         hsync,
    output reg         vsync,
    output reg  [23:0] rgb_out,       // 24-bit RGB Color Output
    output reg         video_active
);

    reg [63:0] fb_base_addr; // Base address of framebuffer in Shared RAM
    reg        fb_enable;
    reg [9:0]  h_counter;    // Horizontal pixel counter (800 total)
    reg [9:0]  v_counter;    // Vertical line counter (525 total)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fb_base_addr <= 64'h8001_0000;
            fb_enable    <= 1'b0;
            h_counter    <= 10'd0;
            v_counter    <= 10'd0;
            hsync        <= 1'b1;
            vsync        <= 1'b1;
            rgb_out      <= 24'd0;
            video_active <= 1'b0;
            ready        <= 1'b1;
            rdata        <= 64'd0;
            resp_valid   <= 1'b0;
        end else begin
            resp_valid <= 1'b0;
            ready      <= 1'b1;

            if (valid) begin
                resp_valid <= 1'b1;
                if (wen) begin
                    case (addr[3:0])
                        4'h0: fb_base_addr <= wdata;
                        4'h8: fb_enable    <= wdata[0];
                        default: ;
                    endcase
                end else begin
                    case (addr[3:0])
                        4'h0: rdata <= fb_base_addr;
                        4'h8: rdata <= {63'd0, fb_enable};
                        default: rdata <= 64'd0;
                    endcase
                end
            end

            // Video timing counter (640x480 resolution @ 60Hz timing simulation)
            if (fb_enable) begin
                if (h_counter == 10'd799) begin
                    h_counter <= 10'd0;
                    if (v_counter == 10'd524)
                        v_counter <= 10'd0;
                    else
                        v_counter <= v_counter + 10'd1;
                end else begin
                    h_counter <= h_counter + 10'd1;
                end

                // Active display region (640x480)
                video_active <= (h_counter < 10'd640) && (v_counter < 10'd480);
                hsync        <= ~((h_counter >= 10'd656) && (h_counter < 10'd752));
                vsync        <= ~((v_counter >= 10'd490) && (v_counter < 10'd492));

                if ((h_counter < 10'd640) && (v_counter < 10'd480))
                    rgb_out <= {h_counter[7:0], v_counter[7:0], 8'hFF}; // Test color pattern
                else
                    rgb_out <= 24'd0;
            end
        end
    end

endmodule
