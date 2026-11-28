`timescale 1ns / 1ps
// GARUDA SEMESTA GEN3 — Heterogeneous System-on-Chip (4-Core CPU + GPU + Crypto + Framebuffer)
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

    // Gen3 VPU / GPU Instance
    garuda_vpu_top gpu_inst (
        .clk(clk),
        .rst_n(rst_n),
        .v_valid(1'b0),
        .vop(3'b000),
        .vmask(4'b1111),
        .vs1_addr(4'd1),
        .vs2_addr(4'd2),
        .vd_addr(4'd3),
        .v_ready(),
        .v_done(gpu_done_out)
    );

    // Crypto Security Engine Instance
    garuda_crypto_engine crypto_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(64'd0),
        .valid(1'b0),
        .wen(1'b0),
        .funct3(3'b000),
        .wdata(64'd0),
        .ready(),
        .rdata(),
        .resp_valid(),
        .crypto_done_irq(crypto_irq_out)
    );

    // Framebuffer Display Controller Instance
    garuda_framebuffer_controller fb_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(64'd0),
        .valid(1'b0),
        .wen(1'b0),
        .wdata(64'd0),
        .ready(),
        .rdata(),
        .resp_valid(),
        .hsync(hsync_out),
        .vsync(vsync_out),
        .rgb_out(rgb_out),
        .video_active()
    );

endmodule
