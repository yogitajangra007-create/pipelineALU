// ============================================================================
// Testbench  : alu_core_tb
// Designer   : Yogita Jangra
// Description: Unit test for the combinational alu_core module.
//              Tests all ALU operations without pipeline (instant result).
// ============================================================================

`timescale 1ns / 1ps

module alu_core_tb;

    // Testbench signals
    reg  [7:0] a;
    reg  [7:0] b;
    reg  [2:0] opcode;
    wire [8:0] result;

    // Operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;

    // Counters
    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // Instantiate the ALU core
    alu_core uut (
        .a      (a),
        .b      (b),
        .opcode (opcode),
        .result (result)
    );

    // Task: check result
    task check;
        input [7:0]  in_a;
        input [7:0]  in_b;
        input [2:0]  op;
        input [8:0]  expected;
        input [8*6-1:0] op_name;
    begin
        a = in_a;
        b = in_b;
        opcode = op;
        #10;  // Wait for combinational logic to settle

        test_num = test_num + 1;
        if (result === expected) begin
            $display("TEST %0d PASS : %0s | A=%0d, B=%0d | Result=%0d",
                     test_num, op_name, in_a, in_b, result);
            pass_count = pass_count + 1;
        end else begin
            $display("TEST %0d FAIL : %0s | A=%0d, B=%0d | Result=%0d (Expected=%0d)",
                     test_num, op_name, in_a, in_b, result, expected);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // Test stimulus
    initial begin
        $display("=============================================");
        $display("  ALU Core Unit Test - Yogita Jangra         ");
        $display("=============================================");

        check(8'd25,  8'd10,  ADD, 9'd35,  "ADD   ");
        check(8'd50,  8'd15,  SUB, 9'd35,  "SUB   ");
        check(8'hAA,  8'h55,  AND, 9'h00,  "AND   ");
        check(8'hAA,  8'h55,  OR,  9'hFF,  "OR    ");
        check(8'hFF,  8'h0F,  XOR, 9'hF0,  "XOR   ");
        check(8'd200, 8'd100, ADD, 9'd300, "ADD   ");
        check(8'd0,   8'd0,   ADD, 9'd0,   "ADD   ");
        check(8'hFF,  8'hFF,  AND, 9'hFF,  "AND   ");

        $display("=============================================");
        $display("  RESULTS: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("=============================================");

        $finish;
    end

endmodule
