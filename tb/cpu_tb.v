`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg reset;

cpu_pipeline dut(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu_tb);

    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    #200;

    $display("--------------------------------");
    $display("Forwarding Test");
    $display("--------------------------------");

    $display("x1 = %d (Expected 5)",  dut.rf.reg_mem[1]);
    $display("x2 = %d (Expected 10)", dut.rf.reg_mem[2]);
    $display("x3 = %d (Expected 15)", dut.rf.reg_mem[3]);
    $display("x4 = %d (Expected 20)", dut.rf.reg_mem[4]);
    $display("x5 = %d (Expected 30)", dut.rf.reg_mem[5]);

    $finish;
end

endmodule