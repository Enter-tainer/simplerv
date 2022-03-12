module rom (input [31:0] addr,
            output [31:0] data_out);
localparam addr_width                   = 12;
localparam mem_size                     = (2**addr_width);
assign actual_address[addr_width-1:0]   = addr[addr_width-1:0];
assign actual_addressp1[addr_width-1:0] = {actual_address[addr_width-1:1], 1'b1};
assign actual_addressp2[addr_width-1:0] = {actual_address[addr_width-1:2], 2'b10};
assign actual_addressp3[addr_width-1:0] = {actual_address[addr_width-1:2], 2'b11};
wire [addr_width-1:0] actual_address, actual_addressp1, actual_addressp2, actual_addressp3;
reg [7:0]mem[mem_size - 1:0];
// need readh
// initial begin
  // $readmemh("rams_init_file.data", mem);
// end
assign data_out = {mem[actual_addressp3][7:0], mem[actual_addressp2][7:0], mem[actual_addressp1][7:0], mem[actual_address][7:0]};
endmodule
