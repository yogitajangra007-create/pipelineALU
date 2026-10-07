// ============================================================================
// Module     : alu_top
// Designer   : Yogita Jangra
// Description: Top-level module for the 3-stage pipelined ALU.
//              Connects Fetch → Decode → Execute stages together.
//              Pipeline: FETCH (latch inputs) → DECODE (decode opcode) →
//                        EXECUTE (compute result using alu_core)
// ============================================================================

module alu_top (
    input  wire        clk,        // Clock signal
    input  wire        rst,        // Active-high synchronous reset
    input  wire [7:0]  operand_a,  // 8-bit operand A
    input  wire [7:0]  operand_b,  // 8-bit operand B
    input  wire [2:0]  opcode,     // 3-bit operation code
    output wire [8:0]  result,     // 9-bit result (carry bit included)
    output wire        valid       // Output valid after pipeline fills
);

    // -----------------------------------------------------------
    // Internal wires between pipeline stages
    // -----------------------------------------------------------

    // IF/ID boundary (Fetch → Decode)
    wire [7:0] fetch_a;
    wire [7:0] fetch_b;
    wire [2:0] fetch_opcode;
    wire       fetch_valid;

    // ID/EX boundary (Decode → Execute)
    wire [7:0] decode_a;
    wire [7:0] decode_b;
    wire [2:0] decode_opcode;
    wire       decode_valid;

    // -----------------------------------------------------------
    // Stage 1 : FETCH — latch inputs into pipeline registers
    // -----------------------------------------------------------
    fetch_stage u_fetch (
        .clk          (clk),
        .rst          (rst),
        .operand_a    (operand_a),
        .operand_b    (operand_b),
        .opcode       (opcode),
        .fetch_a      (fetch_a),
        .fetch_b      (fetch_b),
        .fetch_opcode (fetch_opcode),
        .fetch_valid  (fetch_valid)
    );

    // -----------------------------------------------------------
    // Stage 2 : DECODE — decode opcode, pass operands forward
    // -----------------------------------------------------------
    decode_stage u_decode (
        .clk           (clk),
        .rst           (rst),
        .fetch_a       (fetch_a),
        .fetch_b       (fetch_b),
        .fetch_opcode  (fetch_opcode),
        .fetch_valid   (fetch_valid),
        .decode_a      (decode_a),
        .decode_b      (decode_b),
        .decode_opcode (decode_opcode),
        .decode_valid  (decode_valid)
    );

    // -----------------------------------------------------------
    // Stage 3 : EXECUTE — compute result using ALU core
    // -----------------------------------------------------------
    execute_stage u_execute (
        .clk           (clk),
        .rst           (rst),
        .decode_a      (decode_a),
        .decode_b      (decode_b),
        .decode_opcode (decode_opcode),
        .decode_valid  (decode_valid),
        .result        (result),
        .valid         (valid)
    );

endmodule
