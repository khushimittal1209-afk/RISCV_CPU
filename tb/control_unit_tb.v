module control_unit_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire [2:0] alu_control;

initial begin
    $monitor(
    "t=%0t opcode=%b funct3=%b funct7=%b reg_write=%b alu_src=%b mem_read=%b mem_write=%b alu_control=%b",
    $time, opcode, funct3, funct7,
    reg_write, alu_src, mem_read, mem_write, alu_control);
end

initial begin

    // ADD
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // SUB
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #10;

    // OR
    opcode = 7'b0110011;
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    #10;

    // AND
    opcode = 7'b0110011;
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    #10;

    // XOR
    opcode = 7'b0110011;
    funct3 = 3'b100;
    funct7 = 7'b0000000;
    #10;

    // ADDI
    opcode = 7'b0010011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // LW
    opcode = 7'b0000011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;
    #10;

    // SW
    opcode = 7'b0100011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;
    #10;

    $finish;
end

initial begin
    $dumpfile("control_unit.vcd");
    $dumpvars(0, control_unit_tb);
end

control_unit dut(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_control(alu_control)
);

endmodule