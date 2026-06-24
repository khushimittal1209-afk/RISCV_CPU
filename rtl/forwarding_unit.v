module forwarding_unit(
    input [4:0] idex_rs1,
    input [4:0] idex_rs2,

    input [4:0] exmem_rd,
    input [4:0] memwb_rd,

    input exmem_reg_write,
    input memwb_reg_write,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

always @(*) begin

    // Default: use register file values
    forward_a = 2'b00;
    forward_b = 2'b00;

    // EX hazard
    if(exmem_reg_write &&
       (exmem_rd != 0) &&
       (exmem_rd == idex_rs1))
        forward_a = 2'b10;

    if(exmem_reg_write &&
       (exmem_rd != 0) &&
       (exmem_rd == idex_rs2))
        forward_b = 2'b10;

    // MEM hazard
    if(memwb_reg_write &&
       (memwb_rd != 0) &&
       !(exmem_reg_write &&
         (exmem_rd != 0) &&
         (exmem_rd == idex_rs1)) &&
       (memwb_rd == idex_rs1))
        forward_a = 2'b01;

    if(memwb_reg_write &&
       (memwb_rd != 0) &&
       !(exmem_reg_write &&
         (exmem_rd != 0) &&
         (exmem_rd == idex_rs2)) &&
       (memwb_rd == idex_rs2))
        forward_b = 2'b01;

end

endmodule