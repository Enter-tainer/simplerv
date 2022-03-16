module vram #(parameter DATA = 8,
              parameter ADDR = 13)
             (input wire a_clk,
              input wire a_wr,
              input wire [ADDR-1:0] a_addr,
              input wire [DATA-1:0] a_din,
              output reg [DATA-1:0] a_dout,
              input wire b_clk,
              input wire b_wr,
              input wire [ADDR-1:0] b_addr,
              input wire [DATA-1:0] b_din,
              output reg [DATA-1:0] b_dout);
  localparam mem_size = 4800;
  // Shared memory
  reg [DATA-1:0] mem [mem_size-1:0];
  
  // Port A
  always @(posedge a_clk) begin
    a_dout <= mem[a_addr];
    if (a_wr) begin
      a_dout      <= a_din;
      mem[a_addr] <= a_din;
    end
  end
  
  // Port B
  always @(posedge b_clk) begin
    b_dout <= mem[b_addr];
    if (b_wr) begin
      b_dout      <= b_din;
      mem[b_addr] <= b_din;
    end
  end
endmodule
