// -------------------------------------------------------------
// ByteStreamer - 8-bit Serial-to-Parallel Converter
// -------------------------------------------------------------
// Operation:
// - When reset is active → internal register and count reset.
// - On each clock, if shift_enable=1:
//      • Shift input bit (LSB first or MSB first based on design).
//      • After 8 shifts, output the collected byte.
// - Output 'byte_ready' goes high for one cycle once 8 bits collected.
// -------------------------------------------------------------

module ByteStreamer(
    input        clk,           // System clock
    input        rst_n,         // Active-low reset
    input        shift_enable,  // Enables shifting of serial input
    input        serial_in,     // 1-bit serial data
    output reg [7:0] parallel_out, // Full 8-bit output
    output reg   byte_ready     // High for 1 cycle when full byte is ready
);

    reg [7:0] shift_reg;        // Temporary shift register
    reg [3:0] bit_count;        // Counts from 0 to 7

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg   <= 8'd0;
            bit_count   <= 4'd0;
            parallel_out <= 8'd0;
            byte_ready  <= 1'b0;
        end 
        else begin
            byte_ready <= 1'b0; // Default low

            if (shift_enable) begin
                // Shift left and insert new bit as LSB
                shift_reg <= {shift_reg[6:0], serial_in};
                
                // Count bits
                bit_count <= bit_count + 1;

                // If 8 bits collected → output full byte
                if (bit_count == 4'd7) begin
                    parallel_out <= {shift_reg[6:0], serial_in};
                    byte_ready <= 1'b1; 
                    bit_count <= 0;  // Reset counter for next byte
                end
            end
        end
    end

endmodule
