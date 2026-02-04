
module seqcheck (
    input  wire clk,
    input  wire rst_n,     // async active-low reset
    input  wire in_sig,
    output reg  hit
);

    // ---------------- Synchronizer + rise detection ----------------
    reg s1, s2, prev;
    wire rise;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1   <= 1'b0;
            s2   <= 1'b0;
            prev <= 1'b0;
        end else begin
            s1   <= in_sig;
            s2   <= s1;
            prev <= s2;
        end
    end

    assign rise = s2 & ~prev;

    // ---------------- Ring buffer + running sum ----------------
    reg [2:0] sum;          // need up to 5 -> 3 bits
    reg [2:0] idx;          // index 0..4
    reg [4:0] rb;           // ring buffer of rises (5 cycles)
    reg       cond_d;
    reg [2:0] next_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum     <= 3'd0;
            idx     <= 3'd0;
            rb      <= 5'd0;
            cond_d  <= 1'b0;
            hit     <= 1'b0;
        end else begin
            next_sum    = sum - rb[idx] + rise;
            sum         <= next_sum;
            rb[idx]     <= rise;
            if (idx == 3'd4)
                idx <= 3'd0;
            else
                idx <= idx + 1'b1;

            if ((next_sum >= 3) && !cond_d)
                hit <= 1'b1;
            else
                hit <= 1'b0;

            cond_d <= (next_sum >= 3);
        end
    end

endmodule
