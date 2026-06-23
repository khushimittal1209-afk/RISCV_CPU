module alu_tb;
reg [31:0] a;
reg [31:0] b;
reg [2:0] control_signal;
wire [31:0] result;
wire zero;
initial begin
    $monitor("t=%0t a=%d b=%d ctrl=%b result=%d zero=%b",
              $time,a,b,control_signal,result,zero);
end
initial 
begin
a=32'd32;
b=32'd20;
control_signal=3'b000;
#10; 
a=32'd32;
b=32'd20;
control_signal=3'b001;
#10;
a=32'd32;
b=32'd20;
control_signal=3'b010;
#10;
a=32'd32;
b=32'd20;
control_signal=3'b011;
#10;
a=32'd32;
b=32'd20;
control_signal=3'b100;
#10;
a=32'd20;
b=32'd20;
control_signal=3'b001;
#10;
 $finish;
end
initial
begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);
end
alu dut(.a(a),
.b(b),
.control_signal(control_signal),
.result(result),
.zero(zero)
);
endmodule