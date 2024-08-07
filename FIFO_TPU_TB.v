`timescale 1ns / 1ps
module TPU_tb;

    reg clk, clk2;
    reg wrst, rrst, rst, rst2;
    reg startSignal;
    reg F_Sig;
    reg [7:0] port_A;          // Input port for feature matrix data
    reg [7:0] port_W;          // Input port for weight matrix data
    reg write_enable_A;        // Control signal for writing to Feature Memory
    reg write_enable_W;        // Control signal for writing to Weight Memory
     wire [7:0] port_O;
   // reg [7:0] Feature_Memory [0:15];  // 16 elements, 8-bit wide
    //reg [7:0] Weight_Memory [0:15];
    // Instantiate the memory_loader module
    TPU uut (
        .port_O(port_O),
        .clk(clk),
        .rst(rst),
        .port_A(port_A),
        .port_W(port_W),
        .write_enable_A(write_enable_A),
        .write_enable_W(write_enable_W),
        .startSignal(startSignal),
        .clk2(clk2), .wrst(wrst), .rrst(rrst), .F_Sig(F_Sig) , .rst2(rst2)
      );
    integer i;
    integer j;
    integer k;

    // Clock generation
   
    // Clock generation for clk
    initial clk = 0;
    always #10 clk = ~clk; // Clock with a period of 10 ns (100 MHz)

    // Clock generation for clk2
    initial clk2 = 0;
    always #20 clk2 = ~clk2; // Clock with a period of 20 ns (50 MHz)
    // Testbench logic
    initial begin
        // Initialize signals
        rst = 1;  // Apply reset
        port_A = 0;
        port_W = 0;
        write_enable_A = 0;
        write_enable_W = 0;
        wrst = 0;
        rrst = 0;
        rst2 = 1;
        // Release reset and start initialization after two clock cycles
        #20;
        rst = 0;
        startSignal=0;
       

                          

        // Load the weight memory
        write_enable_W = 1;  // Enable writing to weight memory
        port_W = 8'd4; #20;
        port_W = 8'd0; #20;
        port_W = 8'd2; #20;
        port_W = 8'd1; #20;
        
        port_W = 8'd4; #20;
        port_W = 8'd3; #20;
        port_W = 8'd2; #20;
        port_W = 8'd0; #20;
        
        port_W = 8'd4; #20;
        port_W = 8'd3; #20;
        port_W = 8'd0; #20;
        port_W = 8'd1; #20;
        
        port_W = 8'd4; #20;
        port_W = 8'd3; #20;
        port_W = 8'd2; #20;
        port_W = 8'd1; #20;
        write_enable_W = 0;  // Disable writing to weight memory
        wrst = 1;
        rrst = 1;
       write_enable_A = 1;  // Enable writing to feature memory
        port_A = 8'd1; #20;
        port_A = 8'd2; #20;
        port_A = 8'd3; #20;
        port_A = 8'd4; #20;
        
        port_A = 8'd1; #20;
        port_A = 8'd2; #20;
        port_A = 8'd3; #20;
        port_A = 8'd4; #20;
        
        port_A = 8'd1; #20;
        port_A = 8'd2; #20;
        port_A = 8'd3; #20;
        port_A = 8'd4; #20;
        
        port_A = 8'd1; #20;
        port_A = 8'd2; #20;
        port_A = 8'd3; #20;
        port_A = 8'd4; #20;
        write_enable_A = 0; 
        F_Sig = 1;
        #1000 startSignal =1;
        rst2 = 0; 
        rst = 1;
        #500 rst =0;
       
    
        // Display the values loaded into Feature Memory
        
      /* $display("Feature Memory:");
        for (i = 0; i < 16; i = i + 1) begin
            $display("[%0d] = %d \t ", i, uut.Feature_Memory[i]);
        end

        // Display the values loaded into Weight Memory
        $display("\nWeight Memory:");
        for ( j = 0; j < 16; j = j + 1) begin
            $display("[%0d] = %d", j, uut.Weight_Memory[j]);
        end
        */
        
      $display("The feature Matrix Loaded into Feature Memory is:\n %d %d %d %d \n %d %d %d %d \n %d %d %d %d \n %d %d %d %d \n ", uut.Feature_Memory[0], uut.Feature_Memory[1],uut.Feature_Memory[2],uut.Feature_Memory[3],uut.Feature_Memory[4],uut.Feature_Memory[5],uut.Feature_Memory[6],uut.Feature_Memory[7],
        uut.Feature_Memory[8],uut.Feature_Memory[9],uut.Feature_Memory[10],uut.Feature_Memory[11],uut.Feature_Memory[12],uut.Feature_Memory[13],uut.Feature_Memory[14],uut.Feature_Memory[15]);

    $display("The Weight Matrix loaded into Weight Memory is:\n %d %d %d %d \n %d %d %d %d \n %d %d %d %d \n %d %d %d %d \n ", uut.Weight_Memory[0], uut.Weight_Memory[1],uut.Weight_Memory[2],uut.Weight_Memory[3],uut.Weight_Memory[4],uut.Weight_Memory[5],uut.Weight_Memory[6],uut.Weight_Memory[7],
        uut.Weight_Memory[8],uut.Weight_Memory[9],uut.Weight_Memory[10],uut.Weight_Memory[11],uut.Weight_Memory[12],uut.Weight_Memory[13],uut.Weight_Memory[14],uut.Weight_Memory[15]);
   

    end
   always@(*) begin
       $monitor("Time: %t, SSig:%d  \n ", $time,startSignal);
       
    end 

initial
begin 
    #100000 $finish;
end
   


  always@(uut.Feature_Memory[31])
  #1500
    begin 
     $display(" Matrix Multiplication Output fetched from Feature Memory = \n %d  %d  %d  %d \n %d  %d  %d  %d \n %d  %d  %d  %d \n %d  %d  %d  %d \n  ",  uut.Feature_Memory[16],uut.Feature_Memory[17],uut.Feature_Memory[18],uut.Feature_Memory[19],uut.Feature_Memory[20],uut.Feature_Memory[21],uut.Feature_Memory[22],uut.Feature_Memory[23],uut.Feature_Memory[24], uut.Feature_Memory[25],uut.Feature_Memory[26],uut.Feature_Memory[27],uut.Feature_Memory[28],uut.Feature_Memory[29],uut.Feature_Memory[30],uut.Feature_Memory[31] );
    end
initial begin
    $dumpfile("tpu.vcd");
	$dumpvars(0,TPU_tb);
end


endmodule

// iverilog -o b FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v
