module data_memory_tb;

reg clk;
reg mem_read;
reg mem_write;
reg [31:0] address;
reg [31:0] write_data;

wire [31:0] read_data;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor(
    "t=%0t addr=%d mem_read=%b mem_write=%b write_data=%d read_data=%d",
    $time,address,mem_read,mem_write,write_data,read_data);
end

initial begin

    mem_read  = 0;
    mem_write = 0;
    address   = 0;
    write_data = 0;

    // write 100 to address 0
    #10;
    mem_write = 1;
    address = 0;
    write_data = 100;

    #10;
    mem_write = 0;

    // read address 0
    mem_read = 1;
    address = 0;

    #10;
    mem_read = 0;

    // write 55 to address 4
    mem_write = 1;
    address = 4;
    write_data = 55;

    #10;
    mem_write = 0;

    // read address 4
    mem_read = 1;
    address = 4;

    #10;
    mem_read = 0;

    #10;
    $finish;

end

initial begin
    $dumpfile("data_memory.vcd");
    $dumpvars(0,data_memory_tb);
end

data_memory dut(
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

endmodule