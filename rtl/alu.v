module alu(input [31:0] a,
    input [31:0] b,
    input [3:0] control_signal,
    output reg [31:0] result,
    output zero
);
parameter ADD = 4'b0000,
          SUB = 4'b0001,
          OR  = 4'b0010,
          AND = 4'b0011,
          XOR = 4'b0100,
          SLT = 4'b0101,
          SLL = 4'b0110,
          SRL = 4'b0111,
          SRA = 4'b1000;
always @(*) begin
    case(control_signal)
        ADD: result = a + b;
        SUB: result = a - b;
        AND: result = a & b;
        OR : result = a | b;
        XOR: result = a ^ b;
        SLT: result = (a < b) ? 32'd1 : 32'd0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = $signed(a) >>> b[4:0];
        default: result = 32'b0;
    endcase
end
assign zero = (result == 32'b0);
endmodule