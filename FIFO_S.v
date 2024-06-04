module fifo_sync (
    input clk,
    input reset,
    input [23:0] data_in,
    input push,             // Signal to push data into FIFO
    input pop,              // Signal to pop data from FIFO
    output reg [23:0] data_out,
    output reg empty,
    output reg full
);
    reg [23:0] fifo [3:0];  // 4 tiles deep FIFO buffer
    reg [1:0] write_ptr, read_ptr; // Pointers for write and read operations
    reg [2:0] count;        // Counter to keep track of the number of elements in FIFO

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 2'b00;
            read_ptr <= 2'b00;
            count <= 3'b000;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            // Handle simultaneous read and write operations
            if (push && !full) begin
                fifo[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                if (count != 4) count <= count + 1;
                empty <= 1'b0;
                if (count == 3) full <= 1'b1;
            end

            if (pop && !empty) begin
                data_out <= fifo[read_ptr];
                read_ptr <= read_ptr + 1;
                if (count != 0) count <= count - 1;
                full <= 1'b0;
                if (count == 1) empty <= 1'b1;
            end
        end
    end
endmodule
