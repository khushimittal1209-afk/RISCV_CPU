module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];
initial begin

memory[0] = 32'h12345097;// auipc x1,0x12345



end



assign instruction = memory[address[9:2]];

endmodule