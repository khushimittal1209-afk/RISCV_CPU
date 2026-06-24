module mem_wb_tb;

reg clk;
reg reset;

reg [31:0] memory_data_in;
reg [31:0] alu_result_in;

reg [4:0] rd_in;

reg reg_write_in;
reg mem_to_reg_in;

wire [31:0] memory_data_out;
wire [31:0] alu_result_out;

wire [4:0] rd_out;

wire reg_write_out;
wire mem_to_reg_out;

mem_wb dut(
    .clk(clk),
    .reset(reset),

    .memory_data_in(memory_data_in),
    .alu_result_in(alu_result_in),

    .rd_in(rd_in),

    .reg_write_in(reg_write_in),
    .mem_to_reg_in(mem_to_reg_in),

    .memory_data_out(memory_data_out),
    .alu_result_out(alu_result_out),

    .rd_out(rd_out),

    .reg_write_out(reg_write_out),
    .mem_to_reg_out(mem_to_reg_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    memory_data_in = 32'd100;
    alu_result_in  = 32'd25;

    rd_in = 5'd3;

    reg_write_in = 1;
    mem_to_reg_in = 1;

    #10;

    $display("memory_data = %d", memory_data_out);
    $display("alu_result = %d", alu_result_out);
    $display("rd = %d", rd_out);
    $display("reg_write = %b", reg_write_out);
    $display("mem_to_reg = %b", mem_to_reg_out);

    $finish;
end

endmodule