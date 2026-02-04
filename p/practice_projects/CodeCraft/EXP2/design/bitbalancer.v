// Code your design here
module bitbalancer(clk,reset,in,count);
  output reg [3:0]count;//output which represents no of ones
  input [7:0]in;//input bit stream
  input clk,reset;
  integer i;
  reg[3:0]temp;//vaiable which temporaily counts no of ones
  always@(posedge clk or posedge reset)
    begin
      if(reset)begin
        count<=0;//if reset is high then the bit balancer will be set to 0
        temp<=0;end
      else begin
     temp<=0;
        for (i=0;i<8;i=i+1) //this line of code will make sure it loops around the 8 bits in the input stream
        begin
          if(in[i]) begin//if in any index i input 1 is detected then temp will be incremented
        temp=temp+1;
         end
        
      end
        count=temp;//finally after looping through 8 bits ouput is assigned to count 
      end
   
    end
  
endmodule
