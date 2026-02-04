`timescale 1ns/1ps

// -------------------------------------------------------------
// Testbench for PriorityLock Round-Robin Arbiter
// -------------------------------------------------------------
// Tests include:
// - Single requests
// - Multiple simultaneous requests
// - Persistent requests
// - Rotational fairness
// - Reset behavior
// -------------------------------------------------------------

module tb_PriorityLock;

    reg clk, rst_n;
    reg [3:0] req;
    wire [3:0] gnt;

    PriorityLock dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .gnt(gnt)
    );

    always #5 clk = ~clk;  // 10 ns clock

    // Monitor
    initial begin
        $monitor("t=%0t | req=%b | gnt=%b", $time, req, gnt);
    end

    initial begin
        $dumpfile("prioritylock.vcd");
        $dumpvars(0, tb_PriorityLock);

        clk = 0;
        rst_n = 0;
        req = 4'b0000;

        #12 rst_n = 1;

        // ---------------------------------------------------------
        // TEST 1: Single request
        // ---------------------------------------------------------
        $display("\nTEST 1: Single request on req0");
        req = 4'b0001;
        repeat(4) @(posedge clk);

        // ---------------------------------------------------------
        // TEST 2: Multiple simultaneous requests
        // ---------------------------------------------------------
        $display("\nTEST 2: Multiple requests (req1, req2)");
        req = 4'b0110;
        repeat(6) @(posedge clk);

        // ---------------------------------------------------------
        // TEST 3: Persistent request fairness test
        // ---------------------------------------------------------
        $display("\nTEST 3: All requests ON → round robin fairness");
        req = 4'b1111;
        repeat(12) @(posedge clk);

        // ---------------------------------------------------------
        // TEST 4: No requests
        // ---------------------------------------------------------
        $display("\nTEST 4: No requests");
        req = 4'b0000;
        repeat(4) @(posedge clk);

        // ---------------------------------------------------------
        // TEST 5: Random request pattern
        // ---------------------------------------------------------
        $display("\nTEST 5: Random request patterns");
        repeat(10) begin
            req = $random % 16;
            @(posedge clk);
        end

        #20;
        $finish;
    end

endmodule
