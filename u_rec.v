module u_rec#(parameter DATA_WIDTH=8, parameter PARITY_ENABLE=0)(
    input baud_clk,sys_rst,
    input uart_rec_dataH,
    output reg [DATA_WIDTH-1:0]rec_dataH,
    output reg rec_busy
  );
  
  reg [1:0]state;
  reg [$clog2(DATA_WIDTH)-1:0]data_index;
  
  reg [DATA_WIDTH-1:0]isr;
  
  reg [3:0]delay;
  reg ok=0;
  
  localparam sIdeal=2'd0,
             sStart=2'd1,
             sParity=2'd2,
             sStop=2'd3;
          
  always@(posedge baud_clk or negedge sys_rst)
    begin
      if(!sys_rst)
        begin
          state <= sIdeal;
          data_index <= 0;
          rec_busy <= 0;
          delay <= 0;
          rec_dataH <= 1;
        end
      else
        begin
          case(state)
            sIdeal:
              begin
                if(!rec_busy && !uart_rec_dataH)
                  begin
                    delay <= delay + 1;
                    if(delay==15)
                        begin
                            state <= sStart;
                            delay <= 0;
                        end
                  end
              end
            sStart:
              begin
                rec_busy <= 1;
                delay <= delay + 1;
                if(delay == 7)
                begin
                    isr[data_index] <= uart_rec_dataH;
                end
                if(delay == 15)
                    begin
                        data_index <= data_index + 1;
                        delay <= 0;
                    end
                if(data_index == DATA_WIDTH-1)
                  begin
                    if(delay==7)
                        isr[data_index] <= uart_rec_dataH;
                    if(delay==15)
                    begin
                        delay <= 0;
                        data_index <= 0;
                    if(PARITY_ENABLE)
                      begin
                        state <= sParity;
                      end
                    else
                      begin
                        state <= sStop;
                      end
                      end
                  end
              end
            sParity:
              begin
                if(uart_rec_dataH == ^isr)
                  begin
                    state <= sStop;
                  end
              end
            sStop:
              begin
                delay <= delay + 1;
                if(delay <=7)
                begin
                    if(uart_rec_dataH)
                        begin
                            ok<=1;
                            rec_busy <= 0;
                            rec_dataH <= isr;
                        end
                     else
                        begin
                            rec_busy <= 0;
                            ok<=1;
                        end
                end
                if(delay == 15 && ok==1)
                    begin
                        state <= sIdeal;
                        ok <= 0;
                        delay <= 0;
                    end
              end
          endcase
        end
    end
    
endmodule

