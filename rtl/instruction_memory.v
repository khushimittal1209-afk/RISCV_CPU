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
    // add x3,x1,x2
    memory[2] = 32'h002081B3;
    // sw x3,0(x0)
    memory[3] = 32'h00302023;
    // lw x4,0(x0)
    memory[4] = 32'h00002203;
end


assign instruction = memory[address[9:2]];

endmodule