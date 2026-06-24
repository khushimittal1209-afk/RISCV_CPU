module forwarding_unit_tb;

reg [4:0] idex_rs1;
reg [4:0] idex_rs2;

reg [4:0] exmem_rd;
reg [4:0] memwb_rd;

reg exmem_reg_write;
reg memwb_reg_write;

wire [1:0] forward_a;
wire [1:0] forward_b;

forwarding_unit dut(
    .idex_rs1(idex_rs1),
    .idex_rs2(idex_rs2),

    .exmem_rd(exmem_rd),
    .memwb_rd(memwb_rd),

    .exmem_reg_write(exmem_reg_write),
    .memwb_reg_write(memwb_reg_write),

    .forward_a(forward_a),
    .forward_b(forward_b)
);

initial begin

    // Test 1: No forwarding
    idex_rs1 = 5'd1;
    idex_rs2 = 5'd2;

    exmem_rd = 5'd0;
    memwb_rd = 5'd0;

    exmem_reg_write = 0;
    memwb_reg_write = 0;

    #10;

    $display("T1 A=%b B=%b", forward_a, forward_b);

    // Test 2: EX/MEM forwarding rs1
    exmem_rd = 5'd1;
    exmem_reg_write = 1;

    #10;

    $display("T2 A=%b B=%b", forward_a, forward_b);

    // Test 3: EX/MEM forwarding rs2
    exmem_rd = 5'd2;

    #10;

    $display("T3 A=%b B=%b", forward_a, forward_b);

    // Test 4: MEM/WB forwarding rs1
    exmem_reg_write = 0;

    memwb_rd = 5'd1;
    memwb_reg_write = 1;

    #10;

    $display("T4 A=%b B=%b", forward_a, forward_b);

    // Test 5: MEM/WB forwarding rs2
    memwb_rd = 5'd2;

    #10;

    $display("T5 A=%b B=%b", forward_a, forward_b);

    $finish;

end

endmodule