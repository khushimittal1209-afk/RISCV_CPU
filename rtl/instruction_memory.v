module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin
memory[0] = 32'h00500093; // addi x1,x0,5

memory[1] = 32'h00200113; // addi x2,x0,2

memory[2] = 32'h002091B3; // sll x3,x1,x2

memory[3] = 32'h0020D233; // srl x4,x1,x2

memory[4] = 32'h4020D2B3; // sra x5,x1,x2
end


assign instruction = memory[address[9:2]];

endmodule