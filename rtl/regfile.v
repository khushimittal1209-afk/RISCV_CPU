module regfile(input [4:0] rs1_addr,
input [4:0] rs2_addr,
input clk,
input reset,
input [4:0] rd_addr,
input [31:0] rd_data,
input reg_write,
output [31:0]  rs1_data,
output [31:0]  rs2_data
); 
reg [31:0]  reg_mem [31:0] ;
integer i;
always @(posedge clk)
begin
    if(reset) 
    for(i=0;i<32;i=i+1) reg_mem[i] <= 32'b0;
    else if(reg_write && (rd_addr != 5'b0))
    reg_mem[rd_addr]<=rd_data;
end
assign rs1_data = (rs1_addr == 0) ? 32'b0 : reg_mem[rs1_addr];
assign rs2_data = (rs2_addr == 0) ? 32'b0 : reg_mem[rs2_addr];
endmodule

