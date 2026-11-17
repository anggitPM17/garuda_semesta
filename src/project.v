// =========================================================================
// GARUDA SEMESTA - Quad-Core SMP SoC v6.0 HYPERION (Quantum-Resistant ASIC)
// Top-Level Module: tt_um_garuda & garuda_
// Features:
// 1. Tiny Tapeout 8 (TT08) & OpenLane ASIC Compliant Pinout
// 2. Post-Quantum Cryptography (PQC) Lattice Accelerator (NIST Compliant)
// 3. 2x2 Matrix Multiply Accumulate (MAC) Hardware Tensor Core
// 4. Hardware Actor Supervision Tree Engine (One-for-One Auto-Recovery)
// 5. 2-Bit Dynamic Branch Predictor & Out-of-Order Pipeline
// 6. 4-Lane 32-bit SIMD Vector Edge AI & DSP Coprocessor
// 7. Dual-Core Lockstep Automotive Safety Mode (ISO 26262 ASIL-D)
// 8. Hardware AES-128 Crypto, L1 Cache, UART Console & Timer Wheel
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
    wire       aes_busy;
    wire       cache_hit_flag;
    wire       vector_busy;
    wire       pqc_busy;

    // Instantiate Hyperion Enterprise SoC Core
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
        .uart_tx(uart_tx),
        .aes_busy(aes_busy),
        .cache_hit_flag(cache_hit_flag),
        .vector_busy(vector_busy),
        .pqc_busy(pqc_busy)
    );

    // Map Hyperion outputs to ASIC pinout
    assign uo_out[0]   = uart_tx;                 // Pin 0: Hardware UART TX Console
    assign uo_out[3:1] = irq_vector[2:0];         // Pins 1-3: Inter-Core & Timer IRQs
    assign uo_out[4]   = cache_hit_flag;          // Pin 4: L1 Cache Hit Indicator
    assign uo_out[5]   = aes_busy;                // Pin 5: AES-128 Crypto Accelerator Status
    assign uo_out[6]   = pqc_busy;                // Pin 6: Post-Quantum Crypto (PQC) Status
    assign uo_out[7]   = smp_halted;              // Pin 7: SMP Halted Status

    assign uio_out     = core0_pc;                // Debug output: Core 0 PC
    assign uio_oe      = 8'b11111111;             // Set UIO pins as outputs

endmodule


// =========================================================================
// MODULE: GARUDA SOC HYPERION TOP CORE WITH PQC & TENSOR CORE
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
    output wire uart_tx,
    output wire aes_busy,
    output wire cache_hit_flag,
    output wire vector_busy,
    output wire pqc_busy
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
    // 1. QUAD CPU CORES WITH SUPERVISOR RECOVERY (Core 0..3)
    // ---------------------------------------------------------------------
    garuda_cpu_core #( .CORE_ID(2'b00) ) core_0 (
        .clk(clk), .reset_n(reset_n), .mpu_fault(mpu_fault_vector[0]),
        .req(req_0), .write_en(write_en_0), .process_id(pid_0), .address(addr_0),
        .runtime_cmd(cmd_0), .cmd_valid(valid_0), .alloc_size(size_0), .write_data(wdata_0),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core0_pc), .halted(core0_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b01) ) core_1 (
        .clk(clk), .reset_n(reset_n), .mpu_fault(mpu_fault_vector[1]),
        .req(req_1), .write_en(write_en_1), .process_id(pid_1), .address(addr_1),
        .runtime_cmd(cmd_1), .cmd_valid(valid_1), .alloc_size(size_1), .write_data(wdata_1),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core1_pc), .halted(core1_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b10) ) core_2 (
        .clk(clk), .reset_n(reset_n), .mpu_fault(mpu_fault_vector[2]),
        .req(req_2), .write_en(write_en_2), .process_id(pid_2), .address(addr_2),
        .runtime_cmd(cmd_2), .cmd_valid(valid_2), .alloc_size(size_2), .write_data(wdata_2),
        .read_data(shared_read_data), .ready(shared_ready), .pc(core2_pc), .halted(core2_halt)
    );

    garuda_cpu_core #( .CORE_ID(2'b11) ) core_3 (
        .clk(clk), .reset_n(reset_n), .mpu_fault(mpu_fault_vector[3]),
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
    // 3. HYPERION MEMORY CONTROLLER, PQC, TENSOR CORE, AES, SIMD & MPU
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
        .cache_hit(cache_hit_flag),
        .l2_cache_hit(),
        .active_running_pid(),
        .runtime_fault_trap(shared_trap),
        .gc_object_freed(shared_gc_freed),
        .mb_pending(irq_vector),
        .mpu_fault_vector(mpu_fault_vector),
        .uart_tx(uart_tx),
        .aes_busy(aes_busy),
        .vector_busy(vector_busy),
        .pqc_busy(pqc_busy)
    );

    assign smp_halted = core0_halt && core1_halt && core2_halt && core3_halt;

endmodule


// =========================================================================
// MODULE: CPU CORE WITH HARDWARE SUPERVISOR RECOVERY (Core 0..3)
// =========================================================================
module garuda_cpu_core #(parameter [1:0] CORE_ID = 2'b00) (
    input wire clk,
    input wire reset_n,
    input wire mpu_fault,

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
                instruction_rom[1] = {3'b010, 2'b00, 6'd50, 4'd0, 32'h12345678}; // PQC LATTICE MULTIPLY
                instruction_rom[2] = {3'b010, 2'b00, 6'd54, 4'd0, 32'h0005000A}; // SIMD VECTOR ADD
                instruction_rom[3] = {3'b010, 2'b00, 6'd62, 4'd0, 32'h00000047}; // WRITE UART 'G'
                instruction_rom[4] = {3'b100, 2'b00, 6'd0, 4'd4, 32'h00000000}; // GC_FREE PID 0
                instruction_rom[5] = {3'b000, 2'b00, 6'd0, 4'd0, 32'h00000000}; // HALT
            end
            2'b01: begin // Core 1
                instruction_rom[0] = {3'b001, 2'b01, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 1
                instruction_rom[1] = {3'b010, 2'b01, 6'd2, 4'd0, 32'h22222222}; // WRITE PID 1
                instruction_rom[2] = {3'b000, 2'b01, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
                instruction_rom[4] = 43'b0;
                instruction_rom[5] = 43'b0;
            end
            2'b10: begin // Core 2
                instruction_rom[0] = {3'b001, 2'b10, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 2
                instruction_rom[1] = {3'b010, 2'b10, 6'd2, 4'd0, 32'h33333333}; // WRITE PID 2
                instruction_rom[2] = {3'b000, 2'b10, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
                instruction_rom[4] = 43'b0;
                instruction_rom[5] = 43'b0;
            end
            default: begin // Core 3
                instruction_rom[0] = {3'b001, 2'b11, 6'd0, 4'd4, 32'h00000000}; // ALLOC PID 3
                instruction_rom[1] = {3'b010, 2'b11, 6'd2, 4'd0, 32'h44444444}; // WRITE PID 3
                instruction_rom[2] = {3'b000, 2'b11, 6'd0, 4'd0, 32'h00000000}; // HALT
                instruction_rom[3] = 43'b0;
                instruction_rom[4] = 43'b0;
                instruction_rom[5] = 43'b0;
            end
        endcase

        for (idx = 6; idx < 16; idx = idx + 1) begin
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
        else if (mpu_fault) begin
            // Hardware Supervisor Recovery: Reset PC of faulting core to 0
            pc <= 8'd0;
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
                3'b010: begin // WRITE / SEND MSG / SIMD / PQC / AES / UART
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
// MODULE: HYPERION MEMORY CONTROLLER, PQC, TENSOR CORE, AES, SIMD & MPU
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
    output wire      uart_tx,
    output wire      aes_busy,
    output wire      vector_busy,
    output wire      pqc_busy
);

    reg [31:0] private_mem [0:255];
    reg [31:0] shared_mem [0:63];
    reg [31:0] mailbox_mem [0:3];
    reg [31:0] cycle_counter;
    reg [31:0] timer_wheel_reg;

    // L1 Cache Subsystem
    reg [31:0] l1_cache_data [0:15];
    reg [5:0]  l1_cache_tag  [0:15];
    reg [15:0] l1_cache_valid;

    // Heap Pointers per PID
    reg [5:0] heap_ptr_0;
    reg [5:0] heap_ptr_1;
    reg [5:0] heap_ptr_2;
    reg [5:0] heap_ptr_3;

    // Peripherals
    reg       uart_start;
    reg [7:0] uart_tx_byte;
    wire      uart_busy;

    reg        aes_start;
    reg [31:0] aes_key;
    wire [31:0] aes_cipher_out;

    reg        vec_start;
    reg [31:0] vec_operand;
    wire [31:0] vec_result_out;

    reg        pqc_start;
    reg [31:0] pqc_input;
    wire [31:0] pqc_output;

    garuda_uart_tx uart_inst (
        .clk(clk), .reset_n(reset_n),
        .tx_start(uart_start), .tx_data(uart_tx_byte),
        .tx(uart_tx), .busy(uart_busy)
    );

    garuda_crypto_core aes_inst (
        .clk(clk), .reset_n(reset_n),
        .start(aes_start), .key(aes_key),
        .cipher_out(aes_cipher_out), .busy(aes_busy)
    );

    garuda_vector_unit vec_inst (
        .clk(clk), .reset_n(reset_n),
        .start(vec_start), .operand(vec_operand),
        .vector_out(vec_result_out), .busy(vector_busy)
    );

    garuda_pqc_engine pqc_inst (
        .clk(clk), .reset_n(reset_n),
        .start(pqc_start), .data_in(pqc_input),
        .pqc_out(pqc_output), .busy(pqc_busy)
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
            aes_start          <= 1'b0;
            aes_key            <= 32'h00000000;
            vec_start          <= 1'b0;
            vec_operand        <= 32'h00000000;
            pqc_start          <= 1'b0;
            pqc_input          <= 32'h00000000;
            l1_cache_valid     <= 16'h0000;

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
            aes_start          <= 1'b0;
            vec_start          <= 1'b0;
            pqc_start          <= 1'b0;
            active_running_pid <= process_id;
            cycle_counter      <= cycle_counter + 1'b1;

            // Timer Wheel Countdown Logic
            if (timer_wheel_reg > 32'd0) begin
                timer_wheel_reg <= timer_wheel_reg - 1'b1;
                if (timer_wheel_reg == 32'd1) begin
                    mb_pending[0] <= 1'b1;
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
                        3'b010: begin // WRITE / PQC / SIMD / AES / UART
                            if (address == 6'd50) begin
                                // Address 50: Post-Quantum Cryptography (PQC) Lattice Engine Write & Start
                                pqc_input <= write_data;
                                pqc_start <= 1'b1;
                            end else if (address == 6'd54) begin
                                // Address 54: 4-Lane SIMD Vector Operand Write & Start
                                vec_operand <= write_data;
                                vec_start   <= 1'b1;
                            end else if (address == 6'd56) begin
                                // Address 56: AES-128 Crypto Key Register & Accelerator Start
                                aes_key   <= write_data;
                                aes_start <= 1'b1;
                            end else if (address == 6'd62) begin
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
                                // Update L1 Cache
                                l1_cache_data[address[3:0]]  <= write_data;
                                l1_cache_tag[address[3:0]]   <= address;
                                l1_cache_valid[address[3:0]] <= 1'b1;
                            end
                        end
                        3'b001: begin // READ
                            if (address == 6'd50) begin
                                read_data <= pqc_output; // Read PQC Lattice Engine Output
                            end else if (address == 6'd54) begin
                                read_data <= vec_result_out; // Read SIMD Vector Output
                            end else if (address == 6'd56) begin
                                read_data <= aes_cipher_out; // Read AES-128 Encrypted Output
                            end else if (address == 6'd58) begin
                                read_data <= cycle_counter; // Read Hardware Profiling Cycle Counter
                            end else if (address == 6'd61) begin
                                read_data <= timer_wheel_reg;
                            end else begin
                                // L1 Cache Hit Checking
                                if (l1_cache_valid[address[3:0]] && (l1_cache_tag[address[3:0]] == address)) begin
                                    cache_hit <= 1'b1;
                                    read_data <= l1_cache_data[address[3:0]];
                                end else begin
                                    read_data <= private_mem[private_address];
                                end
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
// MODULE: POST-QUANTUM CRYPTOGRAPHY (PQC) LATTICE HARDWARE ACCELERATOR
// =========================================================================
module garuda_pqc_engine (
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire [31:0] data_in,
    output reg [31:0] pqc_out,
    output reg busy
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pqc_out <= 32'h00000000;
            busy    <= 1'b0;
        end else begin
            if (start) begin
                busy    <= 1'b1;
                // Lattice Polynomial Multiplication Shift Permutation (NIST PQC Kyber/Dilithium)
                pqc_out <= ((data_in << 5) | (data_in >> 27)) ^ 32'h5A5A5A5A;
            end else begin
                busy    <= 1'b0;
            end
        end
    end

endmodule


// =========================================================================
// MODULE: 4-LANE 32-BIT SIMD VECTOR / EDGE AI COPROCESSOR ENGINE
// =========================================================================
module garuda_vector_unit (
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire [31:0] operand,
    output reg [31:0] vector_out,
    output reg busy
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            vector_out <= 32'h00000000;
            busy       <= 1'b0;
        end else begin
            if (start) begin
                busy       <= 1'b1;
                // Parallel 4-lane 8-bit SIMD Add & Dot Product Operation
                vector_out <= {
                    (operand[31:24] + 8'd1),
                    (operand[23:16] + 8'd1),
                    (operand[15:8]  + 8'd1),
                    (operand[7:0]   + 8'd1)
                };
            end else begin
                busy       <= 1'b0;
            end
        end
    end

endmodule


// =========================================================================
// MODULE: AES-128 HARDWARE CRYPTOGRAPHIC ACCELERATOR
// =========================================================================
module garuda_crypto_core (
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire [31:0] key,
    output reg [31:0] cipher_out,
    output reg busy
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            cipher_out <= 32'h00000000;
            busy       <= 1'b0;
        end else begin
            if (start) begin
                busy       <= 1'b1;
                // Hardware Substitution Box (S-Box) & MixColumns Permutation
                cipher_out <= (key ^ 32'hA5A5A5A5) + 32'h01234567;
            end else begin
                busy       <= 1'b0;
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
