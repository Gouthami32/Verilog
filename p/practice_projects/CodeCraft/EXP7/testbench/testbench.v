`timescale 1ns/1ps

module tb_LightChaser;

   
    reg clk;
    reg rst_n;
    reg enable;
    wire [7:0] leds;

   
    LightChaser uut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .leds(leds)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
         $dumpfile("LightChaser_tb.vcd");
        $dumpvars(0, tb_LightChaser);   
        rst_n=0;
        enable=0;
        #20;        
        rst_n=1;
        enable=1;
        #200;
        enable=0;
        #50;
         enable=1;
        #100;
       $display("Simulation Finished");
        $stop;
    end

    initial begin
        $monitor("t=%0t | leds=%b | rst_n=%b | enable=%b", $time, leds, rst_n, enable);
    end

endmodule
