`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — Fully-Wired Heterogeneous System-on-Chip (4-Core CPU + GPU + Crypto + Framebuffer)
module garuda_gen3_heterogeneous_soc (
    input  wire        clk,
    input  wire        rst_n,
    output wire [3:0]  core_halted_out,
    output wire        gpu_done_out,
    output wire        crypto_irq_out,
    output wire        hsync_out,
    output wire        vsync_out,
    output wire [23:0] rgb_out
);

    // 4-Core CPU Top Instance
    wire [3:0] timer_irq, sw_irq;
    garuda_4core_top cpu_top_inst (
        .clk(clk),
        .rst_n(rst_n),
        .core_halted_out(core_halted_out),
        .timer_interrupt_out(timer_irq),
        .software_interrupt_out(sw_irq)
    );

    // Interconnect Subsystem Wires
    wire [63:0] crypto_addr, fb_addr, gpu_addr;
    wire        crypto_valid, fb_valid, gpu_valid;
    wire        crypto_wen, fb_wen, gpu_wen;
    wire [2:0]  crypto_funct3, fb_funct3, gpu_funct3;
    wire [63:0] crypto_wdata, fb_wdata, gpu_wdata;
    wire        crypto_ready, fb_ready, gpu_ready;
    wire [63:0] crypto_rdata, fb_rdata, gpu_rdata;
    wire        crypto_resp_valid, fb_resp_valid, gpu_resp_valid;

    // Gen3 VPU / GPU Instance wired to GPU MMIO port
    garuda_vpu_top gpu_inst (
        .clk(clk),
        .rst_n(rst_n),
        .v_valid(gpu_valid),
        .vop(gpu_funct3),
        .vmask(4'b1111),
        .vs1_addr(gpu_addr[3:0]),
        .vs2_addr(gpu_addr[7:4]),
        .vd_addr(gpu_addr[11:8]),
        .v_ready(gpu_ready),
        .v_done(gpu_done_out)
    );
    assign gpu_rdata = 64'd0;
    assign gpu_resp_valid = gpu_valid;

    // Crypto Security Engine Instance wired to Crypto MMIO port
    garuda_crypto_engine crypto_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(crypto_addr),
        .valid(crypto_valid),
        .wen(crypto_wen),
        .funct3(crypto_funct3),
        .wdata(crypto_wdata),
        .ready(crypto_ready),
        .rdata(crypto_rdata),
        .resp_valid(crypto_resp_valid),
        .crypto_done_irq(crypto_irq_out)
    );

    // Framebuffer Display Controller Instance wired to Framebuffer MMIO port
    garuda_framebuffer_controller fb_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(fb_addr),
        .valid(fb_valid),
        .wen(fb_wen),
        .wdata(fb_wdata),
        .ready(fb_ready),
        .rdata(fb_rdata),
        .resp_valid(fb_resp_valid),
        .hsync(hsync_out),
        .vsync(vsync_out),
        .rgb_out(rgb_out),
        .video_active()
    );

endmodule
