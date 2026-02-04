// Code your design here
module debouncerlite #(parameter N=3)(clk,rst_n,noisy_in,debounced);
  output reg debounced;
  input clk,rst_n,noisy_in;
  reg [N-1:0]shift;
  always@(posedge clk)
    begin
      if(rst_n==0)//active low reset
        debounced<=0;
      else begin
        shift<={shift[N-2:0],noisy_in};//input bits are shifting 
        if (shift == {N{1'b1}})//if 1's came consecutively N times then debouncded will be 1
          debounced<=1;
        else
          debounced<=0;
      end
        
    end
endmodule
