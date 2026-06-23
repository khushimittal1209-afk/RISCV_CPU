module alu(input [31:0] a,
input [31:0] b,
input [2:0] control_signal,
output reg [31:0] result,
output zero
);
parameter ADD = 3'b000,
          SUB = 3'b001,
          OR  = 3'b010,
          AND = 3'b011,
          XOR = 3'b100;
always @(*)
begin
    case(control_signal)
    ADD: result=a+b;
    SUB: result=a-b;
    AND: result=a&b;
    OR: result=a|b;
    XOR: result=a^b;
    default: result=32'b0;
    endcase
end 
assign zero = (result == 32'b0);
endmodule