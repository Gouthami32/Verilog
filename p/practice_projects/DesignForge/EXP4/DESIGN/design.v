// -------------------------------------------------------------
// PriorityLock - 4-Input Round Robin Arbiter
// -------------------------------------------------------------
// Behavior:
// - Takes 4 request inputs (req[3:0])
// - Produces 4 grant outputs (gnt[3:0])
// - Only 1 grant can be active at any time
// - Fair round-robin rotation after a grant
// - If no requests → no grants
// - If multiple requests → the next request in rotation wins
// -------------------------------------------------------------

module PriorityLock(
    input        clk,
    input        rst_n,
    input  [3:0] req,     // Request lines
    output reg [3:0] gnt  // Grant lines
);

    reg [1:0] pointer;    // Tracks who has next priority (0–3)

    // ----- ROUND ROBIN ARBITER LOGIC -----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gnt     <= 4'b0000;
            pointer <= 2'd0;     // Start giving priority to req0
        end
        else begin
            gnt <= 4'b0000;      // Default no grant

            // Search for the next requester starting from pointer
            casex ({req, pointer})
                // Try requester pointed by pointer, then wrap around
                default: begin
                    integer i;
                    for (i = 0; i < 4; i = i + 1) begin
                        if (req[(pointer + i) % 4]) begin
                            gnt[(pointer + i) % 4] <= 1'b1;
                            pointer <= (pointer + i + 1) % 4;  // Advance pointer
                            disable default;  // Break loop
                        end
                    end
                end
            endcase
        end
    end

endmodule
