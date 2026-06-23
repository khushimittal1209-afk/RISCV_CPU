module pc_tb;
reg clk;
reg reset;
reg [31:0] next_pc;
wire [31:0] pc;
initial 
begin 
clk=0;
forever #5 clk=~clk;
end
initial 
begin
reset = 1;
next_pc=0;
#10; reset =0;
next_pc=4;
#10; next_pc=8;
#10; next_pc=12;
#10; $finish;
end
initial
begin
    $dumpfile("pc.vcd");
    $dumpvars(0, pc_tb);
end
pc dut(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);
endmodule