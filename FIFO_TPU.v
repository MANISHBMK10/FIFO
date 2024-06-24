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
reg signed [7:0] Feature_Memory [0:31];  // 8-bit wide : 16 elements of Feature Memory Input and the next 16 elements for Output of Matrix Multiplication
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

// FIFOs for Feature Memory
wire [7:0] fifo_data_out_A0, fifo_data_out_A1, fifo_data_out_A2, fifo_data_out_A3;
wire fifo_full_A0, fifo_empty_A0, fifo_full_A1, fifo_empty_A1, fifo_full_A2, fifo_empty_A2, fifo_full_A3, fifo_empty_A3;
reg fifo_write_en_A0, fifo_write_en_A1, fifo_write_en_A2, fifo_write_en_A3;
reg fifo_read_en_A0, fifo_read_en_A1, fifo_read_en_A2, fifo_read_en_A3;

fifo1 #(8, 2) feature_fifo0 (
    .wdata(Feature_Memory[i]),
    .winc(fifo_write_en_A0),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_A0),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_A0),
    .wfull(fifo_full_A0),
    .rempty(fifo_empty_A0)
);

fifo1 #(8, 2) feature_fifo1 (
    .wdata(Feature_Memory[i]),
    .winc(fifo_write_en_A1),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_A1),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_A1),
    .wfull(fifo_full_A1),
    .rempty(fifo_empty_A1)
);

fifo1 #(8, 2) feature_fifo2 (
    .wdata(Feature_Memory[i]),
    .winc(fifo_write_en_A2),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_A2),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_A2),
    .wfull(fifo_full_A2),
    .rempty(fifo_empty_A2)
);

fifo1 #(8, 2) feature_fifo3 (
    .wdata(Feature_Memory[i]),
    .winc(fifo_write_en_A3),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_A3),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_A3),
    .wfull(fifo_full_A3),
    .rempty(fifo_empty_A3)
);

// FIFOs for Weight Memory
wire [7:0] fifo_data_out_W0, fifo_data_out_W1, fifo_data_out_W2, fifo_data_out_W3;
wire fifo_full_W0, fifo_empty_W0, fifo_full_W1, fifo_empty_W1, fifo_full_W2, fifo_empty_W2, fifo_full_W3, fifo_empty_W3;
reg fifo_write_en_W0, fifo_write_en_W1, fifo_write_en_W2, fifo_write_en_W3;
reg fifo_read_en_W0, fifo_read_en_W1, fifo_read_en_W2, fifo_read_en_W3;

fifo1 #(8, 2) weight_fifo0 (
    .wdata(Weight_Memory[j]),
    .winc(fifo_write_en_W0),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_W0),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_W0),
    .wfull(fifo_full_W0),
    .rempty(fifo_empty_W0)
);

fifo1 #(8, 2) weight_fifo1 (
    .wdata(Weight_Memory[j]),
    .winc(fifo_write_en_W1),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_W1),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_W1),
    .wfull(fifo_full_W1),
    .rempty(fifo_empty_W1)
);

fifo1 #(8, 2) weight_fifo2 (
    .wdata(Weight_Memory[j]),
    .winc(fifo_write_en_W2),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_W2),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_W2),
    .wfull(fifo_full_W2),
    .rempty(fifo_empty_W2)
);

fifo1 #(8, 2) weight_fifo3 (
    .wdata(Weight_Memory[j]),
    .winc(fifo_write_en_W3),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_read_en_W3),
    .rclk(clk2),
    .rrst_n(~rst),
    .rdata(fifo_data_out_W3),
    .wfull(fifo_full_W3),
    .rempty(fifo_empty_W3)
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

// Transfer data from memory to FIFOs
//Corrected, needs testing
always @(posedge clk) begin
    if (rst) begin
        i <= 0;
        j <= 0;
        fifo_write_en_A0 <= 0;
        fifo_write_en_A1 <= 0;
        fifo_write_en_A2 <= 0;
        fifo_write_en_A3 <= 0;
        fifo_write_en_W0 <= 0;
        fifo_write_en_W1 <= 0;
        fifo_write_en_W2 <= 0;
        fifo_write_en_W3 <= 0;
    end else if (startSignal) begin
        // Write Feature Memory to FIFOs
        if (i < 16) begin
            case (i % 4)
                0: begin
                    if (!fifo_full_A0) begin
                        fifo_write_en_A0 <= 1;
                        i <= i + 1;
                    end
                end
                1: begin
                    if (!fifo_full_A1) begin
                        fifo_write_en_A1 <= 1;
                        i <= i + 1;
                    end
                end
                2: begin
                    if (!fifo_full_A2) begin
                        fifo_write_en_A2 <= 1;
                        i <= i + 1;
                    end
                end
                3: begin
                    if (!fifo_full_A3) begin
                        fifo_write_en_A3 <= 1;
                        i <= i + 1;
                    end
                end
            endcase
        end else begin
            fifo_write_en_A0 <= 0;
            fifo_write_en_A1 <= 0;
            fifo_write_en_A2 <= 0;
            fifo_write_en_A3 <= 0;
        end

        // Write Weight Memory to FIFOs
        if (j < 16) begin
            case (j % 4)
                0: begin
                    if (!fifo_full_W0) begin
                        fifo_write_en_W0 <= 1;
                        j <= j + 1;
                    end
                end
                1: begin
                    if (!fifo_full_W1) begin
                        fifo_write_en_W1 <= 1;
                        j <= j + 1;
                    end
                end
                2: begin
                    if (!fifo_full_W2) begin
                        fifo_write_en_W2 <= 1;
                        j <= j + 1;
                    end
                end
                3: begin
                    if (!fifo_full_W3) begin
                        fifo_write_en_W3 <= 1;
                        j <= j + 1;
                    end
                end
            endcase
        end else begin
            fifo_write_en_W0 <= 0;
            fifo_write_en_W1 <= 0;
            fifo_write_en_W2 <= 0;
            fifo_write_en_W3 <= 0;
        end
    end
end


// Systolic Array Instantiation
Systolic_Array SA_1(count, Activation_result12, Activation_result13, Activation_result14, Activation_result15, inp_north0, inp_north1, inp_north2, inp_north3, inp_west0, inp_west1, inp_west2, inp_west3, Wen, clk2, rst, startSignal);

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
        inp_north0 <= fifo_data_out_W0;
        inp_north1 <= fifo_data_out_W1;
        inp_north2 <= fifo_data_out_W2;
        inp_north3 <= fifo_data_out_W3;
        fifo_read_en_W0 <= 1;
        fifo_read_en_W1 <= 1;
        fifo_read_en_W2 <= 1;
        fifo_read_en_W3 <= 1;
    end else begin
        Wen <= 0;
        fifo_read_en_W0 <= 0;
        fifo_read_en_W1 <= 0;
        fifo_read_en_W2 <= 0;
        fifo_read_en_W3 <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 3 && cnt <= 7) begin
        inp_west0 <= fifo_data_out_A0;
        fifo_read_en_A0 <= 1;
    end else begin
        fifo_read_en_A0 <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 4 && cnt <= 8) begin
        inp_west1 <= fifo_data_out_A1;
        fifo_read_en_A1 <= 1;
    end else begin
        fifo_read_en_A1 <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 5 && cnt <= 9) begin
        inp_west2 <= fifo_data_out_A2;
        fifo_read_en_A2 <= 1;
    end else begin
        fifo_read_en_A2 <= 0;
    end
end

always @(*) begin
    if (startSignal && cnt > 6 && cnt <= 10) begin
        inp_west3 <= fifo_data_out_A3;
        fifo_read_en_A3 <= 1;
    end else begin
        fifo_read_en_A3 <= 0;
    end
end

// Instantiate FIFOs for activation results
wire [7:0] fifo_act_data_out0, fifo_act_data_out1, fifo_act_data_out2, fifo_act_data_out3;
wire fifo_act_full0, fifo_act_empty0, fifo_act_full1, fifo_act_empty1, fifo_act_full2, fifo_act_empty2, fifo_act_full3, fifo_act_empty3;
reg fifo_act_read_en0, fifo_act_write_en0, fifo_act_read_en1, fifo_act_write_en1, fifo_act_read_en2, fifo_act_write_en2, fifo_act_read_en3, fifo_act_write_en3;

fifo1 #(8, 2) act_fifo0 (
    .wdata(Activation_result12),
    .winc(fifo_act_write_en0),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_act_read_en0),
    .rclk(clk),
    .rrst_n(~rst),
    .rdata(fifo_act_data_out0),
    .wfull(fifo_act_full0),
    .rempty(fifo_act_empty0)
);

fifo1 #(8, 2) act_fifo1 (
    .wdata(Activation_result13),
    .winc(fifo_act_write_en1),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_act_read_en1),
    .rclk(clk),
    .rrst_n(~rst),
    .rdata(fifo_act_data_out1),
    .wfull(fifo_act_full1),
    .rempty(fifo_act_empty1)
);

fifo1 #(8, 2) act_fifo2 (
    .wdata(Activation_result14),
    .winc(fifo_act_write_en2),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_act_read_en2),
    .rclk(clk),
    .rrst_n(~rst),
    .rdata(fifo_act_data_out2),
    .wfull(fifo_act_full2),
    .rempty(fifo_act_empty2)
);

fifo1 #(8, 2) act_fifo3 (
    .wdata(Activation_result15),
    .winc(fifo_act_write_en3),
    .wclk(clk2),
    .wrst_n(~rst),
    .rinc(fifo_act_read_en3),
    .rclk(clk),
    .rrst_n(~rst),
    .rdata(fifo_act_data_out3),
    .wfull(fifo_act_full3),
    .rempty(fifo_act_empty3)
);

always @(posedge clk2) begin
    if (count == 11) begin
        fifo_act_write_en0 <= 1;
    end else if (count == 12) begin
        fifo_act_write_en1 <= 1;
    end else if (count == 13) begin
        fifo_act_write_en2 <= 1;
    end else if (count == 14) begin
        fifo_act_write_en3 <= 1;
    end else begin
        fifo_act_write_en0 <= 0;
        fifo_act_write_en1 <= 0;
        fifo_act_write_en2 <= 0;
        fifo_act_write_en3 <= 0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        k <= 16;
        fifo_act_read_en0 <= 0;
        fifo_act_read_en1 <= 0;
        fifo_act_read_en2 <= 0;
        fifo_act_read_en3 <= 0;
    end else if (ReadEnable && (k < 32)) begin
        case (k % 4)
            0: begin
                if (!fifo_act_empty0) begin
                    Feature_Memory[k] <= fifo_act_data_out0;
                    k <= k + 1;
                    fifo_act_read_en0 <= 1;
                end else begin
                    fifo_act_read_en0 <= 0;
                end
            end
            1: begin
                if (!fifo_act_empty1) begin
                    Feature_Memory[k] <= fifo_act_data_out1;
                    k <= k + 1;
                    fifo_act_read_en1 <= 1;
                end else begin
                    fifo_act_read_en1 <= 0;
                end
            end
            2: begin
                if (!fifo_act_empty2) begin
                    Feature_Memory[k] <= fifo_act_data_out2;
                    k <= k + 1;
                    fifo_act_read_en2 <= 1;
                end else begin
                    fifo_act_read_en2 <= 0;
                end
            end
            3: begin
                if (!fifo_act_empty3) begin
                    Feature_Memory[k] <= fifo_act_data_out3;
                    k <= k + 1;
                    fifo_act_read_en3 <= 1;
                end else begin
                    fifo_act_read_en3 <= 0;
                end
            end
        endcase
    end else begin
        fifo_act_read_en0 <= 0;
        fifo_act_read_en1 <= 0;
        fifo_act_read_en2 <= 0;
        fifo_act_read_en3 <= 0;
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
