// ============================================================================
// Project    : 3-Stage Pipelined ALU
// Designer   : Yogita Jangra
// Date       : Feb 2026 - Mar 2026
// Description: A 3-stage pipelined ALU (Fetch, Decode, Execute) in Verilog
//              that performs arithmetic and logical operations with pipeline
//              registers for stage synchronization.
// Tools      : Verilog HDL, Vivado, Icarus Verilog, GTKWave
// ============================================================================

module pipelined_alu (
    input  wire        clk,        // Clock signal
    input  wire        rst,        // Active-high synchronous reset
    input  wire [7:0]  operand_a,  // 8-bit operand A input
    input  wire [7:0]  operand_b,  // 8-bit operand B input
    input  wire [2:0]  opcode,     // 3-bit operation code
    output reg  [8:0]  result,     // 9-bit result (extra bit for carry)
    output reg         valid       // Output valid signal (high after pipeline fills)
);

    // -----------------------------------------------------------
    // Operation Code Definitions
    // -----------------------------------------------------------
    localparam ADD = 3'b000;  // Addition
    localparam SUB = 3'b001;  // Subtraction
    localparam AND = 3'b010;  // Bitwise AND
    localparam OR  = 3'b011;  // Bitwise OR
    localparam XOR = 3'b100;  // Bitwise XOR

    // -----------------------------------------------------------
    // Pipeline Stage 1 Registers : FETCH Stage
    // Captures the input operands and opcode from external input
    // -----------------------------------------------------------
    reg [7:0] fetch_a;
    reg [7:0] fetch_b;
    reg [2:0] fetch_opcode;
    reg       fetch_valid;

    // -----------------------------------------------------------
    // Pipeline Stage 2 Registers : DECODE Stage
    // Passes operands forward and decodes the operation
    // -----------------------------------------------------------
    reg [7:0] decode_a;
    reg [7:0] decode_b;
    reg [2:0] decode_opcode;
    reg       decode_valid;

    // -----------------------------------------------------------
    // Pipeline Stage 3 : EXECUTE Stage
    // Result and valid are the output registers (declared as outputs)
    // -----------------------------------------------------------

    // =============================================
    // STAGE 1 : FETCH
    // Latch inputs into pipeline registers
    // =============================================
    always @(posedge clk) begin
        if (rst) begin
            fetch_a      <= 8'b0;
            fetch_b      <= 8'b0;
            fetch_opcode <= 3'b0;
            fetch_valid  <= 1'b0;
        end else begin
            fetch_a      <= operand_a;
            fetch_b      <= operand_b;
            fetch_opcode <= opcode;
            fetch_valid  <= 1'b1;
        end
    end

    // =============================================
    // STAGE 2 : DECODE
    // Forward operands and decoded opcode to next stage
    // =============================================
    always @(posedge clk) begin
        if (rst) begin
            decode_a      <= 8'b0;
            decode_b      <= 8'b0;
            decode_opcode <= 3'b0;
            decode_valid  <= 1'b0;
        end else begin
            decode_a      <= fetch_a;
            decode_b      <= fetch_b;
            decode_opcode <= fetch_opcode;
            decode_valid  <= fetch_valid;
        end
    end

    // =============================================
    // STAGE 3 : EXECUTE
    // Perform the arithmetic/logical operation
    // =============================================
    always @(posedge clk) begin
        if (rst) begin
            result <= 9'b0;
            valid  <= 1'b0;
        end else begin
            valid <= decode_valid;
            case (decode_opcode)
                ADD:     result <= decode_a + decode_b;
                SUB:     result <= decode_a - decode_b;
                AND:     result <= decode_a & decode_b;
                OR:      result <= decode_a | decode_b;
                XOR:     result <= decode_a ^ decode_b;
                default: result <= 9'b0;
            endcase
        end
    end

endmodule
