`timescale 1ns/100ps

module divider_tb();
  localparam period = 5;
  reg clk;
  initial begin
    clk            = 0;
    forever #1 clk = ~clk;
  end
  /*iverilog */
  initial begin
    $dumpfile("divider_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, divider_tb);    //tb模块名称
  end
  wire clk_N;
  divider#(5) div0(.clk(clk), .clk_N(clk_N));
  initial begin
    #4999;
    $stop;
  end
endmodule
