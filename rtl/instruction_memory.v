module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin
memory[0] = 32'h008000EF; // jal x1,+8

memory[1] = 32'h00100113; // addi x2,x0,1

memory[2] = 32'h00200113; // addi x2,x0,2

end



assign instruction = memory[address[9:2]];

endmodule