`timescale 1ns/1ps
module tb#(parameter WORD_LEN = 8)();
    reg clk;
    reg sys_rst;
    
    reg xmitH;
    reg [7:0]xmit_dataH;
    wire uart_xmit_dataH;
    wire xmit_active;
    wire xmit_donH;
    
    wire baud_clk;
    
    reg uart_rec_dataH;
    wire [7:0]rec_dataH;
    wire rec_busy;
    
    integer i=0,j=0,k=0;
    
    integer rcases=0,rpass=0,rfail=0;
    integer tcases=0,tpass=0,tfail=0;
    
    reg check_rec_busy=0,check_rec_dataH=0;
    
    baud_gen #(115200,10_000_000,8) dd1(clk,sys_rst,baud_clk);
    uart_xmit dut1(baud_clk,xmit_dataH,xmitH,sys_rst,uart_xmit_dataH,xmit_active,xmit_donH);
    //baud_gen #(115200,10_000_000,8) dd2(clk,sys_rst,baud_clk);
    uart_rec dut2(baud_clk,sys_rst,uart_rec_dataH,rec_dataH,rec_busy); 

    initial
        begin
            clk = 0;
            forever #50 clk = ~clk;
        end
    
    task delay();
        begin
            //$display("||||||||||||||||||%0d||||||||||||||||||||||",k);
            //$display("%d",dut.data_index);
            //k=k+1;
            repeat(16)
                begin
                    @(posedge baud_clk);
                    //$display("VAL =========== %0d time: %0dth ",uart_rec_dataH,dut.delay);
//                    $display("State: %d",dut2.state);
                    //j=j+1;
                end
                //j=0;
        end
    endtask

    reg [WORD_LEN-1:0]ri;
    
    task reciver;
        input [WORD_LEN-1:0]ri;
        begin
            rcases = rcases + 1;
            uart_rec_dataH = 0;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            @(posedge baud_clk);
////            $display("State: %d",dut2.state);
            if(rec_busy) 
                check_rec_busy=1; 
            delay();
            uart_rec_dataH = ri[0];
            delay();   
            uart_rec_dataH = ri[1];
            delay(); 
            uart_rec_dataH = ri[2];
            delay(); 
            uart_rec_dataH = ri[3];
            delay(); 
            uart_rec_dataH = ri[4];
            delay(); 
            uart_rec_dataH = ri[5];
            delay(); 
            uart_rec_dataH = ri[6];
            delay(); 
            uart_rec_dataH = ri[7];
            delay(); 
            uart_rec_dataH = 1;
            delay();
            if(rec_dataH==ri) 
                check_rec_dataH=1;
            if(check_rec_busy && check_rec_dataH)
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rpass = rpass + 1; 
//                    $display("[%0d] CASE PASS",rpass);
//                    $display("EXPECTED DATA = [%0d]",ri);
//                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end
            else
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rfail = rfail + 1;
                    $display("[%0d] CASE FAIL",rcases);
                    $display("EXPECTED DATA = [%0d]",ri);
                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end    
        end
    endtask
    
    task reciver_start_sample_glitch;
        input [WORD_LEN-1:0]ri;
        begin
            rcases = rcases + 1;
            uart_rec_dataH = 0;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
            uart_rec_dataH = 1;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
            repeat(3)
                @(posedge baud_clk);
            uart_rec_dataH = 0;
            @(posedge baud_clk);
            uart_rec_dataH = 1;
            repeat(9)
                @(posedge baud_clk);             
//            @(posedge baud_clk);
////            $display("State: %d",dut2.state);
            if(rec_busy) 
                check_rec_busy=1; 
//            delay();
            uart_rec_dataH = ri[0];
            delay();   
            uart_rec_dataH = ri[1];
            delay(); 
            uart_rec_dataH = ri[2];
            delay(); 
            uart_rec_dataH = ri[3];
            delay(); 
            uart_rec_dataH = ri[4];
            delay(); 
            uart_rec_dataH = ri[5];
            delay(); 
            uart_rec_dataH = ri[6];
            delay(); 
            uart_rec_dataH = ri[7];
            delay(); 
            uart_rec_dataH = 1;
            delay();
            if(rec_dataH==ri) 
                check_rec_dataH=1;
            if(check_rec_busy && check_rec_dataH)
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rpass = rpass + 1; 
//                    $display("[%0d] CASE PASS",rpass);
//                    $display("EXPECTED DATA = [%0d]",ri);
//                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end
            else
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rfail = rfail + 1;
                    $display("[%0d] CASE FAIL",rcases);
                    $display("EXPECTED DATA = [%0d]",ri);
                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end    
        end
    endtask
    
    task reciver_stop_not;
        input [WORD_LEN-1:0]ri;
        begin
            rcases = rcases + 1;
            uart_rec_dataH = 0;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            if(rec_busy) 
                check_rec_busy=1; 
            delay();
            uart_rec_dataH = ri[0];
            delay();   
            uart_rec_dataH = ri[1];
            delay(); 
            uart_rec_dataH = ri[2];
            delay(); 
            uart_rec_dataH = ri[3];
            delay(); 
            uart_rec_dataH = ri[4];
            delay(); 
            uart_rec_dataH = ri[5];
            delay(); 
            uart_rec_dataH = ri[6];
            delay(); 
            uart_rec_dataH = ri[7];
            delay(); 
            uart_rec_dataH = 0;
            delay();
            if(rec_dataH==8'b01111111) 
                check_rec_dataH=1;
            if(check_rec_busy && check_rec_dataH)
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rpass = rpass + 1; 
//                    $display("[%0d] CASE PASS",rpass);
//                    $display("EXPECTED DATA = [%0d]",ri);
//                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end
            else
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rfail = rfail + 1;
                    $display("[%0d] CASE FAIL",rcases);
                    $display("EXPECTED DATA = [%0d]",ri);
                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end    
        end
    endtask
    
    task reciver_rst_btwn;
        input [WORD_LEN-1:0]ri;
        begin
            rcases = rcases + 1;
            uart_rec_dataH = 0;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            if(rec_busy) 
                check_rec_busy=1; 
            delay();
            uart_rec_dataH = ri[0];
            delay();   
            uart_rec_dataH = ri[1];
            delay(); 
            uart_rec_dataH = ri[2];
            delay(); 
            uart_rec_dataH = ri[3];
            delay(); 
            uart_rec_dataH = ri[4];
            delay(); 
            uart_rec_dataH = ri[5];
            delay(); 
            sys_rst=0;
            @(negedge clk);
            @(posedge clk);
            @(posedge clk);
            if(rec_dataH==8'b00000000) 
                check_rec_dataH=1;
            if(check_rec_busy && check_rec_dataH)
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rpass = rpass + 1; 
                    sys_rst=1;
                    @(posedge baud_clk);
                    @(posedge baud_clk);
//                    $display("[%0d] CASE PASS",rpass);
//                    $display("EXPECTED DATA = [%0d]",ri);
//                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end
            else
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rfail = rfail + 1;
                    $display("[%0d] CASE FAIL",rcases);
                    $display("EXPECTED DATA = [%0d]",ri);
                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                    sys_rst=1;
                    @(posedge baud_clk);
                    @(posedge baud_clk);
                end    
        end
    endtask
    
    task reciver_start_glitch;
        input [WORD_LEN-1:0]ri;
        begin
            rcases = rcases + 1;
            uart_rec_dataH = 0;
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            @(posedge baud_clk);
//            $display("State: %d",dut2.state);
            if(rec_busy) 
                check_rec_busy=1; 
            uart_rec_dataH=1;
            delay();
            uart_rec_dataH = ri[0];
            delay();   
            uart_rec_dataH = ri[1];
            delay(); 
            uart_rec_dataH = ri[2];
            delay(); 
            uart_rec_dataH = ri[3];
            delay(); 
            uart_rec_dataH = ri[4];
            delay(); 
            uart_rec_dataH = ri[5];
            delay(); 
            uart_rec_dataH = ri[6];
            delay(); 
            uart_rec_dataH = ri[7];
            delay(); 
            uart_rec_dataH = 1;
            delay();
            if(rec_dataH==8'b0010_0110) 
                check_rec_dataH=1;
            if(check_rec_busy && check_rec_dataH)
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rpass = rpass + 1; 
//                    $display("[%0d] CASE PASS",rpass);
//                    $display("EXPECTED DATA = [%0d]",ri);
//                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end
            else
                begin
                    check_rec_busy=0;
                    check_rec_dataH=0;
                    rfail = rfail + 1;
                    $display("[%0d] CASE FAIL",rcases);
                    $display("EXPECTED DATA = [%0d]",ri);
                    $display("RECEVED  DATA = [%0d]",rec_dataH);
                end    
        end
    endtask
    
    reg tx_start_check=0;
    
    task t_s_delay();
        begin
//            $display("CASE no [%0d]",cases);
            i=0;
            repeat(16)
                begin
                    @(posedge baud_clk);
                    if(uart_xmit_dataH==0)
                        begin
                            i=i+1;
//                            $display("START I is:[%0d]",i);
                        end
                end
                if(i==16)
                    begin
                        tx_start_check=1;
                        i=0;
                    end
        end
    endtask
    
    task t_d_delay;
        begin
            i=0;
            repeat(16)
                begin
                    @(posedge baud_clk);
                    if(uart_xmit_dataH==xmit_dataH[j])
                        begin
                            i=i+1;
//                            $display("DATA time [%0d] i is: [%0d]",j,i);
                        end
                        
                end
                j = j + 1;
                if(i==16)
                    begin
                        k=k+1;
                        i=0;
                    end
        end
    endtask
    
    reg [WORD_LEN-1:0]ext;
        
    task t_d_delay_extended;
        begin
            i=0;
            repeat(16)
                begin
                    @(posedge baud_clk);
                    if(uart_xmit_dataH==ext[j])
                        begin
                            i=i+1;
//                            $display("DATA time [%0d] i is: [%0d]",j,i);
                        end
                        
                end
                j = j + 1;
                if(i==16)
                    begin
                        k=k+1;
                        i=0;
                    end
        end
    endtask
    
    reg tx_stop_check=0;
    
    task t_stop_delay();
        begin
            i=0;
            repeat(16)
                begin
                    @(posedge baud_clk);
                    if(uart_xmit_dataH==1)
                        begin
                            i=i+1;
//                            $display("STOP i is: [%0d]",i);
                        end
                end
                if(i==16)
                    begin
                        tx_stop_check=1;
                        i=0;
                    end
        end
    endtask
    
    reg [WORD_LEN-1:0]t_data;
    
    task transmitter;
        input [WORD_LEN-1:0]t_data;
        begin
            tcases = tcases + 1;
            xmitH = 1;
            xmit_dataH = t_data;
//            $display("STATE BEFORE ANYTHING: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            //@(posedge baud_clk);
            //$display("STATE: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            t_s_delay();
//            $display("STATE AFTER START DELAY: %d",dut1.state);
            xmitH = 0;
            j=0;
            k=0;
            repeat(8)
                t_d_delay();
//            $display("STATE AFTER DATA DELAY: %d",dut1.state);   
            t_stop_delay();
//            $display("STATE AFTER STOP DELAY: %d",dut1.state);
            //$display("DATA CASES PASSING: %d",k);
            if((tx_start_check) && (k==8) && (tx_stop_check))
                begin
                    tpass = tpass + 1;
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0;
                end
            else
                begin
                    tfail = tfail + 1;
                    $display("TX FAIL CASE [%0d]",tcases);
                    if(!tx_start_check)
                        $display("START CHECK FAIL");
                    if(k!=8)
                        $display("DATA CHECK FAIL");
                    if(!tx_stop_check)
                        $display("STOP CHECK FAIL"); 
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0; 
                end
            @(posedge baud_clk);
        end
    endtask
    
    task transmitter_rst_btwn;
        input [WORD_LEN-1:0]t_data;
        begin
            tcases = tcases + 1;
            xmitH = 1;
            xmit_dataH = t_data;
//            $display("STATE BEFORE ANYTHING: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            //@(posedge baud_clk);
            //$display("STATE: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            t_s_delay();
//            $display("STATE AFTER START DELAY: %d",dut1.state);
            xmitH = 0;
            j=0;
            k=0;
            repeat(8)
                t_d_delay();
//            $display("STATE AFTER DATA DELAY: %d",dut1.state);   
            sys_rst = 0;
            #200;
            sys_rst = 1;
            #200;
//            $display("STATE AFTER STOP DELAY: %d",dut1.state);
            //$display("DATA CASES PASSING: %d",k);
            if((tx_start_check) && (k==8) && (!tx_stop_check))
                begin
                    tpass = tpass + 1;
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0;
                end
            else
                begin
                    tfail = tfail + 1;
                    $display("TX FAIL CASE [%0d]",tcases);
                    if(!tx_start_check)
                        $display("START CHECK FAIL");
                    if(k!=8)
                        $display("DATA CHECK FAIL");
                    if(!tx_stop_check)
                        $display("STOP CHECK FAIL"); 
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0; 
                end
            @(posedge baud_clk);
            @(posedge baud_clk);
            $display("STATE AFTER ALL: %d",dut1.state);
        end
    endtask
    
    task transmitter_data_changing;
        input [WORD_LEN-1:0]t_data;
        begin
            tcases = tcases + 1;
            xmitH = 1;
            xmit_dataH = t_data;
            ext = t_data;
//            $display("STATE BEFORE ANYTHING: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            //@(posedge baud_clk);
            //$display("STATE: %d",dut1.state);
            //$display("DATA_OUT: %d",uart_xmit_dataH);
            t_s_delay();
//            $display("STATE AFTER START DELAY: %d",dut1.state);
            xmitH = 0;
            j=0;
            k=0;
            repeat(8)
                begin
                    t_d_delay_extended();
                    xmit_dataH = 8'b1111_1111;
                end
//            $display("STATE AFTER DATA DELAY: %d",dut1.state);   
            t_stop_delay();
//            $display("STATE AFTER STOP DELAY: %d",dut1.state);
            //$display("DATA CASES PASSING: %d",k);
            if((tx_start_check) && (k==8) && (tx_stop_check))
                begin
                    tpass = tpass + 1;
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0;
                end
            else
                begin
                    tfail = tfail + 1;
                    $display("TX FAIL CASE [%0d]",tcases);
                    if(!tx_start_check)
                        $display("START CHECK FAIL");
                    if(k!=8)
                        $display("DATA CHECK FAIL");
                    if(!tx_stop_check)
                        $display("STOP CHECK FAIL"); 
                    tx_start_check=0;
                    tx_stop_check=0;
                    k=0;
                    j=0; 
                end
            @(posedge baud_clk);
        end
    endtask
    
    initial
        begin
            #200;
            sys_rst = 0;
            #200;
            sys_rst = 1;
            #200;
            sys_rst = 0;
            #200;
            sys_rst = 1;
            @(posedge baud_clk);
            reciver(8'b10101010);
            reciver(8'b00000010);
            reciver(8'b01010011);
            reciver(8'b11111111);
            //4
            reciver(8'b00000000);
            reciver(8'b11100000);
            reciver(8'b00111000);
            reciver(8'b00001111);
            //8
            reciver(8'b11110000);
            reciver(8'b01111110);
            reciver(8'b10000001);
            reciver(8'b01100110);
            //12
            reciver(8'b11000011);
            reciver(8'b00100110);
            reciver(8'b10110111);
            reciver(8'b01111111);
            //16
            reciver(8'b11111110);
            reciver(8'b10101010);
            reciver(8'b00000010);
            reciver(8'b01010011);
            //20
            reciver(8'b11111111);
            reciver(8'b00000000);
            reciver(8'b11100000);
            reciver(8'b00111000);
            //24
            reciver(8'b00001111);
            reciver(8'b11110000);
            reciver(8'b01111110);
            reciver(8'b10000001);
            //28
            reciver(8'b01100110);
            reciver(8'b11000011);
            reciver(8'b00100110);
            reciver(8'b10110111);
            //32
            reciver(8'b01111111);            
            reciver(8'b11000011);
            reciver(8'b00100110);
            reciver(8'b10110111);
            //36
            reciver(8'b01111111);
            reciver_stop_not(8'b00110011);
            reciver_rst_btwn(8'b11110000);
            reciver(8'b010010001);
            //40
            #200;
            sys_rst = 0;
            #200;
            sys_rst = 1;
            @(posedge baud_clk);
            reciver(8'b11000011);
            //41
            reciver(8'b00100110);
            reciver_start_sample_glitch(8'b00100110);
            //43
            reciver_start_glitch(8'b01111111);
            //44
            reciver(8'b10110111);
            //45
            $display("||||||||||||||||||RX||||||||||||||||");
            $display("TOTAL [%0d]",rcases);
            $display("PASS  [%0d]",rpass);
            $display("FAIL  [%0d]",rfail);
            
            transmitter(8'b10101010);
            transmitter(8'b00000010);
            transmitter(8'b01010011);
            transmitter(8'b11111111);
            //4
            transmitter(8'b00000000);
            transmitter(8'b11100000);
            transmitter(8'b00111000);
            transmitter(8'b00001111);
            //8
            transmitter(8'b11110000);
            transmitter(8'b01111110);
            transmitter(8'b10000001);
            transmitter(8'b01100110);
            //12
            transmitter(8'b11000011);
            transmitter(8'b00100110);
            transmitter(8'b10110111);
            transmitter(8'b01111111);
            //16
            transmitter(8'b11111110);
            transmitter(8'b10101010);
            transmitter(8'b00000010);
            transmitter(8'b01010011);
            //20
            transmitter(8'b11111111);
            transmitter(8'b00000000);
            transmitter(8'b11100000);
            transmitter(8'b00111000);
            //24
            transmitter(8'b00001111);
            transmitter(8'b11110000);
            transmitter(8'b01111110);
            transmitter(8'b10000001);
            //28
            transmitter(8'b01100110);
            transmitter(8'b11000011);
            transmitter(8'b00100110);
            transmitter(8'b10110111);
            //32
            transmitter(8'b01111111);            
            transmitter(8'b11000011);
            transmitter(8'b00100110);
            transmitter(8'b10110111);
            //36
            transmitter_rst_btwn(8'b10000001);
            //37
            transmitter(8'b01111111);            
            transmitter(8'b11000011);
            transmitter(8'b00100110);
            transmitter_data_changing(8'b11110000);
            //41
            transmitter(8'b10110111);
            transmitter(8'b00000000);
            transmitter(8'b11100000);
            transmitter(8'b00111000);
            //45
            $display("||||||||||||||||||TX||||||||||||||||");
            $display("TOTAL [%0d]",tcases);
            $display("PASS  [%0d]",tpass);
            $display("FAIL  [%0d]",tfail);
           
            $display("||||||||||||||||||TOTAL||||||||||||||||");
            $display("TOTAL [%0d]",tcases+rcases);
            $display("PASS  [%0d]",tpass+rpass);
            $display("FAIL  [%0d]",tfail+rfail); 
        end

endmodule