module if_id(
    input clk,
    input reset,
    input ifid_write,
    input flush,

    input [31:0] pc_in,
    input [31:0] instruction_in,

    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        pc_out <= 32'b0;
        instruction_out <= 32'b0;
    end
    else if(flush)
    begin
        pc_out <= 32'b0;
        instruction_out <= 32'h00000013;   // NOP = addi x0,x0,0
    end
    else if(ifid_write)
    begin
        pc_out <= pc_in;
        instruction_out <= instruction_in;
    end
end
endmodule