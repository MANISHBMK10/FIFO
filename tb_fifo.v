module tb_fifo1;

// Parameters
parameter DSIZE = 8;
parameter ASIZE = 4;

// Testbench signals
reg [DSIZE-1:0] wdata;
reg winc, wclk, wrst_n;
reg rinc, rclk, rrst_n;
wire [DSIZE-1:0] rdata;
wire wfull, rempty;

// Instantiate the FIFO
fifo1 #(DSIZE, ASIZE) uut (
    .rdata(rdata),
    .wfull(wfull),
    .rempty(rempty),
    .wdata(wdata),
    .winc(winc),
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rinc(rinc),
    .rclk(rclk),
    .rrst_n(rrst_n)
);

// Clock generation
initial begin
    wclk = 0;
    forever #5 wclk = ~wclk; // 100 MHz write clock
end

initial begin
    rclk = 0;
    forever #7 rclk = ~rclk; // ~71 MHz read clock
end

// Stimulus
initial begin
    // Initialize inputs
    wrst_n = 0;
    rrst_n = 0;
    winc = 0;
    rinc = 0;
    wdata = 0;

    // Apply reset pulse
    #10 wrst_n = 1;
    rrst_n = 1;

    // Test writing to FIFO
    #20 write_fifo(8'hA5);
    write_fifo(8'h5A);
    write_fifo(8'h3C);
    write_fifo(8'hC3);

    // Test reading from FIFO
    #50 read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();

    // Test FIFO full condition
    #20 write_fifo(8'h12);
    write_fifo(8'h34);
    write_fifo(8'h56);
    write_fifo(8'h78);
    write_fifo(8'h9A);
    write_fifo(8'hBC);
    write_fifo(8'hDE);
    write_fifo(8'hF0);
    write_fifo(8'h11);
    write_fifo(8'h22);
    write_fifo(8'h33);
    write_fifo(8'h44);
    write_fifo(8'h55);
    write_fifo(8'h66);
    write_fifo(8'h77);

    // Test FIFO empty condition
    #50 read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    //
      read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();

    // Finish simulation
    #100 $finish;
end

// Task to write data to FIFO
task write_fifo(input [DSIZE-1:0] data);
    begin
        if (!wfull) begin
            winc = 1;
            wdata = data;
            #10 winc = 0;
        end else begin
            $display("Attempted to write to full FIFO at time %0t", $time);
        end
    end
endtask

// Task to read data from FIFO
task read_fifo;
    begin
        if (!rempty) begin
            rinc = 1;
            #10 rinc = 0;
        end else begin
            $display("Attempted to read from empty FIFO at time %0t", $time);
        end
    end
endtask

// Monitor
initial begin
    $monitor("Time: %0t | wclk: %b | rclk: %b | wrst_n: %b | rrst_n: %b | winc: %b | rinc: %b | wdata: %h | rdata: %h | wfull: %b | rempty: %b",
             $time, wclk, rclk, wrst_n, rrst_n, winc, rinc, wdata, rdata, wfull, rempty);
end

endmodule
