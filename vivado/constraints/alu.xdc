## ============================================================================
## Constraints  : alu.xdc
## Designer     : Yogita Jangra
## Description  : Clock constraint for timing analysis of the pipelined ALU.
##                Target: 100 MHz clock (10 ns period)
## ============================================================================

## Clock definition — 100 MHz (10 ns period)
create_clock -period 10.000 -name clk [get_ports clk]

## Input delay constraints (relative to clock)
set_input_delay -clock clk 2.0 [get_ports {operand_a[*]}]
set_input_delay -clock clk 2.0 [get_ports {operand_b[*]}]
set_input_delay -clock clk 2.0 [get_ports {opcode[*]}]
set_input_delay -clock clk 2.0 [get_ports rst]

## Output delay constraints (relative to clock)
set_output_delay -clock clk 2.0 [get_ports {result[*]}]
set_output_delay -clock clk 2.0 [get_ports valid]
