module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory [0:255];

// Write (SW)
always @(posedge clk)
begin
    if(mem_write)
        memory[address[9:2]] <= write_data;
end

// Read (LW)
always @(*)
begin
    if(mem_read)
        read_data = memory[address[9:2]];
    else
        read_data = 32'b0;
end

endmodule