`timescale 1ns / 1ps
// GARUDA SEMESTA GEN2 — 4-Port Round-Robin Bus Arbiter with Grant Locking
module garuda_bus_arbiter (
    input  wire        clk,
    input  wire        rst_n,

    // Request lines from 4 harts
    input  wire [3:0]  req,          // req[i] = hart i requests memory bus
    input  wire [3:0]  transaction_done, // transaction_done[i] = hart i transaction finished

    // Grant outputs to 4 harts (one-hot or zero)
    output reg  [3:0]  grant,        // grant[i] = hart i currently owns the bus
    output reg  [1:0]  owner_id      // 00, 01, 10, 11 indicating active owner hart
);

    reg [1:0] arb_ptr; // Round-robin pointer (0 to 3)
    reg       locked;  // Bus lock during active transaction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            arb_ptr  <= 2'd0;
            grant    <= 4'b0000;
            owner_id <= 2'd0;
            locked   <= 1'b0;
        end else begin
            if (locked) begin
                // Check if active owner has completed transaction
                if (transaction_done[owner_id]) begin
                    grant    <= 4'b0000;
                    locked   <= 1'b0;
                    arb_ptr  <= owner_id; // Advance round-robin pointer past current owner
                end
            end else begin
                // Select next requesting hart using round-robin priority
                if (req != 4'b0000) begin
                    casex (arb_ptr)
                        2'd0: begin
                            if      (req[1]) begin owner_id <= 2'd1; grant <= 4'b0010; locked <= 1'b1; end
                            else if (req[2]) begin owner_id <= 2'd2; grant <= 4'b0100; locked <= 1'b1; end
                            else if (req[3]) begin owner_id <= 2'd3; grant <= 4'b1000; locked <= 1'b1; end
                            else if (req[0]) begin owner_id <= 2'd0; grant <= 4'b0001; locked <= 1'b1; end
                        end
                        2'd1: begin
                            if      (req[2]) begin owner_id <= 2'd2; grant <= 4'b0100; locked <= 1'b1; end
                            else if (req[3]) begin owner_id <= 2'd3; grant <= 4'b1000; locked <= 1'b1; end
                            else if (req[0]) begin owner_id <= 2'd0; grant <= 4'b0001; locked <= 1'b1; end
                            else if (req[1]) begin owner_id <= 2'd1; grant <= 4'b0010; locked <= 1'b1; end
                        end
                        2'd2: begin
                            if      (req[3]) begin owner_id <= 2'd3; grant <= 4'b1000; locked <= 1'b1; end
                            else if (req[0]) begin owner_id <= 2'd0; grant <= 4'b0001; locked <= 1'b1; end
                            else if (req[1]) begin owner_id <= 2'd1; grant <= 4'b0010; locked <= 1'b1; end
                            else if (req[2]) begin owner_id <= 2'd2; grant <= 4'b0100; locked <= 1'b1; end
                        end
                        2'd3: begin
                            if      (req[0]) begin owner_id <= 2'd0; grant <= 4'b0001; locked <= 1'b1; end
                            else if (req[1]) begin owner_id <= 2'd1; grant <= 4'b0010; locked <= 1'b1; end
                            else if (req[2]) begin owner_id <= 2'd2; grant <= 4'b0100; locked <= 1'b1; end
                            else if (req[3]) begin owner_id <= 2'd3; grant <= 4'b1000; locked <= 1'b1; end
                        end
                        default: begin
                            grant  <= 4'b0000;
                            locked <= 1'b0;
                        end
                    endcase
                end
            end
        end
    end

endmodule
