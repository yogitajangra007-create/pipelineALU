// ============================================================================
// Module     : execute_stage
// Designer   : Yogita Jangra
// Description: Stage 3 (EXECUTE) of the pipelined ALU.
//              Uses the alu_core combinational block to compute the result.
//              Latches the ALU output into an output register on clock edge.
// ============================================================================

module execute_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  decode_a,      // Operand A from decode stage
    input  wire [7:0]  decode_b,      // Operand B from decode stage
    input  wire [2:0]  decode_opcode, // Opcode from decode stage
    input  wire        decode_valid,  // Valid from decode stage
    output reg  [8:0]  result,        // Final ALU result (registered)
    output reg         valid          // Output valid (registered)
);

    // Wire to hold combinational ALU output
    wire [8:0] alu_result;

    // Instantiate the combinational ALU core
    alu_core alu_inst (
        .a      (decode_a),
        .b      (decode_b),
        .opcode (decode_opcode),
        .result (alu_result)
    );

    // Register the ALU result on clock edge
    always @(posedge clk) begin
        if (rst) begin
            result <= 9'b0;
            valid  <= 1'b0;
        end else begin
            result <= alu_result;
            valid  <= decode_valid;
        end
    end

endmodule
