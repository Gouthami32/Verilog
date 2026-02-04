// Code your design here
module edgehighlighter(clk,rst_n,in_sig,rise_pulse,fall_pulse);
  output reg rise_pulse,fall_pulse;//outputs
  input clk,rst_n,in_sig;//inputs
  reg prev;//temporary register for stoeing previous state
  always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)begin
        prev<=1'b0;
        rise_pulse<=1'b0;
        fall_pulse<=1'b0;end
      else
       begin
  rise_pulse<= in_sig&~prev;//rise_pulse will be 1 if previouse signal is 0 and present signal is 1
  fall_pulse <=~in_sig&prev; //false_pulse will be 1 if previous signal is 1 and present signal is 1
         prev<=in_sig;end
    end

endmodule
