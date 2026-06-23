module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg branch,
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg [2:0] alu_control
);parameter ADD = 3'b000,
          SUB = 3'b001,
          OR  = 3'b010,
          AND = 3'b011,
          XOR = 3'b100;
always @(*)
begin
    branch = 0;
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

        {7'b0000000,3'b000}:
            alu_control = ADD;

        {7'b0100000,3'b000}:
            alu_control = SUB;

        {7'b0000000,3'b110}:
            alu_control = OR;

        {7'b0000000,3'b111}:
            alu_control = AND;

        {7'b0000000,3'b100}:
            alu_control = XOR;
        default:
        alu_control = ADD;
        endcase
    end
    7'b0010011:
    begin
         reg_write = 1;
        alu_src   = 1;
        mem_read = 0;
        mem_write = 0;
        alu_control = ADD;
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
    branch = 1;
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