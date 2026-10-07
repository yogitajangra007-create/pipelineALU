// ============================================================================
// Module     : decode_stage
// Designer   : Yogita Jangra
// Description: Stage 2 (DECODE) of the pipelined ALU.
//              Receives data from IF/ID registers, decodes the opcode,
//              and passes operands + opcode to the ID/EX boundary registers.
// ============================================================================

module decode_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  fetch_a,       // From fetch stage
    input  wire [7:0]  fetch_b,       // From fetch stage
    input  wire [2:0]  fetch_opcode,  // From fetch stage
    input  wire        fetch_valid,   // Valid from fetch stage
    output wire [7:0]  decode_a,      // Decoded A → to execute stage
    output wire [7:0]  decode_b,      // Decoded B → to execute stage
    output wire [2:0]  decode_opcode, // Decoded opcode → to execute stage
    output wire        decode_valid   // Valid → to execute stage
);

    // ID/EX pipeline registers
    pipeline_regs #(.WIDTH(8)) reg_a (
        .clk (clk),
        .rst (rst),
        .d   (fetch_a),
        .q   (decode_a)
    );

    pipeline_regs #(.WIDTH(8)) reg_b (
        .clk (clk),
        .rst (rst),
        .d   (fetch_b),
        .q   (decode_b)
    );

    pipeline_regs #(.WIDTH(3)) reg_opcode (
        .clk (clk),
        .rst (rst),
        .d   (fetch_opcode),
        .q   (decode_opcode)
    );

    pipeline_regs #(.WIDTH(1)) reg_valid (
        .clk (clk),
        .rst (rst),
        .d   (fetch_valid),
        .q   (decode_valid)
    );

endmodule
