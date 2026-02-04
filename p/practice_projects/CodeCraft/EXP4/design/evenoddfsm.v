// Code your design here
module evenoddfsm(clk,reset,in_valid,data_in,even,odd);
  output reg even,odd;
  input clk,reset,in_valid;
  input [7:0]data_in;
  
  always @(posedge clk or posedge reset) begin
        if (reset) begin
            even <= 0;
            odd  <= 0;
        end
        else if (in_valid) begin
          if (data_in[0] == 1'b0) begin//if lsb=0 then it is a even number
                even <= 1;
                odd  <= 0;
            end
            else begin//if lsb is one then its a odd number
                even <= 0;
                odd  <= 1;
            end
        end
  end


endmodule
