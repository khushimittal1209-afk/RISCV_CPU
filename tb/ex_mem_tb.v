module ex_mem_tb;

reg clk;
reg reset;

reg [31:0] alu_result_in;
reg [31:0] rs2_data_in;

reg [4:0] rd_in;

reg reg_write_in;
reg mem_read_in;
reg mem_write_in;
reg mem_to_reg_in;

wire [31:0] alu_result_out;
wire [31:0] rs2_data_out;

wire [4:0] rd_out;

wire reg_write_out;
wire mem_read_out;
wire mem_write_out;
wire mem_to_reg_out;

ex_mem dut(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result_in),
    .rs2_data_in(rs2_data_in),

    .rd_in(rd_in),

    .reg_write_in(reg_write_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),

    .alu_result_out(alu_result_out),
    .rs2_data_out(rs2_data_out),

    .rd_out(rd_out),

    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    alu_result_in = 32'd25;
    rs2_data_in   = 32'd20;

    rd_in = 5'd3;

    reg_write_in  = 1;
    mem_read_in   = 0;
    mem_write_in  = 1;
    mem_to_reg_in = 0;

    #10;

    $display("alu_result = %d", alu_result_out);
    $display("rs2_data = %d", rs2_data_out);
    $display("rd = %d", rd_out);
    $display("reg_write = %b", reg_write_out);
    $display("mem_write = %b", mem_write_out);

    $finish;
end

endmodule