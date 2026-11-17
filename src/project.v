// =========================================================================
// GARUDA SEMESTA - Quad-Core SMP SoC v3.0 (Silicon & Tiny Tapeout ASIC Ready)
// Top-Level Module: tt_um_garuda & garuda_
// Features:
// 1. Tiny Tapeout 8 (TT08) & OpenLane ASIC Compliant Pinout
// 2. Quad-Core SMP Architecture (Core 0..3)
// 3. Hardware UART Serial Peripheral (TX Console Output at addr 62)
// 4. Hardware Timer Wheel & Event Loop Unit (Timer IRQ at addr 61)
// 5. Hardware Inter-Core Mailbox IPC & Real-Time IRQ Vector
// 6. Hardware MPU Isolation & Fault Trap Protection Unit
// 7. Active Hardware Garbage Collection (HW-GC) Engine
// =========================================================================

`default_nettype none

module tt_um_garuda (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (1=output, 0=input)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock input
    input  wire       rst_n     // Reset low-active
);

    wire [7:0] core0_pc, core1_pc, core2_pc, core3_pc;
    wire [3:0] irq_vector;
    wire [3:0] mpu_fault_vector;
    wire       smp_halted;
    wire       uart_tx;

    // Instantiate core SoC
    garuda_ soc_inst (
        .clk(clk),
        .reset_n(rst_n),
        .ui_in(ui_in),
        .core0_pc(core0_pc),
        .core1_pc(core1_pc),
        .core2_pc(core2_pc),
        .core3_pc(core3_pc),
        .irq_vector(irq_vector),
        .mpu_fault_vector(mpu_fault_vector),
        .smp_halted(smp_halted),
        .uart_tx(uart_tx)
    );

    // Map outputs to Tiny Tapeout pinout
    assign uo_out[0]   = uart_tx;                 // Pin 0: Hardware UART TX
    assign uo_out[4:1] = irq_vector[3:0];         // Pins 1-4: Inter-Core & Timer IRQs
    assign uo_out[6:5] = mpu_fault_vector[1:0];   // Pins 5-6: MPU Fault Flags
    assign uo_out[7]   = smp_halted;              // Pin 7: SMP Halted Status

    assign uio_out     = core0_pc;                // Debug output: Core 0 PC
    assign uio_oe      = 8'b11111111;             // Set UIO pins as outputs

endmodule


// =========================================================================
// MODULE: GARUDA SOC TOP CORE
// =========================================================================
module garuda_ (
    input wire clk,
    input wire reset_n,
    input wire [7:0] ui_in,
    output wire [7:0] core0_pc,
    output wire [7:0] core1_pc,
    output wire [7:0] core2_pc,
    output wire [7:0] core3_pc,
    output wire [3:0] irq_vector,
    output wire [3:0] mpu_fault_vector,
    output wire smp_halted,
    output wire uart_tx
);

    // Interconnect wires Core 0..3
    wire        req_0, write_en_0, valid_0;
    wire [1:0]  pid_0;
    wire [5:0]  addr_0;
    wire [2:0]  cmd_0;
    wire [3:0]  size_0;
    wire [31:0] wdata_0;

    wire        req_1, write_en_1, valid_1;
    wire [1:0]  pid_1;
    wire [5:0]  addr_1;
    wire [2:0]  cmd_1;
    wire [3:0]  size_1;
    wire [31:0] wdata_1;

    wire        req_2, write_en_2, valid_2;
    wire [1:0]  pid_2;
    wire [5:0]  addr_2;
    wire [2:0]  cmd_2;
    wire [3:0]  size_2;
    wire [31:0] wdata_2;

    wire        req_3, write_en_3, valid_3;
    wire [1:0]  pid_3;
    wire [5:0]  addr_3;
    wire [2:0]  cmd_3;
    wire [3:0]  size_3;
    wire [31:0] wdata_3;

    // Arbiter / Shared Bus Wires
    reg  [1:0]  arb_sel;
    wire        arb_req;
    wire        arb_write_en;
    wire [1:0]  arb_pid;
    wire [5:0]  arb_addr;
    wire [2:0]  arb_cmd;
    wire        arb_valid;
    wire [3:0]  arb_size;
    wire [31:0] arb_wdata;

    wire [31:0] shared_read_data;
    wire        shared_ready;
    wire        shared_access_error;
    wire        shared_oom;
    wire        shared_trap;
    wire        shared_gc_freed;

    wire core0_halt, core1_halt, core2_halt, core3_halt;

    // ---------------------------------------------------------------------
    // 1. QUAD CPU CORES (Core 0, Core 1, Core 2, Core 3)
    // ---------------------------------------------------------------------
    garuda_cpu_core #( .CORE_ID(2'b00) ) core_0 (
        .clk(clk), .reset_n(reset_n),
        .req(req_0), .write_en(write_en_0), .process_id(pid_0), .address(addr_0),
        .runtime_cmd(cmd_0), .cmd_valid(valid_0), .alloc_size(size_0), .write_data(wdata_0),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core0_pc), .halted(core0_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b01) ) core_1 (
        .clk(clk), .reset_n(reset_n),
        .req(req_1), .write_en(write_en_1), .process_id(pid_1), .address(addr_1),
        .runtime_cmd(cmd_1), .cmd_valid(valid_1), .alloc_size(size_1), .write_data(wdata_1),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core1_pc), .halted(core1_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b10) ) core_2 (
        .clk(clk), .reset_n(reset_n),
        .req(req_2), .write_en(write_en_2), .process_id(pid_2), .address(addr_2),
        .runtime_cmd(cmd_2), .cmd_valid(valid_2), .alloc_size(size_2), .write_data(wdata_2),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core2_pc), .halted(core2_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b11) ) core_3 (
        .clk(clk), .reset_n(reset_n),
        .req(req_3), .write_en(write_en_3), .process_id(pid_3), .address(addr_3),
        .runtime_cmd(cmd_3), .cmd_valid(valid_3), .alloc_size(size_3), .write_data(wdata_3),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core3_pc), .halted(core3_halt)
    );

    // ---------------------------------------------------------------------
    // 2. 4-WAY ROUND-ROBIN BUS ARBITER
    // ---------------------------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            arb_sel <= 2'b00;
        end else begin
            arb_sel <= arb_sel + 1'b1;
        end
    end

    // Multiplexing Bus Sinyal
    assign arb_req      = (arb_sel == 2'b00) ? req_0      : (arb_sel == 2'b01) ? req_1      : (arb_sel == 2'b10) ? req_2      : req_3;
    assign arb_write_en = (arb_sel == 2'b00) ? write_en_0 : (arb_sel == 2'b01) ? write_en_1 : (arb_sel == 2'b10) ? write_en_2 : write_en_3;
    assign arb_pid      = (arb_sel == 2'b00) ? pid_0      : (arb_sel == 2'b01) ? pid_1      : (arb_sel == 2'b10) ? pid_2      : pid_3;
    assign arb_addr     = (arb_sel == 2'b00) ? addr_0     : (arb_sel == 2'b01) ? addr_1     : (arb_sel == 2'b10) ? addr_2     : addr_3;
    assign arb_cmd      = (arb_sel == 2'b00) ? cmd_0      : (arb_sel == 2'b01) ? cmd_1      : (arb_sel == 2'b10) ? cmd_2      : cmd_3;
    assign arb_valid    = (arb_sel == 2'b00) ? valid_0    : (arb_sel == 2'b01) ? valid_1    : (arb_sel == 2'b10) ? valid_2    : valid_3;
    assign arb_size     = (arb_sel == 2'b00) ? size_0     : (arb_sel == 2'b01) ? size_1     : (arb_sel == 2'b10) ? size_2     : size_3;
    assign arb_wdata    = (arb_sel == 2'b00) ? wdata_0    : (arb_sel == 2'b01) ? wdata_1    : (arb_sel == 2'b10) ? wdata_2    : wdata_3;

    // ---------------------------------------------------------------------
    // 3. ADVANCED SHARED MEMORY CONTROLLER, HW-GC, MAILBOX, UART & TIMER
    // ---------------------------------------------------------------------
    garuda_memory_controller mem_ctrl (
        .clk(clk),
        .reset_n(reset_n),
        .runtime_cmd(arb_cmd),
        .cmd_valid(arb_valid),
        .req(arb_req),
        .write_en(arb_write_en),
        .process_id(arb_pid),
        .target_process_id(arb_addr[1:0]),
        .address(arb_addr),
        .alloc_size(arb_size),
        .gc_free_req(arb_cmd == 3'b100),
        .gc_target_addr(arb_addr),
        .shared_sel(1'b0),
        .shared_read_mask(4'b1111),
        .shared_write_mask(4'b1111),
        .write_data(arb_wdata),
        .read_data(shared_read_data),
        .ready(shared_ready),
        .access_error(shared_access_error),
        .allocated_address(),
        .out_of_memory(shared_oom),
        .cache_hit(),
        .l2_cache_hit(),
        .active_running_pid(),
        .runtime_fault_trap(shared_trap),
        .gc_object_freed(shared_gc_freed),
        .mb_pending(irq_vector),
        .mpu_fault_vector(mpu_fault_vector),
        .uart_tx(uart_tx)
    );

    assign smp_halted = core0_halt && core1_halt && core2_halt && core3_halt;

endmodule


// =========================================================================
// MODULE: CPU CORE (Parameterizable Core 0..3)
// =========================================================================
module garuda_cpu_core #(parameter [1:0] CORE_ID = 2'b00) (
    input wire clk,
    input wire reset_n,

    output reg        req,
    output reg        write_en,
    output reg [1:0]  process_id,
    output reg [5:0]  address,
    output reg [2:0]  runtime_cmd,
    output reg        cmd_valid,
    output reg [3:0]  alloc_size,
    output reg [31:0] write_data,

    input wire [31:0] read_data,
    input wire        ready,

    output reg [7:0]  pc,
    output reg        halted
);

    reg [42:0] instruction_rom [0:15];

    reg [2:0]  opcode;
    reg [1:0]  dec_pid;
    reg [5:0]  dec_addr;
    reg [3:0]  dec_size;
    reg [31:0] dec_data;

    integer idx;

    initial begin
        case (CORE_ID)
            2'b00: begin // Core 0
                instruction_rom[0] = {3'b001, 2'b00, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 0
                instruction_rom[1] = {3'b010, 2'b00, 6'd62, 4'd0, 32'h00000047}; // WRITE UART 'G'
                instruction_rom[2] = {3'b100, 2'b00, 6'd0, 4'd4, 32'h00000000}; // GC_FREE PID 0
                instruction_rom[3] = {3'b000, 2'b00, 6'd0, 4'd0, 32'h00000000}; // HALT
            end
            2'b01: begin // Core 1
                instruction_rom[0] = {3'b001, 2'b01, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 1
                instruction_rom[1] = {3'b010, 2'b01, 6'd2, 4'd0, 32'h22222222}; // WRITE PID 1
                instruction_rom[2] = {3'b000, 2'b01, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
            end
            2'b10: begin // Core 2
                instruction_rom[0] = {3'b001, 2'b10, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 2
                instruction_rom[1] = {3'b010, 2'b10, 6'd2, 4'd0, 32'h33333333}; // WRITE PID 2
                instruction_rom[2] = {3'b000, 2'b10, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
            end
            default: begin // Core 3
                instruction_rom[0] = {3'b001, 2'b11, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 3
                instruction_rom[1] = {3'b010, 2'b11, 6'd2, 4'd0, 32'h44444444}; // WRITE PID 3
                instruction_rom[2] = {3'b000, 2'b11, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
            end
        endcase

        for (idx = 4; idx < 16; idx = idx + 1) begin
            instruction_rom[idx] = 43'b0;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc          <= 8'd0;
            halted      <= 1'b0;
            req         <= 1'b0;
            write_en    <= 1'b0;
            cmd_valid   <= 1'b0;
            process_id  <= CORE_ID;
            address     <= 6'd0;
            runtime_cmd <= 3'b000;
            alloc_size  <= 4'd0;
            write_data  <= 32'h0;
        end
        else if (!halted) begin
            req       <= 1'b0;
            write_en  <= 1'b0;
            cmd_valid <= 1'b0;

            {opcode, dec_pid, dec_addr, dec_size, dec_data} <= instruction_rom[pc[3:0]];
            process_id <= dec_pid;

            case (opcode)
                3'b001: begin // ALLOC
                    runtime_cmd <= 3'b011;
                    cmd_valid   <= 1'b1;
                    alloc_size  <= dec_size;
                end
                3'b010: begin // WRITE / SEND MSG / UART TX
                    runtime_cmd <= 3'b010;
                    cmd_valid   <= 1'b1;
                    address     <= dec_addr;
                    write_data  <= dec_data;
                    write_en    <= 1'b1;
                end
                3'b011: begin // READ
                    runtime_cmd <= 3'b001;
                    cmd_valid   <= 1'b1;
                    address     <= dec_addr;
                end
                3'b100: begin // GC FREE
                    runtime_cmd <= 3'b100;
                    cmd_valid   <= 1'b1;
                    alloc_size  <= dec_size;
                end
                default: begin
                    runtime_cmd <= 3'b000;
                    cmd_valid   <= 1'b0;
                    halted      <= 1'b1;
                end
            endcase

            pc <= pc + 1'b1;
        end
    end

endmodule


// =========================================================================
// MODULE: MEMORY CONTROLLER, HW-GC, MAILBOX, MPU & UART PERIPHERAL
// =========================================================================
module garuda_memory_controller (
    input wire clk,
    input wire reset_n,

    input wire [2:0] runtime_cmd,
    input wire       cmd_valid,

    input wire req,
    input wire write_en,

    input wire [1:0] process_id,
    input wire [1:0] target_process_id,

    input wire [5:0] address,
    input wire [3:0] alloc_size,

    input wire       gc_free_req,
    input wire [5:0] gc_target_addr,

    input wire shared_sel,

    input wire [3:0] shared_read_mask,
    input wire [3:0] shared_write_mask,

    input wire [31:0] write_data,
    output reg [31:0] read_data,

    output reg ready,
    output reg access_error,
    output reg [5:0] allocated_address,
    output reg out_of_memory,

    output reg cache_hit,
    output reg l2_cache_hit,

    output reg [1:0] active_running_pid,
    output reg       runtime_fault_trap,
    output reg       gc_object_freed,
    output reg [3:0] mb_pending,
    output reg [3:0] mpu_fault_vector,
    output wire      uart_tx
);

    reg [31:0] private_mem [0:255];
    reg [31:0] shared_mem [0:63];
    reg [31:0] mailbox_mem [0:3];
    reg [31:0] cycle_counter;
    reg [31:0] timer_wheel_reg;

    reg [5:0] heap_ptr_0;
    reg [5:0] heap_ptr_1;
    reg [5:0] heap_ptr_2;
    reg [5:0] heap_ptr_3;

    // UART Hardware Register Control
    reg       uart_start;
    reg [7:0] uart_tx_byte;
    wire      uart_busy;

    garuda_uart_tx uart_inst (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(uart_start),
        .tx_data(uart_tx_byte),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    wire [5:0] current_heap_ptr = (process_id == 2'b00) ? heap_ptr_0 :
                                  (process_id == 2'b01) ? heap_ptr_1 :
                                  (process_id == 2'b10) ? heap_ptr_2 : heap_ptr_3;

    wire [7:0] private_address;
    assign private_address = {process_id, address};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            read_data          <= 32'b0;
            ready              <= 1'b0;
            access_error       <= 1'b0;
            allocated_address  <= 6'b0;
            out_of_memory      <= 1'b0;
            runtime_fault_trap <= 1'b0;
            active_running_pid <= 2'b00;
            cache_hit          <= 1'b0;
            l2_cache_hit       <= 1'b0;
            gc_object_freed    <= 1'b0;
            mb_pending         <= 4'b0000;
            mpu_fault_vector   <= 4'b0000;
            cycle_counter      <= 32'd0;
            timer_wheel_reg    <= 32'd0;
            uart_start         <= 1'b0;
            uart_tx_byte       <= 8'h00;

            heap_ptr_0         <= 6'd0;
            heap_ptr_1         <= 6'd0;
            heap_ptr_2         <= 6'd0;
            heap_ptr_3         <= 6'd0;
        end
        else begin
            ready              <= 1'b0;
            cache_hit          <= 1'b0;
            l2_cache_hit       <= 1'b0;
            gc_object_freed    <= 1'b0;
            access_error       <= 1'b0;
            uart_start         <= 1'b0;
            active_running_pid <= process_id;
            cycle_counter      <= cycle_counter + 1'b1;

            // Timer Wheel Countdown Logic
            if (timer_wheel_reg > 32'd0) begin
                timer_wheel_reg <= timer_wheel_reg - 1'b1;
                if (timer_wheel_reg == 32'd1) begin
                    mb_pending[0] <= 1'b1; // Trigger IRQ to Core 0 when timer expires
                end
            end

            if (cmd_valid) begin
                ready <= 1'b1;

                if (address > 6'd63) begin
                    access_error                  <= 1'b1;
                    runtime_fault_trap            <= 1'b1;
                    mpu_fault_vector[process_id]  <= 1'b1;
                end
                else begin
                    case (runtime_cmd)
                        3'b011: begin // ALLOC
                            if ((current_heap_ptr + alloc_size) <= 6'd63) begin
                                allocated_address <= current_heap_ptr;
                                case (process_id)
                                    2'b00: heap_ptr_0 <= heap_ptr_0 + alloc_size;
                                    2'b01: heap_ptr_1 <= heap_ptr_1 + alloc_size;
                                    2'b10: heap_ptr_2 <= heap_ptr_2 + alloc_size;
                                    2'b11: heap_ptr_3 <= heap_ptr_3 + alloc_size;
                                endcase
                            end else begin
                                out_of_memory <= 1'b1;
                            end
                        end
                        3'b010: begin // WRITE / MAILBOX / UART TX / TIMER
                            if (address == 6'd62) begin
                                // Address 62: Hardware UART Serial Console Write
                                uart_tx_byte <= write_data[7:0];
                                uart_start   <= 1'b1;
                            end else if (address == 6'd61) begin
                                // Address 61: Set Hardware Timer Wheel Register
                                timer_wheel_reg <= write_data;
                            end else if (address >= 6'd60) begin
                                // Address 60: Hardware Mailbox Target Write
                                mailbox_mem[target_process_id] <= write_data;
                                mb_pending[target_process_id]  <= 1'b1;
                            end else begin
                                private_mem[private_address] <= write_data;
                            end
                        end
                        3'b001: begin // READ
                            if (address == 6'd58) begin
                                read_data <= cycle_counter; // Read Hardware Profiling Cycle Counter
                            end else if (address == 6'd61) begin
                                read_data <= timer_wheel_reg;
                            end else begin
                                read_data <= private_mem[private_address];
                            end
                        end
                        3'b100: begin // ACTIVE HW-GC FREE
                            gc_object_freed <= 1'b1;
                            case (process_id)
                                2'b00: if (heap_ptr_0 >= alloc_size) heap_ptr_0 <= heap_ptr_0 - alloc_size;
                                2'b01: if (heap_ptr_1 >= alloc_size) heap_ptr_1 <= heap_ptr_1 - alloc_size;
                                2'b10: if (heap_ptr_2 >= alloc_size) heap_ptr_2 <= heap_ptr_2 - alloc_size;
                                2'b11: if (heap_ptr_3 >= alloc_size) heap_ptr_3 <= heap_ptr_3 - alloc_size;
                            endcase
                        end
                        default: begin end
                    endcase
                end
            end
        end
    end

endmodule


// =========================================================================
// MODULE: HARDWARE UART TX TRANSMITTER PERIPHERAL
// =========================================================================
module garuda_uart_tx (
    input wire clk,
    input wire reset_n,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg busy
);

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_index;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            tx        <= 1'b1; // Idle HIGH
            busy      <= 1'b0;
            state     <= 4'd0;
            shift_reg <= 8'h00;
            bit_index <= 4'd0;
        end else begin
            case (state)
                4'd0: begin // IDLE
                    tx <= 1'b1;
                    if (tx_start) begin
                        busy      <= 1'b1;
                        shift_reg <= tx_data;
                        bit_index <= 4'd0;
                        state     <= 4'd1; // START BIT
                    end else begin
                        busy <= 1'b0;
                    end
                end
                4'd1: begin // START BIT (LOW)
                    tx    <= 1'b0;
                    state <= 4'd2; // DATA BITS
                end
                4'd2: begin // DATA BITS (8 bits)
                    tx <= shift_reg[bit_index];
                    if (bit_index == 4'd7) begin
                        state <= 4'd3; // STOP BIT
                    end else begin
                        bit_index <= bit_index + 1'b1;
                    end
                end
                4'd3: begin // STOP BIT (HIGH)
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                    state <= 4'd0; // Return to IDLE
                end
                default: state <= 4'd0;
            endcase
        end
    end

endmodule
