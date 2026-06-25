module hazard_detection_tb;

reg idex_mem_read;

reg [4:0] idex_rd;
reg [4:0] ifid_rs1;
reg [4:0] ifid_rs2;

wire pc_write;
wire ifid_write;
wire control_mux;

hazard_detection_unit dut(

    .idex_mem_read(idex_mem_read),

    .idex_rd(idex_rd),

    .ifid_rs1(ifid_rs1),
    .ifid_rs2(ifid_rs2),

    .pc_write(pc_write),
    .ifid_write(ifid_write),
    .control_mux(control_mux)

);

initial begin

//--------------------------------------------------
// Test 1 : No hazard
//--------------------------------------------------

idex_mem_read = 0;

idex_rd  = 5'd1;
ifid_rs1 = 5'd2;
ifid_rs2 = 5'd3;

#10;

$display("T1");
$display("pc_write=%b ifid_write=%b control_mux=%b",
pc_write,ifid_write,control_mux);

//--------------------------------------------------
// Test 2 : Hazard on rs1
//--------------------------------------------------

idex_mem_read = 1;

idex_rd  = 5'd5;
ifid_rs1 = 5'd5;
ifid_rs2 = 5'd2;

#10;

$display("T2");
$display("pc_write=%b ifid_write=%b control_mux=%b",
pc_write,ifid_write,control_mux);

//--------------------------------------------------
// Test 3 : Hazard on rs2
//--------------------------------------------------

idex_mem_read = 1;

idex_rd  = 5'd8;
ifid_rs1 = 5'd1;
ifid_rs2 = 5'd8;

#10;

$display("T3");
$display("pc_write=%b ifid_write=%b control_mux=%b",
pc_write,ifid_write,control_mux);

//--------------------------------------------------
// Test 4 : x0 shouldn't stall
//--------------------------------------------------

idex_mem_read = 1;

idex_rd  = 5'd0;
ifid_rs1 = 5'd0;
ifid_rs2 = 5'd0;

#10;

$display("T4");
$display("pc_write=%b ifid_write=%b control_mux=%b",
pc_write,ifid_write,control_mux);

$finish;

end

endmodule