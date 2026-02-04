// Code your design here
module graycoder(clk,bin_in,gray_out);
  output reg [3:0]gray_out;
  input [3:0]bin_in;
  input clk;
  always@(posedge clk)begin
    gray_out[3]=bin_in[3];//msb of binary=msb of gray
    gray_out[2]=bin_in[3]^bin_in[2];//xor of 3rd and 2nd binary
    gray_out[1]=bin_in[2]^bin_in[1];//xor of 2rd and 1st binary
    gray_out[0]=bin_in[1]^bin_in[0];//xor of 1st and 0th binary
  end
endmodule
