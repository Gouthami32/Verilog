`timescale 1ns/1ps

// ----------------------------------------------------------------------
// Testbench for Experiment 8: DualClockFIFO
// Demonstrates proper behavior with independent write/read clocks.
// ----------------------------------------------------------------------

module tb_DualClockFIFO;

    reg wclk, rclk;
    reg wrst_n, rrst_n;
    reg write_en, read_en;
    reg [7:0] write_data;
    wire [7:0] read_data;
    wire full, empty;

    // DUT
    DualClockFIFO dut (
        .wclk(wclk), .rclk(rclk),
        .wrst_n(wrst_n), .rrst_n(rrst_n),
        .write_en(write_en), .read_en(read_en),
        .write_data(write_data),
        .read_data(read_data),
        .full(full), .empty(empty)
    );

    // Write clock = 10ns
    always #5 wclk = ~wclk;

    // Read clock = 14ns
    always #7 rclk = ~rclk;

    task write_byte(input [7:0] d);
        begin
            write_data = d;
            write_en = 1;
            @(posedge wclk);
            write_en = 0;
        end
    endtask

    task read_byte();
        begin
            read_en = 1;
            @(posedge rclk);
            read_en = 0;
        end
    endtask

    initial begin
        $dumpfile("dualclockfifo.vcd");
        $dumpvars(0, tb_DualClockFIFO);

        wclk = 0; rclk = 0;
        wrst_n = 0; rrst_n = 0;
        write_en = 0; read_en = 0;

        // Release resets in different cycles
        #20 wrst_n = 1;
        #30 rrst_n = 1;

        // Write some bytes
        write_byte(8'h11);
        write_byte(8'h22);
        write_byte(8'h33);
        write_byte(8'h44);

        // Attempt write when full
        write_byte(8'h55);

        // Begin reading
        read_byte();
        read_byte();

        // More writes
        write_byte(8'h66);
        write_byte(8'h77);

        // Read the rest
        repeat(5) read_byte();

        #100 $finish;
    end

    initial begin
        $monitor("t=%0t | full=%b empty=%b | wdata=%h | rdata=%h",
                 $time, full, empty, write_data, read_data);
    end

endmodule
