# 3-Stage Pipelined ALU

**Designer:** Yogita Jangra  
**Date:** Feb 2026 – Mar 2026  
**Tools:** Verilog HDL, Vivado, Icarus Verilog, GTKWave, Linux

---

## Project Description

A **3-stage pipelined ALU** designed in Verilog to improve throughput and reduce critical path delay. The pipeline consists of three stages — **Fetch**, **Decode**, and **Execute** — enabling parallel processing of multiple instructions across clock cycles.

---

## Pipeline Architecture

```
 ┌───────────┐     ┌───────────┐     ┌───────────┐
 │   FETCH   │ ──► │  DECODE   │ ──► │  EXECUTE  │
 │  (Stage 1)│     │  (Stage 2)│     │  (Stage 3)│
 └───────────┘     └───────────┘     └───────────┘
      │                  │                  │
  Latch inputs     Pass operands &    Perform ALU
  into pipeline    decoded opcode     operation and
  registers        to next stage      output result
```

---

## Supported Operations

| Opcode | Operation    | Description          |
|--------|-------------|----------------------|
| 000    | ADD         | Addition (A + B)     |
| 001    | SUB         | Subtraction (A - B)  |
| 010    | AND         | Bitwise AND (A & B)  |
| 011    | OR          | Bitwise OR (A \| B)  |
| 100    | XOR         | Bitwise XOR (A ^ B)  |

---

## File Structure

```
pipelined-alu/
├── README.md
├── Makefile
├── .gitignore
│
├── rtl/
│   ├── alu_top.v            # Top module: connects the 3 stages
│   ├── fetch_stage.v        # Stage 1: latch operands and opcode
│   ├── decode_stage.v       # Stage 2: decode opcode, select operation
│   ├── execute_stage.v      # Stage 3: ADD, SUB, AND, OR, XOR
│   ├── alu_core.v           # Combinational arithmetic/logic unit
│   └── pipeline_regs.v      # IF/ID and ID/EX pipeline registers
│
├── tb/
│   ├── alu_top_tb.v         # Main testbench with self-checking
│   ├── alu_core_tb.v        # Unit test for the ALU alone
│   └── test_vectors.mem     # Optional input/expected-output vectors
│
├── sim/
│   ├── waves/               # Waveform dump (open in GTKWave)
│   └── build/               # Compiled output (e.g. alu_sim.vvp)
│
├── vivado/
│   ├── constraints/
│   │   └── alu.xdc          # Clock constraint for timing analysis
│   ├── scripts/
│   │   └── run_synth.tcl    # Batch synthesis/timing script
│   └── reports/             # Synthesis/timing/utilization reports
│
└── docs/
    ├── pipeline_diagram.md  # Fetch → Decode → Execute block diagram (text)
    └── notes.md             # Design decisions, hazard handling
```

---

## How to Simulate

### Using Makefile (Linux / Icarus Verilog)

```bash
# Run full pipeline simulation
make sim_top

# Run ALU core unit test
make sim_core

# Open waveform in GTKWave
make wave

# Clean build directory
make clean
```

### Using Vivado

```bash
# Run batch synthesis
vivado -mode batch -source vivado/scripts/run_synth.tcl
```
