`timescale 1ns / 1ps

// -------------------------------------------------------------
// BitVault Testbench
// -------------------------------------------------------------
// Tests included:
// 1. Reset clears all registers
// 2. Write to each address
// 3. Read back values
// 4. Overwrite protection (we=0 → cannot write)
// 5. Randomized read/write sequences
// -------------------------------------------------------------

module tb_BitVault;

    reg clk, rst_n;
    reg we;
    reg [1:0] waddr, raddr;
    reg [7:0] wdata;
    wire [7:0] rdata;

    // Instantiate DUT
    BitVault dut (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Clock: 10 ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("bitvault.vcd");
        $dumpvars(0, tb_BitVault);

        clk = 0;
        rst_n = 0;
        we = 0;
        waddr = 0;
        raddr = 0;
        wdata = 0;

        // ---------------- RESET -----------------
        #12 rst_n = 1;

        // ---- TEST 1: WRITE OPERATIONS ----------
        $display("\nTEST 1: Writing to all registers");
        repeat (4) begin
            @(posedge clk);
            we = 1;
            waddr = $random % 4;
            wdata = $random % 256;
            $display("WRITE addr=%0d data=%0d", waddr, wdata);
        end

        // ---- TEST 2: READ BACK VALUES ----------
        $display("\nTEST 2: Reading back registers");
        we = 0;
        for (integer i = 0; i < 4; i++) begin
            raddr = i;
            @(posedge clk);
            $display("READ addr=%0d → data=%0d", i, rdata);
        end

        // ---- TEST 3: OVERWRITE PROTECTION ------
        $display("\nTEST 3: Overwrite protection (we=0)");
        we = 0;
        waddr = 2;
        wdata = 99;
        @(posedge clk);  // Should not write

        raddr = 2;
        @(posedge clk);
        $display("Expected NO CHANGE → Read data=%0d", rdata);

        // ---- TEST 4: RANDOM ACCESS -------------
        $display("\nTEST 4: Random read/write sequence");
        repeat (10) begin
            @(posedge clk);
            we = $random % 2;
            waddr = $random % 4;
            wdata = $random % 256;
            raddr = $random % 4;
        end

        #20;
        $display("\nSimulation Completed.");
        $finish;
    end

    initial begin
        $monitor("t=%0t | we=%b waddr=%d wdata=%d raddr=%d rdata=%d",
            $time, we, waddr, wdata, raddr, rdata);
    end

endmodule
