module mmio (input clk,
             input rst,
             input load,
             input store,
             input [2:0] access,
             input [31:0] addr,
             input [31:0] data_in,
             input kbd_ready,
             input kbd_overflow,
             input [7:0] kbd_data,
             input [31:0] clk_cnt,
             input vga_clk,
             input [9:0] vram_addr_x,
             input [9:0] vram_addr_y,
             input uart_r_ready,
             input uart_w_ready, 
             input [7:0] uart_r_data,
             input new_frame,
          
             output reg uart_r_enable, 
             output reg uart_w_enable,
             output [7:0] uart_w_data,
             output vram_num,
             output [11:0] vram_data,
             output reg [31:0] led_data,
             output reg kbd_read_enable,
             output reg [31:0] data_out);
  wire [31:0] ram_data_out;
  reg [31:0] kbd_data_out;
  reg commit_vram;
  reg ram_store, vram_store;
  wire b_wr = 0;
  assign uart_w_data[7:0] = data_in[7:0];
  ram ram0(
  .clk(clk),
  .rst(rst),
  .load(load),
  .store(ram_store),
  .access(access),
  .addr(addr),
  .data_in(data_in),
  .data_out(ram_data_out)
  );
  double_frame_buffer fb0  (.rst(rst),
  .a_clk(clk),
  .a_wr(vram_store),
  .a_addr(addr[12:0]),
  .a_din(data_in[7:0]),
  .commit(commit_vram),
  .new_frame(new_frame),
  .b_clk(vga_clk),
  .b_addr_x(vram_addr_x),
  .b_addr_y(vram_addr_y),
  .vram_data(vram_data),
  .vram_num(vram_num)
  );
  always @(*) begin
    vram_store   = 0;
    ram_store    = 0;
    kbd_data_out = 32'b0;
    data_out     = 32'b0;
    commit_vram  = 0;
    uart_w_enable = 0; 
    if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbadbeef) begin
      // read kbd
      // only allow lb lbu
      if (kbd_ready) begin
        kbd_data_out = {24'b0, kbd_data[7:0]};
      end
      else begin
        kbd_data_out = 32'b0;
      end
      data_out[31:0] = kbd_data_out[31:0];
    end
    else if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbadbeee) begin
      // read kbd_ready
      // only allow lb, lbu
      data_out[31:0] = { 31'b0, kbd_ready };
    end
    else if (load && access == 3'b010 && addr == 32'hfbadbedf) begin
    // read us clock
    // only allow lw
    data_out[31:0] = clk_cnt;
    end
    else if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbada000) begin
      // uart read ready
      // allow lb lbu
      data_out[31:0] = {31'b0, uart_r_ready};
    end
    else if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbada001) begin
      // uart write ready
      // allow lb lbu
      data_out[31:0] = {31'b0, uart_w_ready};
    end
    else if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbada002) begin
      // uart read data
      // allow lb lbu
      if (uart_r_ready) begin
        data_out[31:0] = {24'b0, uart_r_data[7:0]};        
      end else begin
        data_out[31:0] = 32'b0;
      end
    end
    else if (store && access == 3'b000 && addr == 32'hfbada003) begin
      // uart write data
      // allow sb
      if (uart_w_ready) begin
        uart_w_enable = 1;        
      end
    end
    else if (store && access == 3'b000 && addr == 32'hfbadf000) begin
      commit_vram = 1;
    end
    else if (store && access == 3'b000 && addr >= 32'hfbad0000 && addr < 32'hfbad0000 + 80 * 60) begin
    vram_store = store;
    end
    else begin
      ram_store      = store;
      data_out[31:0] = ram_data_out[31:0];
    end
  end
  always @(posedge clk) begin
    if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbadbeef) begin
      // read kbd
      // only allow lb lbu
      kbd_read_enable <= 1;
      end else begin
      kbd_read_enable <= 0;
    end
    if (load && (access == 3'b000 || access == 3'b100) && addr == 32'hfbada002) begin
      // read uart fifo
      // only allow lb lbu
      uart_r_enable <= 1;
    end else begin
      uart_r_enable <= 0;
    end
    
    if (store && access == 3'b010 && addr == 32'hfbadc0fe) begin
      led_data[31:0] <= data_in[31:0];
    end
  end
endmodule
