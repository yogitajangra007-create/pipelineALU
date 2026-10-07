// ============================================================================
// Testbench  : alu_top_tb
// Designer   : Yogita Jangra
// Description: Self-checking testbench for the 3-stage pipelined ALU.
//              Applies test vectors, waits for pipeline latency (3 cycles),
//              and compares actual output with expected values.
//              Generates VCD waveform for GTKWave viewing.
// ============================================================================

`timescale 1ns / 1ps

module alu_top_tb;

    // -----------------------------------------------------------
    // Testbench Signals
    // -----------------------------------------------------------
    reg        clk;
    reg        rst;
    reg  [7:0] operand_a;
    reg  [7:0] operand_b;
    reg  [2:0] opcode;
    wire [8:0] result;
    wire       valid;

    // Operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;

    // Counters for pass/fail
    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // -----------------------------------------------------------
    // Instantiate the DUT (Device Under Test)
    // -----------------------------------------------------------
    alu_top uut (
        .clk       (clk),
        .rst       (rst),
        .operand_a (operand_a),
        .operand_b (operand_b),
        .opcode    (opcode),
        .result    (result),
        .valid     (valid)
    );

    // -----------------------------------------------------------
    // Clock Generation : 10 ns period (100 MHz)
    // -----------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -----------------------------------------------------------
    // VCD Dump for GTKWave
    // -----------------------------------------------------------
    initial begin
        $dumpfile("alu_top.vcd");
        $dumpvars(0, alu_top_tb);
    end

    // -----------------------------------------------------------
    // Task: Apply stimulus and check result after pipeline delay
    // -----------------------------------------------------------
    task apply_and_check;
        input [7:0]  a;
        input [7:0]  b;
        input [2:0]  op;
        input [8:0]  expected;
        input [8*12-1:0] op_name;  // Operation name string
    begin
        @(posedge clk);
        operand_a = a;
        operand_b = b;
        opcode    = op;

        // Wait 3 clock cycles for pipeline latency
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        test_num = test_num + 1;

        if (result === expected) begin
            $display("TEST %0d PASS : %0s | A=%0d, B=%0d | Result=%0d (Expected=%0d)",
                     test_num, op_name, a, b, result, expected);
            pass_count = pass_count + 1;
        end else begin
            $display("TEST %0d FAIL : %0s | A=%0d, B=%0d | Result=%0d (Expected=%0d)",
                     test_num, op_name, a, b, result, expected);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // -----------------------------------------------------------
    // Test Stimulus
    // -----------------------------------------------------------
    initial begin
        $display("=============================================================");
        $display("   3-Stage Pipelined ALU - Self-Checking Testbench           ");
        $display("   Designer: Yogita Jangra                                   ");
        $display("=============================================================");

        // Initialize
        rst       = 1;
        operand_a = 0;
        operand_b = 0;
        opcode    = 0;

        // Hold reset for 3 cycles
        repeat (3) @(posedge clk);
        rst = 0;

        // Wait one cycle after reset release
        @(posedge clk);

        // ------- Test Cases -------

        // Test 1: Addition  25 + 10 = 35
        apply_and_check(8'd25,  8'd10,  ADD, 9'd35,  "ADD        ");

        // Test 2: Subtraction  50 - 15 = 35
        apply_and_check(8'd50,  8'd15,  SUB, 9'd35,  "SUB        ");

        // Test 3: AND  0xAA & 0x55 = 0x00
        apply_and_check(8'hAA,  8'h55,  AND, 9'h00,  "AND        ");

        // Test 4: OR  0xAA | 0x55 = 0xFF
        apply_and_check(8'hAA,  8'h55,  OR,  9'hFF,  "OR         ");

        // Test 5: XOR  0xFF ^ 0x0F = 0xF0
        apply_and_check(8'hFF,  8'h0F,  XOR, 9'hF0,  "XOR        ");

        // Test 6: Addition with carry  200 + 100 = 300
        apply_and_check(8'd200, 8'd100, ADD, 9'd300, "ADD (carry)");

        // Test 7: Subtraction  30 - 30 = 0
        apply_and_check(8'd30,  8'd30,  SUB, 9'd0,   "SUB (zero) ");

        // Test 8: XOR same values  0xAB ^ 0xAB = 0x00
        apply_and_check(8'hAB,  8'hAB,  XOR, 9'h00,  "XOR (same) ");

        // ------- Summary -------
        $display("=============================================================");
        $display("  RESULTS: %0d PASSED, %0d FAILED out of %0d tests",
                 pass_count, fail_count, test_num);
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        $display("=============================================================");

        #20;
        $finish;
    end

endmodule
