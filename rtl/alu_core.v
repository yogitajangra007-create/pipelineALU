// ============================================================================
// Module     : alu_core
// Designer   : Yogita Jangra
// Description: Combinational arithmetic and logic unit.
//              Performs ADD, SUB, AND, OR, XOR based on the opcode.
//              This is a pure combinational block (no clock).
// ============================================================================

module alu_core (
    input  wire [7:0] a,        // Operand A
    input  wire [7:0] b,        // Operand B
    input  wire [2:0] opcode,   // Operation select
    output reg  [8:0] result    // 9-bit result (extra bit for carry)
);

    // Operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;

    // Combinational logic — no clock needed
    always @(*) begin
        case (opcode)
            ADD:     result = a + b;
            SUB:     result = a - b;
            AND:     result = a & b;
            OR:      result = a | b;
            XOR:     result = a ^ b;
            default: result = 9'b0;
        endcase
    end

endmodule
