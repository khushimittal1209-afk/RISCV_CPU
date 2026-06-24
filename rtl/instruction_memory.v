module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin
memory[0] = 32'h00D00093; // addi x1,x0,13

memory[1] = 32'h00F0F113; // andi x2,x1,15

memory[2] = 32'h0040E193; // ori x3,x1,4

memory[3] = 32'h0070C213; // xori x4,x1,7
end


assign instruction = memory[address[9:2]];

endmodule