// ============================================================================
// Module     : fetch_stage
// Designer   : Yogita Jangra
// Description: Stage 1 (FETCH) of the pipelined ALU.
//              Latches the input operands and opcode into pipeline registers
//              on every rising clock edge. Outputs go to IF/ID boundary.
// ============================================================================

module fetch_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  operand_a,   // External input A
    input  wire [7:0]  operand_b,   // External input B
    input  wire [2:0]  opcode,      // External opcode
    output wire [7:0]  fetch_a,     // Latched A → to decode stage
    output wire [7:0]  fetch_b,     // Latched B → to decode stage
    output wire [2:0]  fetch_opcode,// Latched opcode → to decode stage
    output wire        fetch_valid  // Data valid flag
);

    // IF/ID pipeline registers using the parameterized pipeline_regs module
    pipeline_regs #(.WIDTH(8)) reg_a (
        .clk (clk),
        .rst (rst),
        .d   (operand_a),
        .q   (fetch_a)
    );

    pipeline_regs #(.WIDTH(8)) reg_b (
        .clk (clk),
        .rst (rst),
        .d   (operand_b),
        .q   (fetch_b)
    );

    pipeline_regs #(.WIDTH(3)) reg_opcode (
        .clk (clk),
        .rst (rst),
        .d   (opcode),
        .q   (fetch_opcode)
    );

    // Valid signal: goes high one cycle after reset is released
    pipeline_regs #(.WIDTH(1)) reg_valid (
        .clk (clk),
        .rst (rst),
        .d   (1'b1),
        .q   (fetch_valid)
    );

endmodule
