# Design Notes — 3-Stage Pipelined ALU

**Designer:** Yogita Jangra  
**Date:** Feb 2026 – Mar 2026

---

## Design Decisions

### Why 3-Stage Pipeline?
- Splitting the ALU into Fetch → Decode → Execute allows each stage to do less work per clock cycle, which **reduces the critical path delay**.
- The pipeline enables **parallel processing** — while one instruction is being executed, the next is being decoded, and another is being fetched.
- Throughput improves because a new result is produced **every clock cycle** (after the initial 3-cycle latency to fill the pipeline).

### Module Breakdown
| Module         | Role                                              |
|----------------|---------------------------------------------------|
| `alu_core`     | Pure combinational ALU — no clock, instant result  |
| `pipeline_regs`| Parameterized D flip-flop register (reusable)      |
| `fetch_stage`  | Latches inputs using pipeline_regs (IF/ID boundary)|
| `decode_stage` | Passes operands forward (ID/EX boundary)           |
| `execute_stage`| Calls alu_core, registers the output               |
| `alu_top`      | Wires all three stages together                    |

### Operand Width
- **8-bit operands** with a **9-bit result** — the extra bit handles carry/overflow in addition (e.g., 200 + 100 = 300 needs 9 bits).

---

## Data Dependency Handling

In this basic design, data dependencies are handled at the **architectural level**:
- Each instruction flows independently through the pipeline.
- The `valid` signal indicates when the output corresponds to a valid instruction (it goes high after the pipeline fills — 3 clock cycles after reset).
- For back-to-back dependent operations, the **software/testbench must account for the 3-cycle latency** before reading the result.

> **Note:** This design does not implement forwarding or hazard detection hardware. For a basic ALU pipeline, this is acceptable since each operation is independent.

---

## Timing & Performance
- Target clock: **100 MHz** (10 ns period)
- Critical path is within the `alu_core` (combinational ADD/SUB), which is short enough for 100 MHz since it only operates on 8-bit values.
- Pipelining ensures that the combinational path in any single stage is minimal.

---

## Simulation Flow
1. **Icarus Verilog** compiles all RTL + testbench into a `.vvp` simulation executable
2. **VVP** runs the simulation and generates a `.vcd` waveform file
3. **GTKWave** opens the VCD file for visual waveform analysis
4. **Vivado** can be used for synthesis, timing analysis, and FPGA implementation
