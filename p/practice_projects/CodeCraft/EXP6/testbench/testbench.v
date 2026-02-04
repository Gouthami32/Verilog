`timescale 1ns/1ps

module tb_debouncerlite;

    parameter N = 3;

   
    reg clk;
    reg rst_n;
    reg noisy_in;
    wire debounced;

    integer i;

    
    debouncerlite #(N) dut (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_in(noisy_in),
        .debounced(debounced)
    );

    initial clk = 0;
    always #5 clk = ~clk;

  
    initial begin
       
        rst_n = 0;
        noisy_in = 0;
        #20;
        rst_n = 1;

        $display("Starting Debouncer Test...");

        // CASE 1: Short HIGH glitch (<N)
        noisy_in = 1; #10;
        noisy_in = 0; #30;

        // CASE 2: Stable HIGH (>=N)
        for (i = 0; i < N; i = i + 1) begin
            noisy_in = 1; #10;
        end
        noisy_in = 0; #20;

        // CASE 3: Stable LOW (>=N)
        for (i = 0; i < N; i = i + 1) begin
            noisy_in = 0; #10;
        end

        // CASE 4: Rapid toggle
        for (i = 0; i < 4; i = i + 1) begin
            noisy_in = ~noisy_in; #10;
        end

        // CASE 5: Long stable HIGH
        noisy_in = 1; #(N*10 + 20);

        // CASE 6: Long stable LOW
        noisy_in = 0; #(N*10 + 20);

        $display("Test Finished");
        $stop;
    end
    initial begin
        $monitor("t=%0t | noisy_in=%b | debounced=%b", $time, noisy_in, debounced);
    end

endmodule
