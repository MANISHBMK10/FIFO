module fifo_t   #(parameter DSIZE = 8,
                 parameter ASIZE = 4)
    (output [DSIZE-1:0] rdata,
     output wfull,
     output rempty,
     input [DSIZE-1:0] wdata,
     input winc, wclk, wrst_n,
     input rinc, rclk, rrst_n,t_rst);
    

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
     rptr_empty_trojan #(ASIZE) rempty_t
                         ( .rempty(rempty),
                           .raddr(raddr),
                           .rptr(rptr),
						   .rq2_wptr(rq2_wptr),
                           .rinc(rinc),
						   .rclk(rclk),
                           .rrst_n(rrst_n)
						   );
   
    wptr_full_trojan #(ASIZE) wfull_t (
                .wfull(wfull), 
                .waddr(waddr),
                .wptr(wptr), 
                .wq2_rptr(wq2_rptr),
                .winc(winc), 
                .wclk(wclk),
                .wrst_n(wrst_n),
                .t_rst(t_rst)
            );
        
endmodule


//iverilog -o a top_fifo_t.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v Trojan_1.v wptr_full_trojan.v