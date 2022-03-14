`timescale 1ns/10ps

module single_cycle_cpu_board(input clk,
                              input rst,
                              input halt,
                              input PS2_CLK,
                              input PS2_DATA,
                              output reg [7:0] AN,
                              output [7:0] SEG,
                              output [3:0] LED);
  wire [31:0] reg_a0;
  wire cpu_clk, led_clk;
  wire kbd_read_enable, kbd_ready, kbd_overflow;
  wire [7:0] kbd_data;
  wire [31:0] kbd_display;
  assign LED[0]      = PS2_CLK;
  assign LED[1]      = PS2_DATA;
  assign LED[2]      = cpu_clk;
  assign LED[3]      = kbd_ready;
  assign LED[4]      = kbd_overflow;
  assign LED[5]      = kbd_read_enable;
  divider #(500) div1(clk, cpu_clk); // 100kHz
  divider #(2500) div2(clk, led_clk);
  ps2_kbd kbd(.clk(cpu_clk),
  .rst(rst),
  .ps2_clk(PS2_CLK),
  .ps2_data(PS2_DATA),
  
  .read_enable(kbd_read_enable),
  .data(kbd_data),
  .ready(kbd_ready),
  .overflow(kbd_overflow));
  single_cycle_cpu my_cpu(
  .clk(cpu_clk),
  .rst(rst),
  .halt(halt),
  .kbd_ready(kbd_ready),
  .kbd_overflow(kbd_overflow),
  .kbd_data(kbd_data),
  
  .kbd_read_enable(kbd_read_enable),
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
