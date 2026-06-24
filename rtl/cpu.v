module cpu(
    input clk,
    input reset
);

wire [31:0] pc_current;
wire [31:0] next_pc;
wire [31:0] instruction;

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire [3:0] alu_control;
wire branch;
wire zero;
wire branch_ne;
wire jal;
wire lui;
wire auipc;

wire [31:0] imm_out;

wire [31:0] rs1_data;
wire [31:0] rs2_data;

wire [31:0] alu_b;
wire [31:0] alu_result;

wire [31:0] mem_data;
wire [31:0] write_back_data;
// PC
wire branch_taken;
assign branch_taken =(branch    && zero) ||(branch_ne && !zero);
assign next_pc =jal ? (pc_current + imm_out) :branch_taken ? (pc_current + imm_out) :(pc_current + 4);

pc pc_inst(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc_current)
);
// Instruction Memory
instruction_memory imem(
    .address(pc_current),
    .instruction(instruction)
);
// Control Unit
control_unit cu(
    .opcode(instruction[6:0]),
    .funct3(instruction[14:12]),
    .funct7(instruction[31:25]),
    .branch(branch),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_control(alu_control),
    .jal(jal),
    .lui(lui),
    .auipc(auipc),
    .branch_ne(branch_ne)
);

// Immediate Generator
imm_gen imm(
    .instruction(instruction),
    .opcode(instruction[6:0]),
    .imm_out(imm_out)
);

// Register File
regfile rf(
    .rs1_addr(instruction[19:15]),
    .rs2_addr(instruction[24:20]),
    .clk(clk),
    .reset(reset),
    .rd_addr(instruction[11:7]),
    .rd_data(write_back_data),
    .reg_write(reg_write),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);
// ALU Input MUX
assign alu_b = (alu_src) ? imm_out : rs2_data;

// ALU
alu alu_inst(
    .a(rs1_data),
    .b(alu_b),
    .control_signal(alu_control),
    .result(alu_result),
    .zero(zero)
);
// Data Memory
data_memory dmem(
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(alu_result),
    .write_data(rs2_data),
    .read_data(mem_data)
);

// Write Back MUX
assign write_back_data =
    jal   ? (pc_current + 4) :
    lui   ? imm_out :
    auipc ? (pc_current + imm_out) :
    (mem_read ? mem_data : alu_result);

endmodule