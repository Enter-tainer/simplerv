module rom (input [31:0] addr,
            output [31:0] data_out);
localparam addr_width = 12;
localparam mem_size   = (2**addr_width);
wire [addr_width-1:0] actual_address;
assign actual_address[addr_width-1:0] = addr[addr_width+1:2];
reg [31:0]mem[mem_size - 1:0];
// need readh
initial begin
  $readmemh("/home/mgt/project/tetris-sdl-c/build/rom.mem", mem);
end
assign data_out = mem[actual_address][31:0];
endmodule
