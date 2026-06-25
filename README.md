# RISC-V CPU (RV32I)

## Progress

### Completed Modules
- Program Counter (PC)
- Register File
- ALU
- Immediate Generator
- Control Unit
- Instruction Memory
- Data Memory

### Verification
All modules verified using custom Verilog testbenches and GTKWave.

### Current CPU Status
Successfully executed:

addi x1,x0,10
addi x2,x0,20
add  x3,x1,x2

Results:
- x1 = 10
- x2 = 20
- x3 = 30

### Tools
- Verilog
- Icarus Verilog
- GTKWave
- VS Code

### Next Steps
- Load/Store verification
- Branch instructions
- Single-cycle CPU completion
- Pipeline implementation
- Hazard Detection
- Forwarding Unit
# Debugging Report: Register File Timing Issue During Pipeline Forwarding

## Problem Encountered

After implementing the 5-stage pipelined RISC-V CPU and the forwarding unit, the processor correctly executed simple dependent instructions such as:

```assembly
addi x1, x0, 5
addi x2, x0, 20
add  x3, x1, x2
```

However, a longer dependency chain produced an incorrect result:

```assembly
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
add  x4, x3, x1
```

### Expected Output

```
x1 = 5
x2 = 10
x3 = 15
x4 = 20
```

### Actual Output

```
x1 = 5
x2 = 10
x3 = 15
x4 = 15
```

The forwarding unit successfully forwarded the value of **x3**, but the second operand (**x1**) was read as **0**, causing the ALU to compute:

```
15 + 0 = 15
```

instead of:

```
15 + 5 = 20
```

---

# Debugging Process

To isolate the problem, cycle-by-cycle debugging was added to the CPU. The following signals were monitored every clock cycle:

- Program Counter (PC)
- Current instruction
- Source register addresses
- Destination register addresses
- Forwarding control signals (`forward_a`, `forward_b`)
- Register file outputs
- ALU inputs
- ALU result

The debug output for the failing instruction showed:

```
Time = 65

Instruction   = add x4, x3, x1

idex_rs1_addr = 3
idex_rs2_addr = 1

forward_a = 10
forward_b = 00

idex_rs1_data = 0
idex_rs2_data = 0

alu_in1 = 15
alu_b   = 0

alu_result = 15
```

From this observation:

- EX/MEM forwarding was working correctly.
- The forwarding unit selected the correct source for operand A.
- Operand B was not forwarded (which is correct).
- The register file supplied an outdated value for **x1**.

This confirmed that the issue was **not** in the forwarding logic but in the timing of the register file.

---

# Root Cause

The register file originally wrote data on the **positive clock edge**.

```verilog
always @(posedge clk)
```

At the same positive edge:

1. The Write-Back stage updated the destination register.
2. The ID/EX pipeline register captured the register file outputs.

Since both operations occurred simultaneously, the Decode stage captured the **old register value** before the write became visible.

As a result, instructions depending on a value written back in the same cycle received stale data.

---

# Solution

The register file write operation was moved to the **negative clock edge**.

```verilog
always @(negedge clk)
```

This changed the timing to:

```
Positive Edge
-------------
Decode Stage reads register file
ID/EX captures operands

Negative Edge
-------------
Write-Back updates register file
```

By the next positive edge, the updated register value was already available for reading, eliminating the timing conflict.

---

# Verification

After applying the fix, the debug output became:

```
Time = 65

forward_a = 10
forward_b = 00

idex_rs2_data = 5

alu_in1 = 15
alu_b   = 5

alu_result = 20
```

Final register values:

```
x1 = 5
x2 = 10
x3 = 15
x4 = 20
```

The forwarding unit and pipeline operated correctly after the timing fix.

---

# Key Learnings

- The forwarding unit was functioning correctly; the actual issue was the timing of register file writes.
- Pipeline bugs are not always caused by forwarding or hazard detection logic. Register file timing is equally important.
- Cycle-by-cycle signal monitoring proved to be the most effective debugging technique for identifying the issue.
- Writing the register file on the negative clock edge is a common educational technique that avoids same-cycle read-after-write conflicts in simple pipelined processor implementations.