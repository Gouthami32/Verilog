// -----------------------------------------------------------------------------
// Experiment 10: ModeMux
// -----------------------------------------------------------------------------
// 4-input multiplexer with two priority modes:
//
// MODE = 0 → FIXED PRIORITY
//          I0 > I1 > I2 > I3
//
// MODE = 1 → ROUND ROBIN
//          Priority rotates every time a request is granted.
//          Ensures fairness across all inputs.
//
// Inputs:
//    clk, rst     → clock + reset
//    mode         → 0=fixed, 1=round-robin
//    req[3:0]     → request lines
//    data_in[3:0] → 8-bit data from each requester
//
// Output:
//    data_out     → selected data
//    grant[3:0]   → 1-hot grant signal
// -----------------------------------------------------------------------------

module ModeMux (
    input  clk,
    input  rst,
    input  mode,                // 0: fixed, 1: round-robin
    input  [3:0] req,           // request lines
    input  [7:0] data_in [3:0], // 4 × 8-bit inputs
    output reg [7:0] data_out,
    output reg [3:0] grant
);

    reg [1:0] rr_ptr; // round-robin pointer (0 → I0 highest priority, then rotate)

    // Update round-robin pointer
    always @(posedge clk or posedge rst) begin
        if (rst)
            rr_ptr <= 0;
        else if (mode && (grant != 0))
            rr_ptr <= rr_ptr + 1;      // rotate only when a grant occurs
    end

    // Priority Logic
    always @(*) begin
        grant = 4'b0000;      // default
        data_out = 0;

        if (mode == 0) begin
            // ------------------- FIXED PRIORITY -------------------
            if      (req[0]) begin grant = 4'b0001; data_out = data_in[0]; end
            else if (req[1]) begin grant = 4'b0010; data_out = data_in[1]; end
            else if (req[2]) begin grant = 4'b0100; data_out = data_in[2]; end
            else if (req[3]) begin grant = 4'b1000; data_out = data_in[3]; end
        end 
        else begin
            // ---------------- ROUND-ROBIN PRIORITY ----------------
            case (rr_ptr)
                2'd0: begin
                    if      (req[0]) begin grant=4'b0001; data_out=data_in[0]; end
                    else if (req[1]) begin grant=4'b0010; data_out=data_in[1]; end
                    else if (req[2]) begin grant=4'b0100; data_out=data_in[2]; end
                    else if (req[3]) begin grant=4'b1000; data_out=data_in[3]; end
                end

                2'd1: begin
                    if      (req[1]) begin grant=4'b0010; data_out=data_in[1]; end
                    else if (req[2]) begin grant=4'b0100; data_out=data_in[2]; end
                    else if (req[3]) begin grant=4'b1000; data_out=data_in[3]; end
                    else if (req[0]) begin grant=4'b0001; data_out=data_in[0]; end
                end

                2'd2: begin
                    if      (req[2]) begin grant=4'b0100; data_out=data_in[2]; end
                    else if (req[3]) begin grant=4'b1000; data_out=data_in[3]; end
                    else if (req[0]) begin grant=4'b0001; data_out=data_in[0]; end
                    else if (req[1]) begin grant=4'b0010; data_out=data_in[1]; end
                end

                2'd3: begin
                    if      (req[3]) begin grant=4'b1000; data_out=data_in[3]; end
                    else if (req[0]) begin grant=4'b0001; data_out=data_in[0]; end
                    else if (req[1]) begin grant=4'b0010; data_out=data_in[1]; end
                    else if (req[2]) begin grant=4'b0100; data_out=data_in[2]; end
                end
            endcase
        end
    end

endmodule
