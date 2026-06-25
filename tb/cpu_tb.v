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

    #200;
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
always @(negedge clk) begin
    $display("--------------------------------");
    $display("PC=%d", dut.pc_current);

    $display("IFID Inst  = %h", dut.ifid_instruction);

    $display("IDEX rs1=%0d rs2=%0d",
        dut.idex_rs1_addr,
        dut.idex_rs2_addr);

    $display("IDEX data1=%0d data2=%0d",
        dut.idex_rs1_data,
        dut.idex_rs2_data);

    $display("forwardA=%b forwardB=%b",
        dut.forward_a,
        dut.forward_b);

    $display("alu_in1=%0d alu_b=%0d zero=%b",
        dut.alu_in1,
        dut.alu_b,
        dut.zero);

    $display("branch=%b branch_taken=%b flush=%b",
        dut.branch,
        dut.branch_taken,
        dut.flush);
        $display("idex_pc      = %d", dut.idex_pc);
$display("idex_imm     = %d", dut.idex_imm);
$display("next_pc      = %d", dut.next_pc);
end

initial begin
    #200;
$display("flush = %b", dut.flush);

$display("x1 = %d", dut.rf.reg_mem[1]);
$display("x2 = %d", dut.rf.reg_mem[2]);
$display("x3 = %d", dut.rf.reg_mem[3]);
$display("x4 = %d", dut.rf.reg_mem[4]);
$display("branch       = %b", dut.branch);
$display("branch_ne    = %b", dut.branch_ne);
$display("zero         = %b", dut.zero);
$display("branch_taken = %b", dut.branch_taken);

$display("rs1_data     = %d", dut.idex_rs1_data);
$display("rs2_data     = %d", dut.idex_rs2_data);

$display("alu_result   = %d", dut.alu_result);

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