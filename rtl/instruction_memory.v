module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin

    // addi x1,x0,5
    memory[0] = 32'h00500093;

    // slli x2,x1,2
    memory[1] = 32'h00209113;

    // srli x3,x2,2
    memory[2] = 32'h00215193;

    // srai x4,x2,2
    memory[3] = 32'h40215213;

end



assign instruction = memory[address[9:2]];

endmodule