`timescale 1ns/1ps

module tb_ModeMux;

    reg clk, rst;
    reg mode;
    reg [3:0] req;
    reg [7:0] din [3:0];
    wire [7:0] data_out;
    wire [3:0] grant;

    ModeMux dut (
        .clk(clk), .rst(rst),
        .mode(mode),
        .req(req),
        .data_in(din),
        .data_out(data_out),
        .grant(grant)
    );

    always #5 clk = ~clk;

    task print_state;
        $display("t=%0t | mode=%b req=%b | grant=%b data_out=%h", 
                 $time, mode, req, grant, data_out);
    endtask

    initial begin
        $dumpfile("modemux.vcd");
        $dumpvars(0, tb_ModeMux);

        clk = 0; rst = 1;
        din[0]=8'hA1; din[1]=8'hB2; din[2]=8'hC3; din[3]=8'hD4;
        req = 0; mode = 0;
        @(posedge clk); rst = 0;

        // ---------------- FIXED PRIORITY MODE ----------------
        $display("\n=== FIXED PRIORITY ===");
        mode = 0;

        req = 4'b1111; @(posedge clk); print_state();
        req = 4'b0110; @(posedge clk); print_state();
        req = 4'b0001; @(posedge clk); print_state();

        // ---------------- ROUND ROBIN MODE -------------------
        $display("\n=== ROUND ROBIN ===");
        mode = 1;

        req = 4'b1111;
        repeat(6) begin
            @(posedge clk); print_state();
        end

        // Random tests
        repeat(5) begin
            req = $random;
            @(posedge clk); print_state();
        end

        $finish;
    end

endmodule
