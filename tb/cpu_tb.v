`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg reset;

cpu_pipeline dut(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;
always @(posedge clk)
begin
  /*  $display("--------------------------------");
    $display("PC=%d", dut.pc_current);
    $display("Instruction=%h", dut.ifid_instruction);
    $display("opcode=%b", dut.ifid_instruction[6:0]);
    $display("mem_write(control)=%b", dut.mem_write);
    $display("idex_mem_write=%b", dut.idex_mem_write);
    $display("control_mux=%b", dut.control_mux);
    $display("alu_result         = %d", dut.exmem_alu_result);
$display("store_data         = %d", dut.exmem_rs2_data);
$display("mem_write          = %b", dut.exmem_mem_write);
$display("memory[0]          = %d", dut.dmem.memory[0]);
$display("rs1_addr = %d", dut.ifid_instruction[19:15]);
$display("rs2_addr = %d", dut.ifid_instruction[24:20]);
$display("----------- WB Stage -----------");
$display("exmem_mem_read    = %b", dut.exmem_mem_read);
$display("exmem_mem_to_reg  = %b", dut.exmem_mem_to_reg);
$display("mem_data          = %d", dut.mem_data);

$display("memwb_rd          = %d", dut.memwb_rd);
$display("memwb_reg_write   = %b", dut.memwb_reg_write);
$display("memwb_mem_to_reg  = %b", dut.memwb_mem_to_reg);

$display("memwb_mem_data    = %d", dut.memwb_mem_data);
$display("memwb_alu_result  = %d", dut.memwb_alu_result);
$display("write_back_data   = %d", dut.write_back_data);
$display("RF write addr = %d", dut.memwb_rd);
$display("RF write data = %d", dut.write_back_data);
$display("RF reg_write  = %b", dut.memwb_reg_write);

$display("rs1_data = %d", dut.rs1_data);
$display("rs2_data = %d", dut.rs2_data);*/
$display("PC              = %d", dut.pc_current);
$display("Instruction      = %h", dut.ifid_instruction);

$display("idex_mem_read    = %b", dut.idex_mem_read);
$display("exmem_mem_read   = %b", dut.exmem_mem_read);

$display("mem_data         = %d", dut.mem_data);

$display("memwb_mem_data   = %d", dut.memwb_mem_data);
$display("write_back_data  = %d", dut.write_back_data);

$display("memwb_rd         = %d", dut.memwb_rd);
$display("memwb_reg_write  = %b", dut.memwb_reg_write);
$display("exmem_mem_to_reg = %b", dut.exmem_mem_to_reg);
$display("memwb_mem_to_reg = %b", dut.memwb_mem_to_reg);
$display("memwb_reg_write  = %b", dut.memwb_reg_write);
$display("memwb_rd         = %d", dut.memwb_rd);
end

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu_tb);

    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    #160;

    $display("--------------------------------");
    $display("Simple Memory Test");
    $display("--------------------------------");

    $display("x1        = %d (Expected 5)", dut.rf.reg_mem[1]);
    $display("x2        = %d (Expected 5)", dut.rf.reg_mem[2]);
    $display("Memory[0] = %d (Expected 5)", dut.dmem.memory[0]);

    $display("--------------------------------");

   /* #120;

    $display("--------------------------------");
    $display("Load Only Test");
    $display("--------------------------------");
    $display("Memory[0] = %d", dut.dmem.memory[0]);
    $display("x1        = %d (Expected 25)", dut.rf.reg_mem[1]);

    $display("--------------------------------");*/

    $finish;
end

endmodule