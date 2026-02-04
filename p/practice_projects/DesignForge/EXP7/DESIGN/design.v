// ---------------------------------------------------------------------
// Experiment 7: StopTimer (FSM-Based Stopwatch Controller)
// ---------------------------------------------------------------------
// Inputs:
//   clk       - clock signal
//   rst       - asynchronous reset
//   start     - start the timer
//   stop      - stop/pause the timer
//   clear     - reset elapsed time to 0
//
// Output:
//   elapsed   - 16-bit time count
//
// FSM States:
//   IDLE      - timer stopped, waiting for start
//   RUNNING   - counting every cycle
//   PAUSED    - stopped, waiting for start again
//
// Behavior Notes:
//   - start causes RUNNING state
//   - stop pauses timer
//   - clear resets elapsed time
// ---------------------------------------------------------------------

module StopTimer(
    input clk,
    input rst,
    input start,
    input stop,
    input clear,
    output reg [15:0] elapsed
);

    typedef enum reg [1:0] {
        IDLE,
        RUNNING,
        PAUSED
    } state_t;

    state_t ps, ns;

    // -------------------- Next State Logic -------------------------
    always @(*) begin
        ns = ps;
        case (ps)
            IDLE: begin
                if (start) ns = RUNNING;
            end

            RUNNING: begin
                if (stop) ns = PAUSED;
                else if (clear) ns = IDLE;
            end

            PAUSED: begin
                if (start) ns = RUNNING;
                else if (clear) ns = IDLE;
            end
        endcase
    end

    // -------------------- State Register ---------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= IDLE;
        else
            ps <= ns;
    end

    // -------------------- Output Logic -----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst || clear)
            elapsed <= 0;
        else if (ps == RUNNING)
            elapsed <= elapsed + 1;
    end

endmodule
