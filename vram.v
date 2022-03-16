module vram (input clk,
             input rst,
             input load,
             input store,
             input [12:0] write_addr,
             input [12:0] read_addr,
             input [7:0] data_in,
             output [11:0] data_out);
  localparam addr_width = 13;
  localparam mem_size   = 4800;
  reg [7:0] mem[mem_size - 1:0];
  // initial begin
  // $readmemh("");
  // end
  reg [7:0] tmp_data;
  always @(posedge clk) begin
    if (store) begin
      mem[write_addr][7:0] <= data_in[7:0];
    end
  end
  always @(*) begin
    if (load) begin
      tmp_data[7:0] = mem[read_addr][7:0];
    end else begin
      tmp_data[7:0] = 8'b0;
    end
  end
  vram_decode decode (
    .num(tmp_data),
    .data(data_out)
  );
endmodule

module vram_decode (
  input [7:0] num,
  output reg [11:0] data
);
  always @(*) begin
    data = { num[7:6], 2'b11, num[5:4], 2'b11, num[3:2], 2'b11 };
  end
endmodule
