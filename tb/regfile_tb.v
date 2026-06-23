module regfile_tb;
reg clk;
reg reset;
reg [4:0] rs1_addr;
reg [4:0] rs2_addr;
reg [4:0] rd_addr;
reg [31:0] rd_data;
reg reg_write;
wire [31:0]  rs1_data;
wire [31:0]  rs2_data;
initial 
begin 
clk=0;
forever #5 clk=~clk;
end
initial 
begin
reset = 1;
reg_write = 0;
rs1_addr = 0;
rs2_addr = 0;
rd_addr = 0;
rd_data = 0;
#10; 
reset =0;
reg_write = 1;
rd_addr = 5;
rd_data = 32'd20;
#10; 
rs1_addr=5;
rs2_addr=0;
#10;
rd_addr = 0;
rd_data = 100;
reg_write = 1;
#10; 
rs1_addr = 0;
rs2_addr = 2;
#10; 
reset =1;
#10;
reset=0;
rs1_addr =1;
rs2_addr = 2;
#10; $finish;
end
initial
begin
    $dumpfile("regfile.vcd");
    $dumpvars(0, regfile_tb);
end
regfile dut(
    .clk(clk),
    .reset(reset),
    .rs1_addr(rs1_addr),
.rs2_addr(rs2_addr),
.rd_addr(rd_addr),
.rd_data(rd_data),
.reg_write(reg_write),
.rs1_data(rs1_data),
.rs2_data(rs2_data)
);
endmodule