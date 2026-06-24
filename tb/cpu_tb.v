module cpu_tb;

reg clk;
reg reset;

cpu dut(
    .clk(clk),
    .reset(reset)
);
// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
// Reset
initial begin
    reset = 1;
    #10;
    reset = 0;

    #100;
    $finish;
end
// Monitor
initial begin
    #100;

    $display("x1 = %0d", dut.rf.reg_mem[1]);
    $display("x2 = %0d", dut.rf.reg_mem[2]);
    $display("x3 = %0d", dut.rf.reg_mem[3]);
    $display("x4 = %0d", dut.rf.reg_mem[4]);
   // $display("x5 = %0d", dut.rf.reg_mem[5]);

    $finish;
end
// Waveform Dump
initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu_tb);
    $dumpvars(0,dut.rf);
end

endmodule