module imm_gen(
    input [31:0] instruction,
    input [6:0] opcode,
    output reg [31:0] imm_out
);
always @(*)
begin
    case(opcode)
    7'b0010011: imm_out={{20 {instruction[31]}},instruction[31:20]};
    7'b0100011: imm_out={{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    7'b0000011:imm_out = {{20{instruction[31]}},instruction[31:20]};
    default:imm_out = 32'b0;
    endcase
end
endmodule
