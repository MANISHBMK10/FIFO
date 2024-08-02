module fifomem #(parameter DATASIZE = 8, // Memory data word width
                 parameter ADDRSIZE = 4) // Number of mem address bits
    (output reg [DATASIZE-1:0] rdata,
     input [DATASIZE-1:0] wdata,
     input [ADDRSIZE-1:0] waddr, raddr,
     input wclken, wfull, wclk,rclk, rempty, rclken);
    
 // RTL Verilog memory model
     localparam DEPTH = 1<<ADDRSIZE;
     reg [DATASIZE-1:0] mem [0:DEPTH-1];
   // reg rdata_val;
   //assign rdata = mem[raddr];
    
	always @(posedge wclk)
         if (wclken && !wfull)
     		 mem[waddr] <= wdata;

     always @(posedge rclk)
     if(rclken && !rempty)
       rdata <= mem[raddr];
endmodule