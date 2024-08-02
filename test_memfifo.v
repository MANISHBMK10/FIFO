module memory_tester(
    input [7:0] port_A,
    output reg [7:0] port_D,
    input W_en, clk, clk2, rst, rst1, rst2, rst3, R_en, s_sig);

reg signed [7:0] Feature_Memory [0:15];
reg signed [7:0] Weight_Memory [0:31];
wire [7:0] fifo_data_out;
wire fifo_full, fifo_empty;
reg winc, rinc;
integer i, j, k, l;
reg [7:0] data_in;
reg [7:0] read_sync_cntr;
reg fifo_empty_flag;

// Write to Feature_Memory
always @(posedge clk) begin
    if (rst) begin
        l <= 0;
    end else if (W_en && l<16) begin
        Feature_Memory[l] <= port_A;
        l <= l + 1;
    end
end

// FIFO instantiation
fifo1 #(8, 4) feature_fifo (
    .wdata(data_in), // Correction for how data is written into FIFO
    .winc(winc),
    .wclk(clk),
    .wrst_n(rst1),
    .rinc(rinc),
    .rclk(clk2),
    .rrst_n(rst2),
    .rdata(fifo_data_out),
    .wfull(fifo_full),
    .rempty(fifo_empty)
);

// Manage FIFO write control signal
always @(posedge clk) begin
    if (rst) begin
        i <= 0;
        winc <= 0; // Ensure that write increment signal is properly managed
    end else if (s_sig && !fifo_full && i < 16) begin
        data_in <= Feature_Memory[i];
        winc <= 1;
        i <= i+1;
    end else begin
        winc <= 0;
    end
end

// Read from FIFO and write to Weight_Memory
always @(posedge clk2) begin
    read_sync_cntr = read_sync_cntr +1 ;
    if (rst3) begin
        j <= 0;
        rinc <= 0;
    end else if (R_en && (fifo_empty_flag == 1) && j < 16 ) begin   //&& ^fifo_data_out !== 1'bx  ,&& !(read_sync_cntr <= 2) , && (read_sync_cntr > 4)
          if(read_sync_cntr > 2)begin 
            Weight_Memory[j] <= fifo_data_out;
            j <= j + 1;
            if (j == 16) fifo_empty_flag =0; 
          end
          rinc <= 1;
    end else begin
       rinc <= 0;
    end
end


always @(negedge fifo_empty) begin
read_sync_cntr = 0;
fifo_empty_flag = 1;
end


// Output Weight_Memory content sequentially
always @(posedge clk2) begin
    if (rst3) begin
        k <= 0;
    end else if (k < 16) begin
        port_D <= Weight_Memory[k];
        k <= k + 1;
    end
end

endmodule

