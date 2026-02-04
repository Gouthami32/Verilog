// -----------------------------------------------------------------------------
// Experiment 9: PulseStretch
// -----------------------------------------------------------------------------
// Goal:
//   Detect a 1-cycle input pulse and stretch it into a *fixed* 5-cycle output.
//   - If a new pulse arrives while stretching, ignore it.
//   - Output is high for exactly 5 cycles regardless of input width.
//
// Design Notes:
//   - Use a counter that starts when a pulse is detected.
//   - Ignore additional input pulses while stretching is active.
// -----------------------------------------------------------------------------

module PulseStretch #(
    parameter WIDTH = 5   // Stretch length in cycles
)(
    input  clk,
    input  rst,
    input  in_pulse,      // Incoming pulse (may be short or noisy)
    output reg out_pulse  // 5-cycle stretched output
);

    reg [2:0] count;      // Enough bits to count up to 5
    reg       active;     // Indicates stretching is in progress

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_pulse <= 0;
            active    <= 0;
            count     <= 0;
        end else begin

            // Start stretching when a pulse is seen and not already active
            if (in_pulse && !active) begin
                active    <= 1;
                count     <= WIDTH - 1; // This cycle + remaining
                out_pulse <= 1;
            end

            else if (active) begin
                if (count == 0) begin
                    // Finish stretching
                    active    <= 0;
                    out_pulse <= 0;
                end else begin
                    // Continue stretching
                    count <= count - 1;
                    out_pulse <= 1;
                end
            end

            // If not active and no new pulse → output stays low
        end
    end

endmodule
