// Code your design here
module PulseTracer #(parameter FILTER_LEN=3)(clk,rst_n,noisy_in,pulse_out);
output reg pulse_out;//output which goes high when there is noisy stream
input clk,rst_n,noisy_in;
reg [$clog2(FILTER_LEN):0]counter;//for counting no of clock pulses consecutively going high
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)begin//if reset=1 then the ckt is reset
        counter<=0;
        pulse_out<=0;
    end
       else
        begin
       pulse_out<=0;
   
          if(noisy_in)//if input is detected
        begin
          if(counter<FILTER_LEN)
          counter<=counter+1;//counter is incremented until no of ones are equal to filter_len
        
      if (counter == FILTER_LEN-1) begin //if counter equals to filter len then we got consective ones and noisy stream detected so that output is one
              pulse_out <= 1;  
             
      end
      end
      else 
       begin
        counter <= 0;  
        filtered  <= 0;
      end
      end
      end
endmodule
