// -------------------------------------------------------------
// SafeALU - 8-bit ALU with Flags
// -------------------------------------------------------------
// Supported operations:
//  OP = 2'b00 → ADD
//  OP = 2'b01 → SUB
//  OP = 2'b10 → AND
//  OP = 2'b11 → OR
//
// Flags:
//  Z = 1 if result == 0
//  C = Carry-out from ADD / Borrow from SUB
//  V = Overflow for ADD/SUB (signed overflow)
// -------------------------------------------------------------

module SafeALU(
    input  [7:0] A, B,      // ALU Inputs
    input  [1:0] OP,        // Operation Select
    output reg [7:0] R,     // Result
    output reg Z, C, V      // Flags
);

    reg [8:0] temp;         // Extra bit for carry calculations

    always @(*) begin
        // Default values
        R = 0; 
        C = 0;
        V = 0;

        case(OP)

            // -------------------- ADD --------------------
            2'b00: begin
                temp = A + B;
                R = temp[7:0];
                C = temp[8];   // Carry-out
                V = (~A[7] & ~B[7] & R[7]) | (A[7] & B[7] & ~R[7]);
            end

            // -------------------- SUB --------------------
            2'b01: begin
                temp = A - B;
                R = temp[7:0];
                C = temp[8];   // Borrow flag (inverted logic)
                V = (A[7] & ~B[7] & ~R[7]) | (~A[7] & B[7] & R[7]);
            end

            // -------------------- AND --------------------
            2'b10: begin
                R = A & B;
            end

            // -------------------- OR ---------------------
            2'b11: begin
                R = A | B;
            end
        endcase

        // Zero flag
        Z = (R == 8'd0);
    end

endmodule
