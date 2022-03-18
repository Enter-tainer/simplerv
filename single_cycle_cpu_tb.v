`timescale 1ns/100ps

module single_cycle_cpu_tb();
  localparam period = 5;
  reg clk;
  initial begin
    clk            = 0;
    forever #1 clk = ~clk;
  end
  /*iverilog */
  initial begin
    $dumpfile("single_cycle_cpu_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, single_cycle_cpu_tb);    //tb模块名称
  end
  reg rst, halt;
  wire [31:0] reg_a0;
  single_cycle_cpu my_cpu(
    .clk(clk),
    .rst(rst),
    .halt(halt)
  );
  initial begin
    rst = 1;
    halt = 0;
    #period;
    rst = 0;
    #999990;
    halt = 1;
    #period;
    $stop;
  end
endmodule
