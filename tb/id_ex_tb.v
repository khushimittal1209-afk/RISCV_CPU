module id_ex_tb;

reg clk;
reg reset;

reg [31:0] rs1_data_in;
reg [31:0] rs2_data_in;
reg [31:0] imm_in;

reg [4:0] rd_in;

reg [2:0] alu_control_in;

reg reg_write_in;
reg mem_read_in;
reg mem_write_in;
reg mem_to_reg_in;
reg alu_src_in;

wire [31:0] rs1_data_out;
wire [31:0] rs2_data_out;
wire [31:0] imm_out;

wire [4:0] rd_out;

wire [2:0] alu_control_out;

wire reg_write_out;
wire mem_read_out;
wire mem_write_out;
wire mem_to_reg_out;
wire alu_src_out;

id_ex dut(
    .clk(clk),
    .reset(reset),

    .rs1_data_in(rs1_data_in),
    .rs2_data_in(rs2_data_in),
    .imm_in(imm_in),

    .rd_in(rd_in),

    .alu_control_in(alu_control_in),

    .reg_write_in(reg_write_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),
    .alu_src_in(alu_src_in),

    .rs1_data_out(rs1_data_out),
    .rs2_data_out(rs2_data_out),
    .imm_out(imm_out),

    .rd_out(rd_out),

    .alu_control_out(alu_control_out),

    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out),
    .alu_src_out(alu_src_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    rs1_data_in = 32'd5;
    rs2_data_in = 32'd20;
    imm_in      = 32'd100;

    rd_in = 5'd3;

    alu_control_in = 3'b000;

    reg_write_in  = 1'b1;
    mem_read_in   = 1'b0;
    mem_write_in  = 1'b0;
    mem_to_reg_in = 1'b0;
    alu_src_in    = 1'b1;

    #10;

    $display("rs1 = %d", rs1_data_out);
    $display("rs2 = %d", rs2_data_out);
    $display("imm = %d", imm_out);
    $display("rd = %d", rd_out);
    $display("alu_ctrl = %b", alu_control_out);
    $display("reg_write = %b", reg_write_out);

    $finish;
end

endmodule