// -------------------------------------------------------------
// BitVault - 4x8 Register File
// -------------------------------------------------------------
// - 4 Registers, each 8-bit wide
// - 1 Write port (we, waddr, wdata)
// - 1 Read port (raddr, rdata)
// - On write enable=1 → write occurs
// - On write enable=0 → memory remains unchanged
// - Async active-low reset clears all registers
// -------------------------------------------------------------

module BitVault(
    input         clk,        // Clock
    input         rst_n,      // Active-low reset
    input         we,         // Write enable
    input  [1:0]  waddr,      // Write address (0-3)
    input  [7:0]  wdata,      // Write data
    input  [1:0]  raddr,      // Read address (0-3)
    output [7:0]  rdata       // Read data (combinational)
);

    reg [7:0] mem [3:0];      // 4 registers, 8-bit each
    integer i;

    // ------------ Write Logic + Reset -----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers on reset
            for (i = 0; i < 4; i = i + 1)
                mem[i] <= 8'd0;
        end
        else begin
            if (we) begin
                mem[waddr] <= wdata;   // Write only when enabled
            end
        end
    end

    // ------------ Read Logic --------------------------
    assign rdata = mem[raddr];   // Combinational read

endmodule
