// ============================================================================
// Project    : 3-Stage Pipelined ALU - Testbench
// Designer   : Yogita Jangra
// Date       : Feb 2026 - Mar 2026
// Description: Testbench for the 3-stage pipelined ALU.
//              Applies stimulus for all ALU operations and verifies output
//              using waveform simulation (GTKWave / Vivado).
// ============================================================================

`timescale 1ns / 1ps

module tb_pipelined_alu;

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

    // -----------------------------------------------------------
    // Operation Code Parameters (same as design)
    // -----------------------------------------------------------
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;

    // -----------------------------------------------------------
    // Instantiate the Pipelined ALU (Unit Under Test)
    // -----------------------------------------------------------
    pipelined_alu uut (
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
    // VCD Dump for GTKWave Waveform Viewing
    // -----------------------------------------------------------
    initial begin
        $dumpfile("pipelined_alu.vcd");
        $dumpvars(0, tb_pipelined_alu);
    end

    // -----------------------------------------------------------
    // Test Stimulus
    // -----------------------------------------------------------
    initial begin
        // Display header
        $display("=============================================================");
        $display("       3-Stage Pipelined ALU Testbench - Yogita Jangra       ");
        $display("=============================================================");
        $display("Time\t\tOp\tA\tB\tResult\tValid");
        $display("-------------------------------------------------------------");

        // Initialize inputs
        rst       = 1;
        operand_a = 8'b0;
        operand_b = 8'b0;
        opcode    = 3'b0;

        // Hold reset for 2 clock cycles
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // ----------------------------------------------------------
        // Test Case 1 : Addition (25 + 10 = 35)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'd25;
        operand_b = 8'd10;
        opcode    = ADD;

        // ----------------------------------------------------------
        // Test Case 2 : Subtraction (50 - 15 = 35)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'd50;
        operand_b = 8'd15;
        opcode    = SUB;

        // ----------------------------------------------------------
        // Test Case 3 : AND (8'hAA & 8'h55 = 8'h00)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'hAA;
        operand_b = 8'h55;
        opcode    = AND;

        // ----------------------------------------------------------
        // Test Case 4 : OR (8'hAA | 8'h55 = 8'hFF)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'hAA;
        operand_b = 8'h55;
        opcode    = OR;

        // ----------------------------------------------------------
        // Test Case 5 : XOR (8'hFF ^ 8'h0F = 8'hF0)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'hFF;
        operand_b = 8'h0F;
        opcode    = XOR;

        // ----------------------------------------------------------
        // Test Case 6 : Addition with carry (200 + 100 = 300)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'd200;
        operand_b = 8'd100;
        opcode    = ADD;

        // ----------------------------------------------------------
        // Test Case 7 : Subtraction result zero (30 - 30 = 0)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'd30;
        operand_b = 8'd30;
        opcode    = SUB;

        // ----------------------------------------------------------
        // Test Case 8 : XOR same values (8'hAB ^ 8'hAB = 8'h00)
        // ----------------------------------------------------------
        @(posedge clk);
        operand_a = 8'hAB;
        operand_b = 8'hAB;
        opcode    = XOR;

        // Wait for pipeline to flush (3 extra cycles for 3-stage pipeline)
        repeat (5) @(posedge clk);

        $display("=============================================================");
        $display("             Simulation Complete - All Tests Done             ");
        $display("=============================================================");
        $finish;
    end

    // -----------------------------------------------------------
    // Monitor : Display result whenever valid is high
    // -----------------------------------------------------------
    always @(posedge clk) begin
        if (valid) begin
            $display("%0t ns\t\t%b\t%0d\t%0d\t%0d\t%b",
                     $time, opcode, operand_a, operand_b, result, valid);
        end
    end

endmodule
