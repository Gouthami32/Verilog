// ----------------------------------------------------------------------
// Experiment 8: DualClockFIFO
// ----------------------------------------------------------------------
// Features:
//   - Separate write and read clocks (asynchronous)
//   - Depth = 4 FIFO (2-bit pointers)
//   - Gray-coded read/write pointers for safe clock-domain crossing
//   - 2-FF synchronizers
//   - Full / Empty flags
// ----------------------------------------------------------------------

module DualClockFIFO (
    input         wclk,         // Write clock
    input         rclk,         // Read clock
    input         wrst_n,       // Active-low write domain reset
    input         rrst_n,       // Active-low read domain reset
    input         write_en,
    input         read_en,
    input  [7:0]  write_data,
    output reg [7:0] read_data,
    output reg    full,
    output reg    empty
);

    // FIFO memory (depth = 4)
    reg [7:0] mem [3:0];

    // Binary pointers
    reg [1:0] w_ptr_bin, r_ptr_bin;

    // Gray-coded pointers
    reg [1:0] w_ptr_gray, r_ptr_gray;

    // Synchronized pointers
    reg [1:0] w_ptr_gray_sync1, w_ptr_gray_sync2;
    reg [1:0] r_ptr_gray_sync1, r_ptr_gray_sync2;

    // ----------------------------------------------------
    // Convert binary → gray code
    // ----------------------------------------------------
    function [1:0] bin_to_gray(input [1:0] bin);
        bin_to_gray = (bin >> 1) ^ bin;
    endfunction

    // ----------------------------------------------------
    // WRITE CLOCK DOMAIN
    // ----------------------------------------------------
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            w_ptr_bin  <= 0;
            w_ptr_gray <= 0;
            full       <= 0;
        end else begin

            // Write operation
            if (write_en && !full) begin
                mem[w_ptr_bin] <= write_data;
                w_ptr_bin  <= w_ptr_bin + 1;
                w_ptr_gray <= bin_to_gray(w_ptr_bin + 1);
            end

            // Full condition:
            // Compare write_ptr_gray to synchronized read pointer
            full <= (w_ptr_gray == {~r_ptr_gray_sync2[1], r_ptr_gray_sync2[0]});
        end
    end

    // ----------------------------------------------------
    // READ CLOCK DOMAIN
    // ----------------------------------------------------
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            r_ptr_bin  <= 0;
            r_ptr_gray <= 0;
            empty      <= 1;
            read_data  <= 0;
        end else begin

            // Read operation
            if (read_en && !empty) begin
                read_data <= mem[r_ptr_bin];
                r_ptr_bin  <= r_ptr_bin + 1;
                r_ptr_gray <= bin_to_gray(r_ptr_bin + 1);
            end

            // Empty condition:
            empty <= (r_ptr_gray == w_ptr_gray_sync2);
        end
    end

    // ----------------------------------------------------
    // Synchronizers: 2-FF CDC
    // ----------------------------------------------------
    // Sync read pointer into write clock domain
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            {r_ptr_gray_sync1, r_ptr_gray_sync2} <= 0;
        else begin
            r_ptr_gray_sync1 <= r_ptr_gray;
            r_ptr_gray_sync2 <= r_ptr_gray_sync1;
        end
    end

    // Sync write pointer into read clock domain
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {w_ptr_gray_sync1, w_ptr_gray_sync2} <= 0;
        else begin
            w_ptr_gray_sync1 <= w_ptr_gray;
            w_ptr_gray_sync2 <= w_ptr_gray_sync1;
        end
    end

endmodule
