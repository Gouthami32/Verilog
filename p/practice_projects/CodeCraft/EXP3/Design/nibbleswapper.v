// Code your design here
module nibbleswapper(clk,reset,out,in,swap_en);
  output reg [7:0]out;
  input [7:0]in;
  input swap_en,reset,clk;
  always@(posedge clk or posedge reset)
    begin
      if(reset)//if reset ouput will be set to 0 automattically
        out<=0;
      else begin
        if(swap_en)//if swap signal enabled
        out={in[3:0],in[7:4]};//here concatination operator is used to shift the first 4 and last 4 bits
      end
    end
endmodule
  
