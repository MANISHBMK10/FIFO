module memory_loader (
    output reg [7:0] port_O,
    input clk,
    input clk2,
    input rst,
    input signed [7:0] port_A,     // Input port for feature matrix data
    input signed [7:0] port_W,     // Input port for weight matrix data
    input write_enable_A,  // Control signal for writing to Feature Memory
    input write_enable_W,  // Control signal for writing to Weight Memory
    input startSignal
);

// Memory Arrays
reg signed [7:0] Feature_Memory [0:31];  // 8-bit wide : 16 elements of Feature Memory Input and the next 16 elments for Output of Matrix Multiplication, 
reg signed [7:0] Weight_Memory [0:15];   // 16 elements, 8-bit wide
reg ReadEnable;
wire [4:0] count;

reg Wen;
reg [7:0] inp_west0, inp_west1, inp_west2, inp_west3, inp_north0, inp_north1, inp_north2, inp_north3;
wire [7:0] Activation_result12, Activation_result13, Activation_result14, Activation_result15;

// Counters for tracking memory writes
integer i;  // Feature Memory index
integer j;  // Weight Memory index
integer k;  // Reading output from Feature Memory

// FIFOs
wire [7:0] fifo_data_out_A, fifo_data_out_W;
wire fifo_full_A, fifo_empty_A, fifo_full_W, fifo_empty_W;
reg fifo_write_en_A, fifo_write_en_W, fifo_read_en_A, fifo_read_en_W;

fifo1 #(8, 4) feature_fifo (
    .wdata(Feature_Memory[i]),
    .winc(fifo_write_en_A),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_A),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_A),
    .wfull(fifo_full_A),
    .rempty(fifo_empty_A)
);

fifo1 #(8, 4) weight_fifo (
    .wdata(Weight_Memory[j]),
    .winc(fifo_write_en_W),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_W),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_W),
    .wfull(fifo_full_W),
    .rempty(fifo_empty_W)
);

// Writing Logic (Feature Memory)
always @(posedge clk) begin
    if (rst) begin
        i <= 0;  // Reset index
    end else if (write_enable_A) begin
        Feature_Memory[i] <= port_A;
        i <= i + 1;
    end
end

// Writing Logic (Weight Memory)
always @(posedge clk) begin
    if (rst) begin
        j <= 0;  // Reset index
    end else if (write_enable_W) begin
        Weight_Memory[j] <= port_W;
        j <= j + 1;
    end
end

// Transfer data from memory to FIFO
always @(posedge clk2) begin
    if (rst) begin
        fifo_write_en_A <= 0;
        fifo_write_en_W <= 0;
    end else if (startSignal) begin
        if (i > 0 && !fifo_full_A) begin
            fifo_write_en_A <= 1;
        end else begin
            fifo_write_en_A <= 0;
        end
        
        if (j > 0 && !fifo_full_W) begin
            fifo_write_en_W <= 1;
        end else begin
            fifo_write_en_W <= 0;
        end
    end
end

// Systolic Array Instantiation
Systolic_Array SA_1(count, Activation_result12, Activation_result13, Activation_result14, Activation_result15,inp_north0, inp_north1, inp_north2, inp_north3, inp_west0, inp_west1, inp_west2, inp_west3,Wen, clk, rst,startSignal);
initial begin 
    #69
    if (startSignal == 1) begin
        #5 Wen = 1;
        #100 Wen = 0;
    end
end

reg [4:0] cnt;
always @(posedge clk2) begin
    if (rst)
        cnt <= 4'd0;
    else if (startSignal)
        cnt <= cnt + 1;
end

always @(*) begin
    if (startSignal && cnt <= 3) begin
        Wen <= 1;
        inp_north0 <= fifo_data_out_W;
        inp_north1 <= fifo_data_out_W;
        inp_north2 <= fifo_data_out_W;
        inp_north3 <= fifo_data_out_W;
        fifo_read_en_W <= 1;
    end else begin
        Wen <= 0;
        fifo_read_en_W <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 3 && cnt <= 7) begin
        inp_west0 <= fifo_data_out_A;
        fifo_read_en_A <= 1;
    end else begin
        fifo_read_en_A <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 4 && cnt <= 8) begin
        inp_west1 <= fifo_data_out_A;
        fifo_read_en_A <= 1;
    end else begin
        fifo_read_en_A <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 5 && cnt <= 9) begin
        inp_west2 <= fifo_data_out_A;
        fifo_read_en_A <= 1;
    end else begin
        fifo_read_en_A <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 6 && cnt <= 10) begin
        inp_west3 <= fifo_data_out_A;
        fifo_read_en_A <= 1;
    end else begin
        fifo_read_en_A <= 0;
    end
end

always @(posedge clk2) begin
    if (count == 11) begin
        Feature_Memory[16] <= Activation_result12;  // First Output
    end else if (count == 12) begin
        Feature_Memory[20] <= Activation_result12;
        Feature_Memory[17] <= Activation_result13;
    end else if (count == 13) begin
        Feature_Memory[24] <= Activation_result12;
        Feature_Memory[21] <= Activation_result13;
        Feature_Memory[18] <= Activation_result14;
    end else if (count == 14) begin
        Feature_Memory[28] <= Activation_result12;
        Feature_Memory[25] <= Activation_result13;
        Feature_Memory[22] <= Activation_result14;
        Feature_Memory[19] <= Activation_result15;
    end else if (count == 15) begin
        Feature_Memory[29] <= Activation_result13;
        Feature_Memory[26] <= Activation_result14;
        Feature_Memory[23] <= Activation_result15;
    end else if (count == 16) begin
        Feature_Memory[30] <= Activation_result14;
        Feature_Memory[27] <= Activation_result15; 
    end else if (count == 17) begin
        Feature_Memory[31] <= Activation_result15;
        ReadEnable <= 1;
    end
end

always @(posedge clk2) begin
    if (rst) begin
        k <= 16;  // Reset index
    end else if (ReadEnable && (k < 32)) begin
        port_O <= Feature_Memory[k];
        k <= k + 1;
    end
end

endmodule


//C:\iverilog\bin>iverilog -o a FIFO_TPU_TB.v FIFO_TPU.v async_fifo.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v
// iverilog -o a FIFO_TPU_TB.v FIFO_TPU.v async_fifo.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v
//iverilog -o a FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v
// iverilog -o a FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v