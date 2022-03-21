`timescale 1ns/10ps

module single_cycle_cpu_board(input clk,
                              input rst,
                              input halt,
                              input PS2_CLK,
                              input PS2_DATA,
                              input UART_TXD_IN,
                              output UART_RXD_OUT,
                              output [3:0]VGA_R,
                              output [3:0]VGA_G,
                              output [3:0]VGA_B,
                              output VGA_HS,
                              output VGA_VS,
                              output reg [7:0] AN,
                              output [7:0] SEG,
                              output [11:0] LED);
  wire [31:0] led_data;
  wire kbd_read_enable, kbd_ready, kbd_overflow;
  wire [7:0] kbd_data;
  wire [31:0] kbd_display;
  wire vram_num;
  assign LED[0] = PS2_CLK;
  assign LED[1] = PS2_DATA;
  assign LED[2] = cpu_clk;
  assign LED[3] = kbd_ready;
  assign LED[4] = kbd_overflow;
  assign LED[5] = kbd_read_enable;
  assign LED[6] = vram_num;
  wire cpu_clk_p, led_clk_p, us_clk_p, vga_clk_p;
  wire cpu_clk, led_clk, us_clk, vga_clk;
  // assign cpu_clk = cpu_clk_p;
  // assign led_clk = led_clk_p;
  // assign vga_clk = vga_clk_p;
  divider #(5) div1(clk, cpu_clk_p); // 10MHz
  divider #(2500) div2(clk, led_clk_p); // 20kHz
  divider #(50) div3(clk, us_clk_p); // 1MHz
  divider #(2) div4(clk, vga_clk_p); // 25MHz
  
  BUFG bufg_cpu (.O(cpu_clk), .I(cpu_clk_p));
  BUFG bufg_counter (.O(led_clk), .I(led_clk_p));
  BUFG bufg_led (.O(us_clk), .I(us_clk_p));
  BUFG bufg_vga (.O(vga_clk), .I(vga_clk_p));
  
  wire [9:0] next_x, next_y;
  wire [11:0] vram_data;
  
  vga_driver vga0(.clk(vga_clk),
  .rst(rst),
  .color_in(vram_data),
  .next_x(next_x),
  .next_y(next_y),
  .red(VGA_R),
  .green(VGA_G),
  .blue(VGA_B),
  .hsync(VGA_HS),
  .vsync(VGA_VS));
  
  ps2_kbd kbd(.clk(cpu_clk),
  .rst(rst),
  .ps2_clk(PS2_CLK),
  .ps2_data(PS2_DATA),
  
  .read_enable(kbd_read_enable),
  .data(kbd_data),
  .ready(kbd_ready),
  .overflow(kbd_overflow));
  wire [31:0] clk_cnt;
  counter cnt0(
  .clk(us_clk),
  .rst(rst),
  .cnt(clk_cnt)
  );
  wire uart_r_enable, uart_r_ready;
  wire uart_w_ready, uart_w_enable;
  assign LED[8] = uart_r_enable;
  assign LED[9] = uart_r_ready;
  assign LED[10] = uart_w_enable;
  assign LED[11] = uart_w_ready;
  wire [7:0] uart_r_data;
  wire [7:0] uart_w_data;
  uart uart0 (
    .cpu_clk(cpu_clk),
    .rst(rst),
    
    .rx(UART_TXD_IN),
    .r_enable(uart_r_enable),
    .r_ready(uart_r_ready),
    .r_overflow(LED[7]),
    .r_data_out(uart_r_data[7:0]),
    
    .tx(UART_RXD_OUT),
    .w_ready(uart_w_ready),
    .w_enable(uart_w_enable),
    .w_data_in(uart_w_data[7:0])
  );
  single_cycle_cpu my_cpu(
  .clk(cpu_clk),
  .vga_clk(vga_clk),
  .rst(rst),
  .halt(halt),
  .kbd_ready(kbd_ready),
  .kbd_overflow(kbd_overflow),
  .kbd_data(kbd_data),
  .clk_cnt(clk_cnt),
  .vram_addr_x(next_x),
  .vram_addr_y(next_y),
  
  .uart_r_ready(uart_r_ready),
  .uart_w_ready(uart_w_ready), 
  .uart_r_data(uart_r_data),
  
  .uart_r_enable(uart_r_enable), 
  .uart_w_enable(uart_w_enable),
  .uart_w_data(uart_w_data),
  
  .vram_num(vram_num),
  .vram_data(vram_data),
  .kbd_read_enable(kbd_read_enable),
  .led_data(led_data)
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
  led_display led_decoder(led_data[(sel * 4) +: 4], SEG[7:0]);
endmodule
