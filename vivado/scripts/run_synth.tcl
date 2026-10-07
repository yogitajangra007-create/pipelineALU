# ============================================================================
# Script     : run_synth.tcl
# Designer   : Yogita Jangra
# Description: Vivado batch synthesis and timing analysis script
#              for the 3-stage pipelined ALU.
# Usage      : vivado -mode batch -source vivado/scripts/run_synth.tcl
# ============================================================================

# Create in-memory project (no project files on disk)
create_project -in_memory -part xc7a35tcpg236-1

# Add RTL design sources
read_verilog {
    rtl/alu_core.v
    rtl/pipeline_regs.v
    rtl/fetch_stage.v
    rtl/decode_stage.v
    rtl/execute_stage.v
    rtl/alu_top.v
}

# Add timing constraints
read_xdc vivado/constraints/alu.xdc

# Run synthesis
synth_design -top alu_top

# Generate timing summary report
report_timing_summary -file vivado/reports/timing_summary.rpt
puts "Timing summary saved to vivado/reports/timing_summary.rpt"

# Generate utilization report
report_utilization -file vivado/reports/utilization.rpt
puts "Utilization report saved to vivado/reports/utilization.rpt"

puts "============================================="
puts "  Synthesis complete — Yogita Jangra"
puts "============================================="
