`timescale 1ns/1ps

// ---------------------------------------------------------------------
// Testbench for STOP TIMER (FSM STOPWATCH CONTROLLER)
// ---------------------------------------------------------------------
module tb_StopTimer;

    reg clk, rst;
    reg start, stop, clear;
    wire [15:0] elapsed;

    StopTimer dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stop(stop),
        .clear(clear),
        .elapsed(elapsed)
    );

    always #5 clk = ~clk;

    task press(input reg btn);
        begin
            btn = 1; @(posedge clk);
            btn = 0; @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("stoptimer.vcd");
        $dumpvars(0, tb_StopTimer);

        clk = 0;
        rst = 1; start = 0; stop = 0; clear = 0;
        @(posedge clk);
        rst = 0;

        // Start the stopwatch
        $display("\n[START]");
        press(start);

        repeat(10) @(posedge clk);

        // Pause the stopwatch
        $display("\n[STOP]");
        press(stop);

        repeat(5) @(posedge clk);

        // Resume
        $display("\n[START AGAIN]");
        press(start);

        repeat(8) @(posedge clk);

        // Reset timer
        $display("\n[CLEAR]");
        press(clear);

        repeat(5) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("t=%0t | elapsed=%0d | start=%b stop=%b clear=%b",
                 $time, elapsed, start, stop, clear);
    end

endmodule
