// Code your design here
// -------------------------------------------------------------
// SmartCounter
// 8-bit counter with load, enable, and async reset.
// - When reset = 0 → counter resets to 0.
// - When load = 1  → counter loads input value.
// - When enable = 1 (and load = 0) → counter increments.
// - When enable = 0 → counter holds value.
// -------------------------------------------------------------

module SmartCounter(
    input        clk,        // System clock
    input        rst_n,      // Active-low asynchronous reset
    input        enable,     // When 1, counter increments
    input        load,       // When 1, load input value
    input  [7:0] load_val,   // Value to load
    output reg [7:0] count   // Counter output
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'd0;              // Reset counter
        end 
        else if (load) begin
            count <= load_val;          // Load operation
        end 
        else if (enable) begin
            count <= count + 1;         // Increment
        end
    end

endmodule

