module TPU (
    output reg [7:0] port_O,
    input clk,
    input clk2,
    input rst, wrst, rrst, rst2,
    input signed [7:0] port_A,     // Input port for feature matrix data
    input signed [7:0] port_W,     // Input port for weight matrix data
    input write_enable_A,  // Control signal for writing to Feature Memory
    input write_enable_W,  // Control signal for writing to Weight Memory
    input startSignal, F_Sig
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
integer i,a;  // Feature Memory index
integer j,b;  // Weight Memory index
integer k;  // Reading output from Feature Memory
integer e,l;
integer w, x, y, z;

// FIFOs for Feature Memory
wire [7:0] fifo_data_out_A0, fifo_data_out_A1, fifo_data_out_A2, fifo_data_out_A3;
wire fifo_full_A0, fifo_empty_A0, fifo_full_A1, fifo_empty_A1, fifo_full_A2, fifo_empty_A2, fifo_full_A3, fifo_empty_A3;
reg fifo_write_en_A0, fifo_write_en_A1, fifo_write_en_A2, fifo_write_en_A3;
reg fifo_read_en_A0, fifo_read_en_A1, fifo_read_en_A2, fifo_read_en_A3;
reg [7:0] data_in_A0, data_in_A1, data_in_A2, data_in_A3, data_in_W0 ,data_in_W1, data_in_W2, data_in_W3;
reg [7:0] read_sync_cntr;
reg fifo_empty_flag;
reg [1:0] cntr_en = 2'd0;
reg [1:0] cntr_en3 = 2'd0;
reg [7:0] read_sync_cntr_0, read_sync_cntr_1, read_sync_cntr_2, read_sync_cntr_3;
reg fifo_empty_flag_0, fifo_empty_flag_1, fifo_empty_flag_2, fifo_empty_flag_3;
reg ReadEnable_0;
fifo1 #(8, 4) feature_fifo0 (
    .wdata(data_in_A0),
    .winc(fifo_write_en_A0),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_A0),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_A0),
    .wfull(fifo_full_A0),
    .rempty(fifo_empty_A0)
);

fifo1 #(8, 4) feature_fifo1 (
    .wdata(data_in_A1),
    .winc(fifo_write_en_A1),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_A1),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_A1),
    .wfull(fifo_full_A1),
    .rempty(fifo_empty_A1)
);

fifo1 #(8, 4) feature_fifo2 (
    .wdata(data_in_A2),
    .winc(fifo_write_en_A2),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_A2),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_A2),
    .wfull(fifo_full_A2),
    .rempty(fifo_empty_A2)
);

fifo1 #(8, 4) feature_fifo3 (
    .wdata(data_in_A3),
    .winc(fifo_write_en_A3),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_A3),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_A3),
    .wfull(fifo_full_A3),
    .rempty(fifo_empty_A3)
);

// FIFOs for Weight Memory
wire [7:0] fifo_data_out_W0, fifo_data_out_W1, fifo_data_out_W2, fifo_data_out_W3;
wire fifo_full_W0, fifo_empty_W0, fifo_full_W1, fifo_empty_W1, fifo_full_W2, fifo_empty_W2, fifo_full_W3, fifo_empty_W3;
reg fifo_write_en_W0, fifo_write_en_W1, fifo_write_en_W2, fifo_write_en_W3;
reg fifo_read_en_W0, fifo_read_en_W1, fifo_read_en_W2, fifo_read_en_W3;
reg  write_en_delay_counter = 1'd0;
reg  write_en_delay_counter_2 = 1'd0;

fifo_t #(8, 4) weight_fifo0 (
    .wdata(data_in_W0),
    .winc(fifo_write_en_W0),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_W0),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_W0),
    .wfull(fifo_full_W0),
    .rempty(fifo_empty_W0)
);

fifo_t #(8, 4) weight_fifo1 (
    .wdata(data_in_W1),
    .winc(fifo_write_en_W1),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_W1),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_W1),
    .wfull(fifo_full_W1),
    .rempty(fifo_empty_W1)
);

fifo_t #(8, 4) weight_fifo2 (
    .wdata(data_in_W2),
    .winc(fifo_write_en_W2),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_W2),
    .rclk(clk2),
    .rrst_n(rrst),
    .rdata(fifo_data_out_W2),
    .wfull(fifo_full_W2),
    .rempty(fifo_empty_W2)
);

fifo_t #(8, 4) weight_fifo3 (
    .wdata(data_in_W3),
    .winc(fifo_write_en_W3),
    .wclk(clk),
    .wrst_n(wrst),
    .rinc(fifo_read_en_W3),
    .rclk(clk2),
    .rrst_n(rrst),
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
        a <= 0;
        b <= 0;
        fifo_write_en_A0 <= 0;
        fifo_write_en_A1 <= 0;
        fifo_write_en_A2 <= 0;
        fifo_write_en_A3 <= 0;
        fifo_write_en_W0 <= 0;
        fifo_write_en_W1 <= 0;
        fifo_write_en_W2 <= 0;
        fifo_write_en_W3 <= 0;
    end else if (F_Sig) begin
        // Write Weight Memory to FIFOs
        if (b < 16) begin
            case (b % 4)
               /* 0: begin
                    if (!fifo_full_W0) begin
                        data_in_W0 <= Weight_Memory[b];
                        
                        fifo_write_en_W0 <= 1;
                        b <= b + 1;
                    end
                end*/
                  0: begin
                    if (!fifo_full_W0) begin
                        // Load data immediately
                        data_in_W0 <= Weight_Memory[12-b];
                        fifo_write_en_W0 <= 1;
                        // Increment the delay counter
                        write_en_delay_counter <= write_en_delay_counter + 1;
                        // Enable writing after 1 clock cycles
                        if (write_en_delay_counter == 1'd1) begin
                            fifo_write_en_W0 <= 0;
                            b <= b + 1;
                            write_en_delay_counter <= 0; // Reset counter
                        end 
                    end
                end
                1: begin
                    if (!fifo_full_W1) begin
                        data_in_W1 <= Weight_Memory[14-b];
                        fifo_write_en_W1 <= 1;
                        write_en_delay_counter <= write_en_delay_counter + 1;
                        if (write_en_delay_counter == 1'd1) begin
                            fifo_write_en_W1 <= 0;
                            b <= b + 1;
                            write_en_delay_counter <= 0; 
                        end 
                       
                    end
                end
                2: begin
                    if (!fifo_full_W2) begin
                        data_in_W2 <= Weight_Memory[16-b];
                        fifo_write_en_W2 <= 1;
                        write_en_delay_counter <= write_en_delay_counter + 1;
                        if (write_en_delay_counter == 1'd1) begin
                            fifo_write_en_W2 <= 0;
                            b <= b + 1;
                            write_en_delay_counter <= 0; 
                        end
                    end
                end
                3: begin
                    if (!fifo_full_W3) begin
                        data_in_W3 <= Weight_Memory[18-b];
                        fifo_write_en_W3 <= 1;
                        write_en_delay_counter <= write_en_delay_counter + 1;
                        if (write_en_delay_counter == 1'd1) begin
                            fifo_write_en_W3 <= 0;
                            b <= b + 1;
                            write_en_delay_counter <= 0; 
                        end
                    end
                end
            endcase
        end else begin
            fifo_write_en_W0 <= 0;
            fifo_write_en_W1 <= 0;
            fifo_write_en_W2 <= 0;
            fifo_write_en_W3 <= 0;
        end
        // Write Feature Memory to FIFOs
        if (a < 16) begin
            case (a % 4)
                0: begin
                    if (!fifo_full_A0) begin
                        fifo_write_en_A0 <= 1;
                        data_in_A0 <= Feature_Memory[a];
                        write_en_delay_counter_2 <= write_en_delay_counter_2 + 1;
                        if (write_en_delay_counter_2 == 1'd1) begin
                            fifo_write_en_A0 <= 0;
                            a <= a + 1;
                            write_en_delay_counter_2 <= 0; 
                        end 
                    end
                end
                1: begin
                    if (!fifo_full_A1) begin
                        fifo_write_en_A1 <= 1;
                        data_in_A1 <= Feature_Memory[a];
                        write_en_delay_counter_2 <= write_en_delay_counter_2 + 1;
                        if (write_en_delay_counter_2 == 1'd1) begin
                            fifo_write_en_A1 <= 0;
                            a <= a + 1;
                            write_en_delay_counter_2 <= 0; 
                        end 
                    end
                end
                2: begin
                    if (!fifo_full_A2) begin
                        fifo_write_en_A2 <= 1;
                        data_in_A2 <= Feature_Memory[a];
                        write_en_delay_counter_2 <= write_en_delay_counter_2 + 1;
                        if (write_en_delay_counter_2 == 1'd1) begin
                            fifo_write_en_A2 <= 0;
                            a <= a + 1;
                            write_en_delay_counter_2 <= 0; 
                        end 
                    end
                end
                3: begin
                    if (!fifo_full_A3) begin
                        fifo_write_en_A3 <= 1;
                        data_in_A3 <= Feature_Memory[a];
                        write_en_delay_counter_2 <= write_en_delay_counter_2 + 1;
                        if (write_en_delay_counter_2 == 1'd1) begin
                            fifo_write_en_A3 <= 0;
                            a <= a + 1;
                            write_en_delay_counter_2 <= 0; 
                        end 
                    end
                end
            endcase
        end else begin
            fifo_write_en_A0 <= 0;
            fifo_write_en_A1 <= 0;
            fifo_write_en_A2 <= 0;
            fifo_write_en_A3 <= 0;
        end


    end
end


// Systolic Array Instantiation
Systolic_Array SA_1(count, Activation_result12, Activation_result13, Activation_result14, Activation_result15, inp_north0, inp_north1, inp_north2, inp_north3, inp_west0, inp_west1, inp_west2, inp_west3, Wen, clk2, rst2, startSignal);

initial begin 
    //#69
    if (startSignal == 1) begin
        #5 Wen = 1;
        #200 Wen = 0;
    end
end

reg [4:0] cnt;
always @(posedge clk2) begin
    if (rst2)
        cnt <= 4'd0;
    else if (startSignal)
        cnt <= cnt + 1;
end

/*always @(clk2) begin
    if (startSignal && cnt <= 3) begin
        Wen <= 1;
        read_sync_cntr = read_sync_cntr +1 ;
    if (rst2) begin                  
        e <= 0;
        fifo_read_en_W2 <= 0;
    end else if ((fifo_empty_flag == 1) && e < 4 ) begin
          if(read_sync_cntr > 2)begin 
            inp_north0 <= fifo_data_out_W0;
            e <= e + 1;
            if (e == 4) fifo_empty_flag =0; 
          end
          fifo_read_en_W2 <= 1;
    end else begin
       fifo_read_en_W2 <= 0;
    end*/
    always @(*) begin
        if(startSignal && cnt <=5)begin
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
/*always @(negedge fifo_empty_W0) begin
read_sync_cntr = 0;
fifo_empty_flag = 1;
end*/

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

fifo1 #(8, 4) act_fifo0 (
    .wdata(Activation_result12),
    .winc(fifo_act_write_en0),
    .wclk(clk2),
    .wrst_n(wrst),
    .rinc(fifo_act_read_en0),
    .rclk(clk),
    .rrst_n(rrst),
    .rdata(fifo_act_data_out0),
    .wfull(fifo_act_full0),
    .rempty(fifo_act_empty0)
);

fifo1 #(8, 4) act_fifo1 (
    .wdata(Activation_result13),
    .winc(fifo_act_write_en1),
    .wclk(clk2),
    .wrst_n(wrst),
    .rinc(fifo_act_read_en1),
    .rclk(clk),
    .rrst_n(rrst),
    .rdata(fifo_act_data_out1),
    .wfull(fifo_act_full1),
    .rempty(fifo_act_empty1)
);

fifo1 #(8, 4) act_fifo2 (
    .wdata(Activation_result14),
    .winc(fifo_act_write_en2),
    .wclk(clk2),
    .wrst_n(wrst),
    .rinc(fifo_act_read_en2),
    .rclk(clk),
    .rrst_n(rrst),
    .rdata(fifo_act_data_out2),
    .wfull(fifo_act_full2),
    .rempty(fifo_act_empty2)
);

fifo1 #(8, 4) act_fifo3 (
    .wdata(Activation_result15),
    .winc(fifo_act_write_en3),
    .wclk(clk2),
    .wrst_n(wrst),
    .rinc(fifo_act_read_en3),
    .rclk(clk),
    .rrst_n(rrst),
    .rdata(fifo_act_data_out3),
    .wfull(fifo_act_full3),
    .rempty(fifo_act_empty3)
);

always @(posedge clk2) begin
    if (count == 11) begin
        fifo_act_write_en0 <= 1;
    end else if (count == 12) begin
        fifo_act_write_en0 <= 1;
        fifo_act_write_en1 <= 1;
    end else if (count == 13) begin
        fifo_act_write_en2 <= 1;
         fifo_act_write_en0 <= 1;
        fifo_act_write_en1 <= 1;
    end else if (count == 14) begin
        fifo_act_write_en3 <= 1;
        fifo_act_write_en2 <= 1;
         fifo_act_write_en0 <= 0;
        fifo_act_write_en1 <= 1;
    end else if (count == 15) begin
        fifo_act_write_en3 <= 1;
        fifo_act_write_en2 <= 1;
        fifo_act_write_en1 <= 0;
    end else if (count == 16) begin
        fifo_act_write_en3 <= 1;
        fifo_act_write_en2 <= 0;
    end else if (count == 17) begin
        fifo_act_write_en3 <= 0;
        //ReadEnable <= 1;
    end 
    
    /*else if (count == 17) begin
        if(cntr_en3 == 1) begin
        fifo_act_write_en3 <= 1;
        fifo_act_write_en2 <= 0;
        cntr_en = cntr_en + 1;
        if(cntr_en == 2) begin 
        fifo_act_write_en3 <= 0;
        cntr_en <=0;
        cntr_en3 <= 0;
        end 
        end else fifo_act_write_en3 <= 0;
    end*/ else begin
        fifo_act_write_en0 <= 0;
        fifo_act_write_en1 <= 0;
        fifo_act_write_en2 <= 0;
        fifo_act_write_en3 <= 0;
    end
end

/*always @(posedge clk) begin
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
end */
always @(posedge clk) begin
    read_sync_cntr_0 = read_sync_cntr_0 +1 ;
    if (rst) begin
        x <= 0;
       fifo_act_read_en0 <= 0;
    end else if (ReadEnable && (fifo_empty_flag_0 == 1) && x < 4) begin 
          if(read_sync_cntr_0 > 2)begin 
            Feature_Memory[(16+(x*4))] <= fifo_act_data_out0;
            x <= x + 1;
            if (x == 3) fifo_empty_flag_0 =0; 
          end
          fifo_act_read_en0 <= 1;
    end else begin
       fifo_act_read_en0 <= 0;
    end
end
always @(negedge fifo_act_empty0) begin
read_sync_cntr_0 = 0;
fifo_empty_flag_0 = 1;
ReadEnable <= 1;
end
always @(posedge clk) begin
    read_sync_cntr_1 = read_sync_cntr_1 +1 ;
    if (rst) begin
        y <= 0;
       fifo_act_read_en1 <= 0;
    end else if (ReadEnable && (fifo_empty_flag_1 == 1) && y < 4) begin 
          if(read_sync_cntr_1 > 2)begin 
            Feature_Memory[(17+(y*4))] <= fifo_act_data_out1;
            y <= y + 1;
            if (y == 3) fifo_empty_flag_1 =0; 
          end
          fifo_act_read_en1 <= 1;
    end else begin
       fifo_act_read_en1 <= 0;
    end
end
always @(negedge fifo_act_empty1) begin
read_sync_cntr_1 = 0;
fifo_empty_flag_1 = 1;
end

always @(posedge clk) begin
    read_sync_cntr_2 = read_sync_cntr_2 +1 ;
    if (rst) begin
        z <= 0;
       fifo_act_read_en2 <= 0;
    end else if (ReadEnable && (fifo_empty_flag_2 == 1) && z < 4) begin 
          if(read_sync_cntr_2 > 2)begin 
            Feature_Memory[(18+(z*4))] <= fifo_act_data_out2;
            z <= z + 1;
            if (z == 3) fifo_empty_flag_2 =0; 
          end
          fifo_act_read_en2 <= 1;
    end else begin
       fifo_act_read_en2 <= 0;
    end
end
always @(negedge fifo_act_empty2) begin
read_sync_cntr_2 = 0;
fifo_empty_flag_2 = 1;
end

always @(posedge clk) begin
    read_sync_cntr_3 = read_sync_cntr_3 +1 ;
    if (rst) begin
        w <= 0;
       fifo_act_read_en3 <= 0;
    end else if (ReadEnable && (fifo_empty_flag_3 == 1) && w < 4) begin 
          if(read_sync_cntr_3 > 2 )begin 
            Feature_Memory[(19+(w*4))] <= fifo_act_data_out3;
            w <= w + 1;
            if (w == 3)  begin
                fifo_empty_flag_3 =0; 
                ReadEnable_0 = 1;
            end
          end
          fifo_act_read_en3 <= 1;

    end else begin
       fifo_act_read_en3 <= 0;
    end
end
always @(negedge fifo_act_empty3) begin
read_sync_cntr_3 = 0;
fifo_empty_flag_3 = 1;
end

always @(posedge clk) begin
    if (fifo_empty_flag_3) begin
        l <= 16;  // Reset index
    end else if (ReadEnable_0 && (l < 32)) begin
        port_O <= Feature_Memory[l];
        l <= l + 1;
    end
end

endmodule
