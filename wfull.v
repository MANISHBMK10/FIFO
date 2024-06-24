module wptr_full #(parameter ADDRSIZE = 2)
   (output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE :0] wptr,
    input [ADDRSIZE :0] wq2_rptr,
    input winc, wclk, wrst_n);

   reg [ADDRSIZE:0] wbin;
   wire [ADDRSIZE:0] wgraynext, wbinnext,wfull_val;

   always @(posedge wclk or negedge wrst_n)
     if (!wrst_n) 
       {wbin, wptr} <= 0;
     else
       {wbin, wptr} <= {wbinnext, wgraynext};

   assign waddr = wbin[ADDRSIZE-1:0];
   assign wbinnext = wbin + (winc & ~wfull);
   assign wgraynext = (wbinnext>>1) ^ wbinnext;
  
    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
				    wq2_rptr[ADDRSIZE-2:0]});
   
   always @(posedge wclk or negedge wrst_n)
     if (!wrst_n)
       wfull <= 1'b0;
     else
       wfull <= wfull_val;
endmodule