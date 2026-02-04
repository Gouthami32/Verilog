`timescale 1ns/1ps

// -------------------------------------------------------------
// Testbench for Experiment 6: RingBuffer
// -------------------------------------------------------------
// Tests:
//   - Push 4 elements → FIFO becomes full
//   - Pop 4 elements → FIFO becomes empty
//   - Wrap-around behavior of pointers
//   - No write when full, no read when empty
// -------------------------------------------------------------

module tb_RingBuffer;

    reg clk, rst;
    reg write_en, read_en;
    reg [7:0] write_data;
    wire [7:0] read_data;
    wire full, empty;

    RingBuffer dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .write_data(write_data),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    task push(input [7:0] val);
        begin
            write_data = val;
            write_en = 1; read_en = 0;
            @(posedge clk);
            write_en = 0;
            $display("PUSH %0d | full=%b empty=%b", val, full, empty);
        end
    endtask

    task pop();
        begin
            read_en = 1; write_en = 0;
            @(posedge clk);
            read_en = 0;
            $display("POP -> %0d | full=%b empty=%b", read_data, full, empty);
        end
    endtask

    initial begin
        $dumpfile("ringbuffer.vcd");
        $dumpvars(0, tb_RingBuffer);

        clk = 0; rst = 1;
        write_en = 0; read_en = 0;
        
        #15 rst = 0;

        // Fill FIFO
        push(10);
        push(20);
        push(30);
        push(40);

        // Extra push should be ignored
        push(50);

        // Empty FIFO
        pop();
        pop();
        pop();
        pop();

        // Extra pop should do nothing
        pop();

        // Check wrap-around
        push(100);
        push(200);
        pop();
        push(150);
        pop();
        pop();

        $finish;
    end

endmodule
