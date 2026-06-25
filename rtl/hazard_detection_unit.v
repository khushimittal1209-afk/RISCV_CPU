module hazard_detection_unit(
    input idex_mem_read,
    input [4:0] idex_rd,
    input [4:0] ifid_rs1,
    input [4:0] ifid_rs2,
    output reg pc_write,
    output reg ifid_write,
    output reg control_mux
);
always @(*) begin
    // Default: pipeline runs normally
    pc_write    = 1'b1;
    ifid_write  = 1'b1;
    control_mux = 1'b0;
    // Load-use hazard
    if(idex_mem_read &&
      ((idex_rd == ifid_rs1) || (idex_rd == ifid_rs2)) &&
       (idex_rd != 5'b00000))
    begin
        pc_write    = 1'b0;
        ifid_write  = 1'b0;
        control_mux = 1'b1;
    end
end
endmodule