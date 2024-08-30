`timescale 1ns/1ps
module tb_fifo;
reg winc,wclk,wrst_n,rinc,rclk,rrst_n;
reg [7:0] wdata;
wire wfull, rempty;
wire [7:0] rdata;

fifo1 #(8,4) uut (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .wdata(wdata),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rdata(rdata),
        .wfull(wfull),
        .rempty(rempty));

    // Clock generation
    initial begin
        wclk = 0;
        forever begin
            #10 wclk = ~wclk;  // 100MHz clock
        end
    end

    initial begin
        rclk = 0;
        forever begin
            #5 rclk = ~rclk;  // 50MHz clock
        end
    end
initial begin
wrst_n = 0;
rrst_n =0;
winc =0;
rinc =0;
//loading the data
#10 winc = 1;
wdata = 8'd10;
#10 winc =0;
#10 rinc =1 ;
#10 rinc =0;
end
initial begin
#100 $finish;
end
initial begin
 $monitor($time, " wclk=%b, rclk=%b, wrst=%b, rrst=%b, winc=%b, rinc=%b, data_in=%d, data_out=%d, full=%b, empty=%b", 
                wclk, rclk, wrst_n, rrst_n, winc, rinc, wdata, rdata, wfull, rempty);
end
endmodule