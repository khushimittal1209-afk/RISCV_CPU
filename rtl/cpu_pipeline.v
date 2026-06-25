module cpu_pipeline(
    input clk,
    input reset
);

wire [31:0] pc_current;
wire [31:0] next_pc;
wire [31:0] instruction;
wire [31:0] ifid_pc;
wire [31:0] ifid_instruction;

wire pc_write;
wire ifid_write;
wire control_mux;

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
wire [4:0] idex_rs1_addr;
wire [4:0] idex_rs2_addr;
 
wire [31:0] exmem_alu_result;
wire [31:0] exmem_rs2_data;
wire [4:0] exmem_rd;
wire exmem_reg_write;
wire exmem_mem_read;
wire exmem_mem_write;
wire exmem_mem_to_reg;

wire [31:0] memwb_mem_data;
wire [31:0] memwb_alu_result;
wire [4:0] memwb_rd;
wire memwb_reg_write;
wire memwb_mem_to_reg;

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

wire [1:0] forward_a;
wire [1:0] forward_b;
wire [31:0] alu_in1;
wire [31:0] alu_in2_pre_mux;

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
    .pc_write(pc_write),
    .next_pc(next_pc),
    .pc(pc_current)
);
// IF/ID pipeline register
if_id ifid_reg(
    .clk(clk),
    .reset(reset),
    .ifid_write(ifid_write),

    .pc_in(pc_current),
    .instruction_in(instruction),

    .pc_out(ifid_pc),
    .instruction_out(ifid_instruction)
);
// ID/EX pipeline register
id_ex idex_reg(
    .clk(clk),
    .reset(reset),
    .control_mux(control_mux),

    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),
    .imm_in(imm_out),
    .rs1_addr_in(ifid_instruction[19:15]),
    .rs2_addr_in(ifid_instruction[24:20]),
    .rs1_addr_out(idex_rs1_addr),
    .rs2_addr_out(idex_rs2_addr),

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
//EX/MEM pipeline register
ex_mem exmem_reg(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),
    .rs2_data_in(idex_rs2_data),

    .rd_in(idex_rd),

    .reg_write_in(idex_reg_write),
    .mem_read_in(idex_mem_read),
    .mem_write_in(idex_mem_write),
    .mem_to_reg_in(idex_mem_to_reg),

    .alu_result_out(exmem_alu_result),
    .rs2_data_out(exmem_rs2_data),

    .rd_out(exmem_rd),

    .reg_write_out(exmem_reg_write),
    .mem_read_out(exmem_mem_read),
    .mem_write_out(exmem_mem_write),
    .mem_to_reg_out(exmem_mem_to_reg)
);
//MEM/WB pipeline register
mem_wb memwb_reg(
    .clk(clk),
    .reset(reset),

    .memory_data_in(mem_data),
    .alu_result_in(exmem_alu_result),

    .rd_in(exmem_rd),

    .reg_write_in(exmem_reg_write),
    .mem_to_reg_in(exmem_mem_to_reg),

    .memory_data_out(memwb_mem_data),
    .alu_result_out(memwb_alu_result),

    .rd_out(memwb_rd),

    .reg_write_out(memwb_reg_write),
    .mem_to_reg_out(memwb_mem_to_reg)
);
//Forwarding unit
forwarding_unit fu(
    .idex_rs1(idex_rs1_addr),
    .idex_rs2(idex_rs2_addr),

    .exmem_rd(exmem_rd),
    .memwb_rd(memwb_rd),

    .exmem_reg_write(exmem_reg_write),
    .memwb_reg_write(memwb_reg_write),

    .forward_a(forward_a),
    .forward_b(forward_b)
);
//hazard detection unit
hazard_detection_unit hdu(

    .idex_mem_read(idex_mem_read),

    .idex_rd(idex_rd),

    .ifid_rs1(ifid_instruction[19:15]),
    .ifid_rs2(ifid_instruction[24:20]),

    .pc_write(pc_write),
    .ifid_write(ifid_write),
    .control_mux(control_mux)

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
    .rd_addr(memwb_rd),
    .reg_write(memwb_reg_write),
    .clk(clk),
    .reset(reset),
    .rd_data(write_back_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);
assign alu_in1 =(forward_a == 2'b10) ? exmem_alu_result :(forward_a == 2'b01) ? write_back_data :idex_rs1_data;
assign alu_in2_pre_mux =(forward_b == 2'b10) ? exmem_alu_result :(forward_b == 2'b01) ? write_back_data :idex_rs2_data;
// ALU Input MUX
assign alu_b = (idex_alu_src) ? idex_imm : alu_in2_pre_mux;
// ALU
alu alu_inst(
    .a(alu_in1),
    .b(alu_b),
    .control_signal(idex_alu_control),
    .result(alu_result),
    .zero(zero)
);
// Data Memory
data_memory dmem(
    .clk(clk),
    .mem_read(exmem_mem_read),
    .mem_write(exmem_mem_write),
    .address(exmem_alu_result),
    .write_data(exmem_rs2_data),
    .read_data(mem_data)
);

// Write Back MUX
assign write_back_data =
    memwb_mem_to_reg ?
        memwb_mem_data :
        memwb_alu_result;

endmodule