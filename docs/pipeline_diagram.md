# Pipeline Diagram — Placeholder

Since a PNG diagram could not be auto-generated, here is the text-based pipeline diagram:

```
                         CLK ↓              CLK ↓              CLK ↓
                    ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
  operand_a ──────►│              │   │              │   │              │
  operand_b ──────►│    FETCH     │──►│    DECODE    │──►│   EXECUTE    │──► result [8:0]
  opcode    ──────►│  (Stage 1)   │   │  (Stage 2)   │   │  (Stage 3)   │──► valid
                    │              │   │              │   │              │
                    │ Latch inputs │   │ Pass operands│   │  ALU Core:   │
                    │ into pipeline│   │ & decoded    │   │  ADD, SUB,   │
                    │ registers    │   │ opcode       │   │  AND, OR,    │
                    │              │   │ forward      │   │  XOR         │
                    └──────┬───────┘   └──────┬───────┘   └──────────────┘
                           │                  │
                      IF/ID Regs         ID/EX Regs
                    (pipeline_regs)    (pipeline_regs)
```

## Timing Diagram (Conceptual)

```
Clock:    ──┐  ┌──┐  ┌──┐  ┌──┐  ┌──┐  ┌──┐  ┌──
            └──┘  └──┘  └──┘  └──┘  └──┘  └──┘

Cycle:      1     2     3     4     5     6

Instr A:  [FETCH][DEC] [EXEC]
Instr B:        [FETCH][DEC] [EXEC]
Instr C:              [FETCH][DEC] [EXEC]
                                    ↑
                              Result A ready here
```
