module uart#(parameter DATA_WIDTH=8, parameter PARITY_ENABLE=0)(
  input clk,rst,
  input t_data,
  input [DATA_WIDTH-1:0]t_data1,
  output [DATA_WIDTH-1:0]r_data1,
  output t_o_data,
  output rec_busy
  );
  
  wire clk_t;
  wire clk_r;
  
  u_xmit u2(clk_t,rst,t_data,t_data1,t_o_data);
  u_rec u4(clk_r,rst,t_o_data,r_data1,rec_busy);
  u_baud u1(clk,t_data,clk_t);
  u_baud u3(clk,t_o_data,clk_r);
    
endmodule
