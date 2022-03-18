module double_frame_buffer (input rst,
                            input a_clk,
                            input a_wr,
                            input [12:0] a_addr,
                            input [7:0] a_din,
                            input commit,
                            input b_clk,
                            input [9:0] b_addr_x,
                            input [9:0] b_addr_y,
                            output vram_num,
                            output [11:0] vram_data);
  reg wr_sel;
  wire b_wr = 0;
  wire [7:0] b_dout0, b_dout1, b_dout_res;
  wire [12:0] b_addr;
  assign b_addr[12:0] = b_addr_x[9:3] + b_addr_y[9:3] * 80;
  // y is vertical, x is horizonal
  wire a_wr0, a_wr1;
  assign a_wr0      = wr_sel == 0 && a_wr == 1;
  assign a_wr1      = wr_sel == 1 && a_wr == 1;
  assign b_dout_res = wr_sel == 1 ? b_dout0 : b_dout1;
  assign vram_num   = wr_sel;
  vram vram0(
  .a_clk(a_clk),
  .a_wr(a_wr0),
  .a_din(a_din[7:0]),
  .a_addr(a_addr[12:0]),
  .b_clk(b_clk),
  .b_addr(b_addr),
  .b_wr(b_wr),
  .b_dout(b_dout0));
  vram vram1(
  .a_clk(a_clk),
  .a_wr(a_wr1),
  .a_din(a_din[7:0]),
  .a_addr(a_addr[12:0]),
  .b_clk(b_clk),
  .b_addr(b_addr),
  .b_wr(b_wr),
  .b_dout(b_dout1));
  vram_decode decoder(
  .num(b_dout_res),
  .addr_x(b_addr_x[2:0]),
  .addr_y(b_addr_y[2:0]),
  .data(vram_data)
  );
  always @(posedge a_clk) begin
    if (commit == 1) begin
      wr_sel <= ~wr_sel;
    end
    
    if (rst) begin
      wr_sel <= 0;
    end
  end
endmodule
