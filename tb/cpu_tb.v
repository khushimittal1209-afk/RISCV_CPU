module cpu_tb;

reg clk;
reg reset;

cpu_pipeline dut(
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

    #120;
    $finish;
end
// Monitor
/*initial begin
 $monitor(
"t=%0t pc=%d inst=%h rd=%d alu=%d",
$time,
dut.pc_current,
dut.ifid_instruction,
dut.idex_rd,
dut.alu_result
);
end*/
always @(posedge clk)
begin
    $display("--------------------------------");
    $display("time=%0t", $time);

    $display("PC=%d", dut.pc_current);

    $display("pc_write=%b", dut.pc_write);
    $display("ifid_write=%b", dut.ifid_write);
    $display("control_mux=%b", dut.control_mux);

    $display("Instruction=%h", dut.ifid_instruction);
end
initial begin
    #100;
$display("x1 = %d", dut.rf.reg_mem[1]);
$display("x2 = %d", dut.rf.reg_mem[2]);
$display("pc_write     = %b", dut.pc_write);
$display("ifid_write   = %b", dut.ifid_write);
$display("control_mux  = %b", dut.control_mux);

/* $display("idex_rd    = %d", dut.idex_rd);
$display("exmem_rd   = %d", dut.exmem_rd);
$display("memwb_rd   = %d", dut.memwb_rd);

$display("alu_result = %d", dut.alu_result);
$display("exmem_alu  = %d", dut.exmem_alu_result);
$display("memwb_alu  = %d", dut.memwb_alu_result);
$display("idex_alu_ctrl = %b", dut.idex_alu_control);*/

    $finish;
end
// Waveform Dump
initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu_tb);
    $dumpvars(0,dut.rf);
end

endmodule