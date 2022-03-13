`timescale 1ns/10ps
module single_cycle_cpu_board_tb();
  reg clk, rst, halt;
  wire [7:0] AN, SEG;
  always #2 clk = ~clk;
  single_cycle_cpu_board cpu(.clk(clk),
  .rst(rst),
  .halt(halt),
  .AN(AN),
  .SEG(SEG));
  initial begin
    clk = 0;
    rst = 1;
    halt = 0;
    #10;
    rst = 0;
    #1999;
  end
endmodule
