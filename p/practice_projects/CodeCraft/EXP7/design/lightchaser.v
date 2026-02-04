
module LightChaser #(
    parameter N=8  
)( clk,rst_n,enable,leds
);
   input clk,rst_n,enable;     
  output reg [N-1:0]leds;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
           
            leds <= 8'b00000001;//if reset enabled then lsb led glows
        end else if (enable) begin
           
          leds <= {leds[N-2:0], leds[N-1]};//if enable is enabked the leds will cyclically glow
        end
    end
