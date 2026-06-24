module cpu_pipeline(
    input clk,
    input reset
);

wire [31:0] pc_current;
wire [31:0] next_pc;
wire [31:0] instruction;
wire [31:0] ifid_pc;
wire [31:0] ifid_instruction;

wire [31:0] idex_rs1_data;
wire [31:0] idex_rs2_data;
wire [31:0] idex_imm;
wire [4:0] idex_rd;
wire [3:0] idex_alu_control;
wire idex_reg_write;
wire idex_mem_read;
wire idex_mem_write;
wire idex_mem_to_reg;
wire idex_alu_src;

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
// IF/ID pipeline register
if_id ifid_reg(
    .clk(clk),
    .reset(reset),

    .pc_in(pc_current),
    .instruction_in(instruction),

    .pc_out(ifid_pc),
    .instruction_out(ifid_instruction)
);
// ID/EX pipeline register
id_ex idex_reg(
    .clk(clk),
    .reset(reset),

    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),
    .imm_in(imm_out),

    .rd_in(ifid_instruction[11:7]),

    .alu_control_in(alu_control),

    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),
    .mem_to_reg_in(mem_read), // temporary
    .alu_src_in(alu_src),

    .rs1_data_out(idex_rs1_data),
    .rs2_data_out(idex_rs2_data),
    .imm_out(idex_imm),

    .rd_out(idex_rd),

    .alu_control_out(idex_alu_control),

    .reg_write_out(idex_reg_write),
    .mem_read_out(idex_mem_read),
    .mem_write_out(idex_mem_write),
    .mem_to_reg_out(idex_mem_to_reg),
    .alu_src_out(idex_alu_src)
);
// Instruction Memory
instruction_memory imem(
    .address(pc_current),
    .instruction(instruction)
);
// Control Unit
control_unit cu(
    .opcode(ifid_instruction[6:0]),
    .funct3(ifid_instruction[14:12]),
    .funct7(ifid_instruction[31:25]),
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
    .instruction(ifid_instruction),
    .opcode(ifid_instruction[6:0]),
    .imm_out(imm_out)
);

// Register File
regfile rf(
    .rs1_addr(ifid_instruction[19:15]),
    .rs2_addr(ifid_instruction[24:20]),
    .rd_addr(ifid_instruction[11:7]),
    .clk(clk),
    .reset(reset),
    .rd_data(write_back_data),
    .reg_write(idex_reg_write),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);
// ALU Input MUX
assign alu_b = (idex_alu_src) ? idex_imm : idex_rs2_data;

// ALU
alu alu_inst(
    .a(idex_rs1_data),
    .b(alu_b),
    .control_signal(idex_alu_control),
    .result(alu_result),
    .zero(zero)
);
// Data Memory
data_memory dmem(
    .clk(clk),
    .mem_read(idex_mem_read),
    .mem_write(idex_mem_write),
    .address(alu_result),
    .write_data(idex_rs2_data),
    .read_data(mem_data)
);

// Write Back MUX
assign write_back_data =
    jal   ? (pc_current + 4) :
    lui   ? imm_out :
    auipc ? (pc_current + imm_out) :
    (mem_read ? mem_data : alu_result);

endmodule