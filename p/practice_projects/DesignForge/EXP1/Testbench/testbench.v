`timescale 1ns / 1ps

// -------------------------------------------------------------
// SmartCounter Testbench
// Tests: reset, load, enable increment, hold functionality.
// -------------------------------------------------------------

module tb_SmartCounter;

    reg clk;
    reg rst_n;
    reg enable;
    reg load;
    reg [7:0] load_val;
    wire [7:0] count;

    // Instantiate DUT
    SmartCounter dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .load(load),
        .load_val(load_val),
        .count(count)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("SmartCounter.vcd");
        $dumpvars(0, tb_SmartCounter);

        // Initial values
        clk = 0;
        rst_n = 0;
        enable = 0;
        load = 0;
        load_val = 8'd0;

        // Apply reset
        #12 rst_n = 1;

        // ------------------------------------------------------
        // TEST 1: LOAD OPERATION
        // ------------------------------------------------------
        $display("\nTEST 1: LOAD operation");
        load_val = 8'd50;
        load = 1; enable = 0;
        @(posedge clk);
        load = 0;

        // ------------------------------------------------------
        // TEST 2: INCREMENT USING ENABLE
        // ------------------------------------------------------
        $display("\nTEST 2: Increment");
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;

        // ------------------------------------------------------
        // TEST 3: HOLD VALUE (enable=0)
        // ------------------------------------------------------
        $display("\nTEST 3: Hold");
        repeat(3) @(posedge clk);

        // ------------------------------------------------------
        // TEST 4: LOAD NEW VALUE MIDWAY
        // ------------------------------------------------------
        $display("\nTEST 4: Load mid-operation");
        load_val = 8'd200;
        load = 1; @(posedge clk);
        load = 0;

        // ------------------------------------------------------
        // TEST 5: RESET CHECK
        // ------------------------------------------------------
        $display("\nTEST 5: Reset check");
        rst_n = 0; @(posedge clk);
        rst_n = 1;

        #20;
        $display("\nSimulation Completed");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("t=%0t | rst_n=%b load=%b enable=%b load_val=%d count=%d",
            $time, rst_n, load, enable, load_val, count);
    end

endmodule
