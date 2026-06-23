module imm_gen_tb;
reg [31:0] instruction;
wire [31:0]  imm_out;
initial begin
   $monitor("t=%0t instruction=%h imm_out=%h",
          $time,instruction,imm_out);
end
initial 
begin
instruction = 32'b00000000101000000000001010010011;
#10; 
instruction = 32'b11111111111100000000001010010011;
#10;
instruction = 32'b11111111100000000000001010010011;
#10;
instruction = 32'b00000111111100000000001010010011;
#10;
instruction = 32'b10000000000000000000001010010011;
#10;
 $finish;
end
initial
begin
    $dumpfile("imm_gen.vcd");
    $dumpvars(0, imm_gen_tb);
end
imm_gen dut(.instruction(instruction),.imm_out(imm_out)
);
endmodule