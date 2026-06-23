module instruction_memory_tb;

reg [31:0] address;
wire [31:0] instruction;

initial begin
    $monitor("t=%0t address=%d instruction=%h",
              $time,address,instruction);
end

initial begin
    address = 0;
    #10;

    address = 4;
    #10;

    address = 8;
    #10;

    address = 12;
    #10;

    address = 16;
    #10;

    $finish;
end

initial begin
    $dumpfile("instruction_memory.vcd");
    $dumpvars(0,instruction_memory_tb);
end

instruction_memory dut(
    .address(address),
    .instruction(instruction)
);

endmodule