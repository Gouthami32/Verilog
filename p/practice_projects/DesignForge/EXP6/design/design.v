// -------------------------------------------------------------
// Experiment 6: RingBuffer (FIFO Buffer of Depth 4)
// -------------------------------------------------------------
// Features:
//   - 4-entry FIFO (each entry 8 bits)
//   - write_en → pushes data into FIFO
//   - read_en  → pops data from FIFO
//   - full flag
//   - empty flag
//   - Correct wrap-around behavior using circular indexing
// -------------------------------------------------------------

module RingBuffer (
    input         clk,
    input         rst,
    input         write_en,
    input         read_en,
    input  [7:0]  write_data,
    output reg [7:0] read_data,
    output reg    full,
    output reg    empty
);

    reg [7:0] mem [3:0];    // FIFO memory (depth = 4)
    reg [1:0] w_ptr;        // write pointer
    reg [1:0] r_ptr;        // read pointer
    reg [2:0] count;        // number of elements stored (0–4)

    // ---------------------------------------------------------
    // Sequential Logic
    // ---------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w_ptr  <= 0;
            r_ptr  <= 0;
            count  <= 0;
            full   <= 0;
            empty  <= 1;
            read_data <= 0;
        end else begin

            // ---------------- WRITE OPERATION ----------------
            if (write_en && !full) begin
                mem[w_ptr] <= write_data;
                w_ptr <= w_ptr + 1;        // wrap due to 2-bit pointer
                count <= count + 1;
            end

            // ---------------- READ OPERATION -----------------
            if (read_en && !empty) begin
                read_data <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                count <= count - 1;
            end

            // ---------------- STATUS FLAGS -------------------
            full  <= (count == 4);
            empty <= (count == 0);

        end
    end

endmodule
