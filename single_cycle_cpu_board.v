`timescale 1ns/10ps

module single_cycle_cpu_board(input clk,
                              input rst,
                              input halt,
                              output reg [7:0] AN,
                              output [7:0] SEG);
  wire [31:0] reg_a0;
  wire cpu_clk, led_clk;
  divider #(500000) div1(clk, cpu_clk); // 0.1kHz
  divider #(2500) div2(clk, led_clk);
  single_cycle_cpu my_cpu(
  .clk(cpu_clk),
  .rst(rst),
  .halt(halt),
  
  .reg_a0(reg_a0)
  );
  reg [3:0] sel;
  always @(posedge led_clk) begin
    if (rst) begin
      sel = 4'b0;
      end else begin
      sel = sel + 1;
    end
    AN[7:0] = 8'hff;
    AN[sel] = 1'b0;
  end
  led_display led_decoder(reg_a0[(sel * 4) +: 4], SEG[7:0]);
endmodule
