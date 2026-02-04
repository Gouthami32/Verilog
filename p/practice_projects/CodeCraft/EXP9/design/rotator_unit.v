// Code your design here
module rotatorunit(clk,rst_n,enable,load,dir,data_in,data_out);
  output reg [7:0]data_out;
  input clk,rst_n,enable,load,dir;
  input [7:0]data_in;//input data
  always@(posedge clk)
    begin
      if(!rst_n)//if reset=0 then output=0
        data_out<=0;
      else
        begin
          if(enable)begin//if enable =1 operation starts
            if(load)//if load=1 input will be taken
              data_out<=data_in;
              else begin
                if(dir)//if dir=1 shift right
                  data_out<={data_out[0],data_out[7:1]};
                else//if dir=0 shift left
                  data_out<={data_out[6:0],data_out[7]};
                
                  end
              end
        end
    end
endmodule
