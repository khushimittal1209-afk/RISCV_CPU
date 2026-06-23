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