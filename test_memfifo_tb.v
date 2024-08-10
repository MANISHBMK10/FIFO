
`timescale 1ns / 1ps

module tb_memory_tester;

// Inputs
reg  [7:0] port_A;
reg W_en, clk, clk2, rst, R_en, s_sig, rst1, rst2, rst3, t_rst;

// Output
wire  [7:0] port_D;
integer i,j;

// Instantiate the Unit Under Test (UUT)
memory_tester uut (
    .port_A(port_A),
    .port_D(port_D),
    .W_en(W_en),
    .clk(clk),
    .clk2(clk2),
    .rst(rst),
    .R_en(R_en),
    .s_sig(s_sig),
    .rst1(rst1), .rst2(rst2), .rst3(rst3), .t_rst(t_rst)
);
initial begin
    clk = 0;
    forever #10 clk = ~clk; // Clock with a period of 10 ns
end

initial begin
    clk2 = 0;
    forever #20 clk2 = ~clk2; // Second clock with a period of 20 ns
end

initial begin
    // Initialize Inputs
    W_en = 0;
    rst = 1; 
    rst3 = 1;// Apply reset
    R_en = 0;
    s_sig = 0;
    rst1 =0;
    rst2 = 0;
    t_rst = 1;

    // Wait 100 ns for global reset to finish
    #100;
    rst = 0; // Release reset
    rst1 =1;
    rst2 =1;
    //rst3 =0;

    // Writing to Feature Memory
    #20 W_en = 1; port_A = 8'd4;
    #20 port_A = 8'd14;
    #20 port_A = 8'd24;
    #20 port_A = 8'd42;
    #20 port_A = 8'd141;
    #20 port_A = 8'd243;
    #20 port_A = 8'd41;
    #20 port_A = 8'd134;
    #20 port_A = 8'd204;
    #20 port_A = 8'd124;
    #20 port_A = 8'd104;
    #20 port_A = 8'd24;
    #20 port_A = 8'd034;
    #20 port_A = 8'd74;
    #20 port_A = 8'd84;
    #20 port_A = 8'd95;
    //#20 port_A = 8'd65;
    // Continue for other values
    #20 W_en = 0; // Stop writing
     s_sig = 1;
     t_rst = 0;
     rst3 =0;
      R_en = 1;
      // Start signal for FIFO writing
    #400 s_sig = 0;
   

    // Enable reading after some time for stability
     
    
 
    
    #800 R_en = 0;

    // Display output
    $display("Output Memory:");
    for ( i = 0; i < 16; i = i + 1) begin
        $display("[%0d] = %d \t ", i, uut.Weight_Memory[i]);
    end
    $display("Input Memory:");
    for ( j = 0; j < 16; j = j + 1) begin
         $display("[%0d] = %d \t ", j, uut.Feature_Memory[j]);
    end
    
end

initial begin
    #2000 $finish; // Finish simulation after sufficient time
    
end

initial begin
    $dumpfile("fifo3.vcd");
	$dumpvars(0,tb_memory_tester);
    //$dumpvars(0,uut.Weight_Memory);
end

endmodule

// iverilog -o a test_memfifo_tb.v test_memfifo.v wfull.v rempty.v sync_r2w.v sync_w2r.v top_fifo.v fifo_mem.v Trojan_1.v wptr_full_trojan.v
