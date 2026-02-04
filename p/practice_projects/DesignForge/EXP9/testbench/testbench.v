`timescale 1ns/1ps

module tb_PulseStretch;

    reg clk, rst, in_pulse;
    wire out_pulse;

    PulseStretch dut (
        .clk(clk),
        .rst(rst),
        .in_pulse(in_pulse),
        .out_pulse(out_pulse)
    );

    always #5 clk = ~clk;  // 10ns period

    task pulse();
        begin
            in_pulse = 1; @(posedge clk);
            in_pulse = 0;
        end
    endtask

    initial begin
        $dumpfile("pulsestretch.vcd");
        $dumpvars(0, tb_PulseStretch);

        clk = 0; in_pulse = 0;
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Test 1: Single 1-cycle pulse
        $display("\nTEST 1: Single pulse");
        pulse();
        repeat(10) @(posedge clk);

        // Test 2: Pulse during active stretch (should ignore)
        $display("\nTEST 2: Pulse ignored while stretching");
        pulse();
        @(posedge clk);
        pulse();  // should be ignored
        repeat(10) @(posedge clk);

        // Test 3: Rapid pulses
        $display("\nTEST 3: Multiple rapid pulses");
        pulse();
        @(posedge clk);
        pulse();
        @(posedge clk);
        pulse();
        repeat(20) @(posedge clk);

        // Test 4: Long input pulse (still only 5-cycle output)
        $display("\nTEST 4: Long pulse");
        in_pulse = 1;
        repeat(3) @(posedge clk);
        in_pulse = 0;
        repeat(12) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("t=%0t | in=%b | out=%b", $time, in_pulse, out_pulse);
    end

endmodule
