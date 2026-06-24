module if_id_tb;

reg clk;
reg reset;

reg [31:0] pc_in;
reg [31:0] instruction_in;

wire [31:0] pc_out;
wire [31:0] instruction_out;

if_id dut(
    .clk(clk),
    .reset(reset),
    .pc_in(pc_in),
    .instruction_in(instruction_in),
    .pc_out(pc_out),
    .instruction_out(instruction_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    pc_in = 32'd4;
    instruction_in = 32'h00500093;

    #10;

    $display("PC = %d", pc_out);
    $display("INST = %h", instruction_out);

    $finish;
end

endmodule