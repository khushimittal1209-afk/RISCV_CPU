module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg branch,
    output reg branch_ne,
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg [3:0] alu_control
);parameter ADD = 4'b0000,
          SUB = 4'b0001,
          OR  = 4'b0010,
          AND = 4'b0011,
          XOR = 4'b0100,
          SLT = 4'b0101,
          SLL = 4'b0110,
          SRL = 4'b0111,
          SRA = 4'b1000;
always @(*)
begin
    branch = 0;
    branch_ne = 0;
    reg_write = 0;
    alu_src = 0;
    mem_read = 0;
    mem_write = 0;
    alu_control = ADD;
    case(opcode)
    7'b0110011:
    begin
        reg_write = 1;
        alu_src   = 0;
        mem_read = 0;
        mem_write = 0;
        case({funct7,funct3})
        {7'b0000000,3'b000}:alu_control = ADD;
        {7'b0100000,3'b000}: alu_control = SUB;
        {7'b0000000,3'b110}:alu_control = OR;
        {7'b0000000,3'b111}:alu_control = AND;
        {7'b0000000,3'b100}:alu_control = XOR;
        {7'b0000000,3'b010}: alu_control = SLT;
        {7'b0000000,3'b001}:alu_control = SLL;
        {7'b0000000,3'b101}:alu_control = SRL;
        {7'b0100000,3'b101}:alu_control = SRA;
        default:alu_control = ADD;
        endcase
    end
    7'b0010011:
    begin
        reg_write = 1;
        alu_src   = 1;
        mem_read  = 0;
        mem_write = 0;
        case(funct3)
        3'b000: alu_control = ADD; // ADDI
        3'b111: alu_control = AND; // ANDI
        3'b110: alu_control = OR;  // ORI
        3'b100: alu_control = XOR; // XORI
        3'b001: alu_control = SLL; // SLLI
        3'b101:
        begin
            if(funct7 == 7'b0000000)
                alu_control = SRL; // SRLI
            else if(funct7 == 7'b0100000)
                alu_control = SRA; // SRAI
        end
        default:alu_control = ADD;
        endcase
    end
    7'b0000011:
    begin
         reg_write = 1;
        alu_src   = 1;
        mem_read = 1;
        mem_write = 0;
        alu_control = ADD;
    end
    7'b0100011:
    begin
        reg_write = 0;
        alu_src   = 1;
        mem_read = 0;
        mem_write = 1;
        alu_control = ADD;
    end
    7'b1100011:
    begin
    case(funct3)
        3'b000: branch    = 1; // BEQ
        3'b001: branch_ne = 1; // BNE
    endcase
    reg_write = 0;
    alu_src = 0;
    mem_read = 0;
    mem_write = 0;
    alu_control = SUB;
end
    default:
begin
    reg_write  = 0;
    alu_src    = 0;
    mem_read   = 0;
    mem_write  = 0;
    alu_control = ADD;
end
    endcase
end
endmodule