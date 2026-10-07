# ============================================================================
# Makefile for 3-Stage Pipelined ALU
# Designer : Yogita Jangra
# Tools    : Icarus Verilog, GTKWave
# ============================================================================

# Tool paths (change if needed)
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Directories
RTL_DIR   = rtl
TB_DIR    = tb
BUILD_DIR = sim/build
WAVE_DIR  = sim/waves

# RTL source files
RTL_SRC = $(RTL_DIR)/alu_core.v \
          $(RTL_DIR)/pipeline_regs.v \
          $(RTL_DIR)/fetch_stage.v \
          $(RTL_DIR)/decode_stage.v \
          $(RTL_DIR)/execute_stage.v \
          $(RTL_DIR)/alu_top.v

# Default target
all: sim_top

# -----------------------------------------------------------
# Compile and simulate the full pipelined ALU testbench
# -----------------------------------------------------------
sim_top: $(BUILD_DIR)/alu_top_sim.vvp
	$(VVP) $(BUILD_DIR)/alu_top_sim.vvp
	@mv alu_top.vcd $(WAVE_DIR)/ 2>/dev/null || true
	@echo "Waveform saved to $(WAVE_DIR)/alu_top.vcd"

$(BUILD_DIR)/alu_top_sim.vvp: $(RTL_SRC) $(TB_DIR)/alu_top_tb.v
	@mkdir -p $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $@ $(RTL_SRC) $(TB_DIR)/alu_top_tb.v

# -----------------------------------------------------------
# Compile and simulate the ALU core unit test
# -----------------------------------------------------------
sim_core: $(BUILD_DIR)/alu_core_sim.vvp
	$(VVP) $(BUILD_DIR)/alu_core_sim.vvp
	@echo "ALU core unit test complete."

$(BUILD_DIR)/alu_core_sim.vvp: $(RTL_DIR)/alu_core.v $(TB_DIR)/alu_core_tb.v
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) -o $@ $(RTL_DIR)/alu_core.v $(TB_DIR)/alu_core_tb.v

# -----------------------------------------------------------
# Open waveform in GTKWave
# -----------------------------------------------------------
wave:
	$(GTKWAVE) $(WAVE_DIR)/alu_top.vcd &

# -----------------------------------------------------------
# Clean generated files
# -----------------------------------------------------------
clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf $(WAVE_DIR)/*.vcd
	@echo "Clean complete."

.PHONY: all sim_top sim_core wave clean
