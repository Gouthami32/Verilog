`timescale 1ns/1ps

// -------------------------------------------------------------
// Testbench for SafeALU
// Includes tests for:
// - ADD, SUB, AND, OR
// - Carry and overflow conditions
// - Zero flag behavior
// -------------------------------------------------------------

module tb_SafeALU;

    reg  [7:0] A, B;
    reg  [1:0] OP;
    wire [7:0] R;
    wire Z, C, V;

    SafeALU dut (
        .A(A), .B(B),
        .OP(OP),
        .R(R), .Z(Z), .C(C), .V(V)
    );

    task run(input [7:0] a, input [7:0] b, input [1:0] op);
        begin
            A = a;
            B = b;
            OP = op;
            #5;
            $display("OP=%b | A=%d B=%d -> R=%d | Z=%b C=%b V=%b", 
                      op, A, B, R, Z, C, V);
        end
    endtask

    initial begin
        $dumpfile("safealu.vcd");
        $dumpvars(0, tb_SafeALU);

        // ADD Tests
        run(10, 20, 2'b00);
        run(200, 100, 2'b00); // Carry-out
        run(8'h7F, 1, 2'b00); // Overflow

        // SUB Tests
        run(50, 10, 2'b01);
        run(10, 50, 2'b01); // Borrow
        run(8'h80, 1, 2'b01); // Overflow

        // AND Tests
        run(8'hAA, 8'h0F, 2'b10);

        // OR Tests
        run(8'h55, 8'h88, 2'b11);

        // Zero flag
        run(8'd0, 8'd0, 2'b00);

        $finish;
    end

endmodule
