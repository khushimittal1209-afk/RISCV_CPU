module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin

    // addi x1,x0,10
    memory[0] = 32'h00A00093;

    // addi x2,x0,20
    memory[1] = 32'h01400113;

    // bne x1,x2,+8
    memory[2] = 32'h00209463;

    // addi x3,x0,1
    memory[3] = 32'h00100193;

    // addi x3,x0,2
    memory[4] = 32'h00200193;

end


assign instruction = memory[address[9:2]];

endmodule