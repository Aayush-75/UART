module u_baud#(parameter SYS_CLK_FREQ = 32, parameter BAUD_RATE = 1, parameter DATA_WIDTH=8, parameter PARITY_ENABLE=0)
  (
    input sys_clk,
    input rst,
    output reg baud_clk
  );
  
  integer count;
  
  localparam denominator = BAUD_RATE*16*2 ;
  localparam quotient  = SYS_CLK_FREQ / denominator;
  localparam remainder = SYS_CLK_FREQ % denominator;
  localparam result = (remainder >= (denominator >> 1)) ? quotient + 1 : quotient;
  
  always@(posedge sys_clk or posedge rst)
  begin
    if(rst)
        begin
            baud_clk <= 0;
            count <= result-1;
        end
    else
        begin
            if(count==0)
                begin
                    baud_clk <= ~baud_clk;
                    count <= result-1;
                end
            else
                begin
                    count <= count - 1;
                end
        end
  end
   
endmodule


