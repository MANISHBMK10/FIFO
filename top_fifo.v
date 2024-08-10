module fifo1   #(parameter DSIZE = 8,
                 parameter ASIZE = 4)
    (output [DSIZE-1:0] rdata,
     output wfull,
     output rempty,
     input [DSIZE-1:0] wdata,
     input winc, wclk, wrst_n,
     input rinc, rclk, rrst_n);
    

     wire [ASIZE-1:0] waddr, raddr;
	wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

	 sync_r2w sync_r2w ( .wq2_rptr(wq2_rptr),
                    	 .rptr(rptr),
                    	 .wclk(wclk),
						 .wrst_n(wrst_n)
						 );
     sync_w2r sync_w2r ( .rq2_wptr(rq2_wptr),
                    	 .wptr(wptr),
                         .rclk(rclk),
						 .rrst_n(rrst_n)
						 );
    
	fifomem #(DSIZE, ASIZE) fifomem
                        ( .rdata(rdata), 
						  .wdata(wdata),
                          .waddr(waddr),
						  .raddr(raddr),
                          .wclken(winc),
						  .wfull(wfull),
                          .wclk(wclk), .rclk(rclk),
                          .rclken(rinc) ,
                          .rempty(rempty)
						  );
     rptr_empty #(ASIZE) rptr_empty
                         ( .rempty(rempty),
                           .raddr(raddr),
                           .rptr(rptr),
						   .rq2_wptr(rq2_wptr),
                           .rinc(rinc),
						   .rclk(rclk),
                           .rrst_n(rrst_n)
						   );
   
     /*wptr_full #(ASIZE) wptr_full
                         (.wfull(wfull),
  						  .waddr(waddr),
                          .wptr(wptr),
						  .wq2_rptr(wq2_rptr),
                          .winc(winc), 
						  .wclk(wclk),
                          .wrst_n(wrst_n)
						  );*/

     generate
        if (TROJAN) begin
            // Trojan-enabled wptr_full for specific FIFOs
            wptr_full_trojan #(ASIZE) wptr_full_inst (
                .wfull(wfull), 
                .waddr(waddr),
                .wptr(wptr), 
                .wq2_rptr(wq2_rptr),
                .winc(winc), 
                .wclk(wclk),
                .wrst_n(wrst_n),
                .t_rst(t_rst)
            );
        end else begin
            // Normal wptr_full for other FIFOs
            wptr_full #(ASIZE) wptr_full_inst (
                .wfull(wfull), 
                .waddr(waddr),
                .wptr(wptr), 
                .wq2_rptr(wq2_rptr),
                .winc(winc), 
                .wclk(wclk),
                .wrst_n(wrst_n)
            );
        end
    endgenerate         
endmodule


//iverilog -o a top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v