module u_xmit#(parameter DATA_WIDTH=8, parameter PARITY_ENABLE=0)(
    input baud_clk,sys_rst,
    input xmitH,
    input [DATA_WIDTH-1:0]xmit_dataH,
    output reg uart_xmit_dataH
  );
  
  reg [2:0]state;
  reg [$clog2(DATA_WIDTH)-1:0]data_index;
  
  reg [3:0]delay;
  
  localparam sIdeal=3'd0,
             sStart=3'd1,
             sData=3'd2,
             sParity=3'd3,
             sStop=3'd4;
     
  always@(posedge baud_clk or posedge sys_rst)
    begin
      if(sys_rst)
        begin
          uart_xmit_dataH <= 1;
          state <= sIdeal;
          data_index <= 0;
          delay <= 0;
        end
      else
        begin
          case(state)
            sIdeal:
              begin
                if(xmitH)
                  begin
                    state <= sStart;
                    uart_xmit_dataH <= 1;
                  end
              end
            sStart:
              begin
                uart_xmit_dataH <= 0;
                if(delay==15)
                    begin
                        state <= sData;
                        delay <= 0;
                    end
                else
                    delay <= delay + 1;
              end
            sData:
              begin
                if(data_index != (DATA_WIDTH-1))
                  begin
                    uart_xmit_dataH <= xmit_dataH[data_index];
                    delay <= delay + 1;
                    if(delay==15)
                        begin
                            data_index <= data_index + 1;
                            delay <= 0;
                        end
                  end
                else
                  begin
                    if(delay==15)
                    begin
                        data_index <= 0;
                        delay <= 0;
                        if(PARITY_ENABLE)
                            begin
                                state <= sParity;
                            end
                        else
                            begin
                                state <= sStop;
                            end
                    end
                    else
                        begin
                            uart_xmit_dataH <= xmit_dataH[data_index];
                            delay <= delay + 1;
                        end
                  end
              end
            sParity:
              begin
                if(delay==15)
                    begin
                        state <= sStop;
                        delay <= 0;
                    end
                 else
                    begin
                        uart_xmit_dataH <= ^xmit_dataH;
                        delay <= delay + 1;
                    end
              end
            sStop:
              begin
                if(delay==15)
                    begin
                        state <= sIdeal;
                        delay <= 0;
                    end
                else
                    begin
                        uart_xmit_dataH <= 1;
                        delay <= delay + 1;
                    end  
              end
          endcase
        end
    end
    
endmodule

