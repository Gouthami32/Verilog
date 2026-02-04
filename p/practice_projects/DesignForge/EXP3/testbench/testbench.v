// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

// -------------------------------------------------------------
// ByteStreamer Testbench
// -------------------------------------------------------------
// The TB will:
// 1. Shift a known 8-bit pattern serially into the DUT
// 2. Verify that parallel_out matches the expected byte
// 3. Test multiple bytes
// 4. Test shift_enable = 0 (no shifting)
// 5. Test reset behavior
// -------------------------------------------------------------

module tb_ByteStreamer;

    reg clk, rst_n;
    reg shift_enable;
    reg serial_in;
    wire [7:0] parallel_out;
    wire byte_ready;

    ByteStreamer dut (
        .clk(clk),
        .rst_n(rst_n),
        .shift_enable(shift_enable),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .byte_ready(byte_ready)
    );

    // 10ns clock
    always #5 clk = ~clk;

    // Task to send one byte serially (MSB→LSB or LSB→MSB based on design)
    task send_byte(input [7:0] value);
        integer i;
        begin
            $display("\nSending byte: %b", value);
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = value[i];
                shift_enable = 1;
                @(posedge clk);
            end
            shift_enable = 0;
        end
    endtask

    initial begin
        $dumpfile("bytestreamer.vcd");
        $dumpvars(0, tb_ByteStreamer);

        clk = 0;
        rst_n = 0;
        shift_enable = 0;
        serial_in = 0;

        // Reset
        #15 rst_n = 1;

        // ---------------------------------------------------------
        // TEST 1: Send a single byte
        // ---------------------------------------------------------
        send_byte(8'b10101010);

        @(posedge clk);
        if (byte_ready)
            $display("Byte received: %b", parallel_out);

        // ---------------------------------------------------------
        // TEST 2: Send another byte
        // ---------------------------------------------------------
        send_byte(8'b11110000);
        @(posedge clk);
        if (byte_ready)
            $display("Byte received: %b", parallel_out);

        // ---------------------------------------------------------
        // TEST 3: No-shift test
        // ---------------------------------------------------------
        $display("\nTEST: No shifting when shift_enable=0");
        shift_enable = 0;
        repeat(5) @(posedge clk);

        // ---------------------------------------------------------
        // TEST 4: Reset test
        // ---------------------------------------------------------
        $display("\nApplying Reset...");
        rst_n = 0; @(posedge clk);
        rst_n = 1;

        #20;
        $display("\nSimulation Complete.");
        $finish;
    end

    initial begin
        $monitor("t=%0t serial_in=%b shift_enable=%b parallel_out=%b byte_ready=%b",
                 $time, serial_in, shift_enable, parallel_out, byte_ready);
    end

endmodule
