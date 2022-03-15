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
             output reg [31:0] led_data,
             output reg kbd_read_enable,
             output reg [31:0] data_out);
  wire [31:0] ram_data_out;
  reg [31:0] kbd_data_out;
  ram ram0(
  .clk(clk),
  .rst(rst),
  .load(load),
  .store(store),
  .access(access),
  .addr(addr),
  .data_in(data_in),
  .data_out(ram_data_out)
  );
  always @(*) begin
    kbd_data_out = 32'b0;
    if (load && access == 3'b000 && addr == 32'hfbadbeef) begin
      // read kbd
      // only allow lb
      if (kbd_ready) begin
        kbd_data_out = {24'b0, kbd_data[7:0]};
      end
      else begin
        kbd_data_out = 32'b0;
      end
      data_out[31:0] = kbd_data_out[31:0];
    end
    else if (load && access == 3'b000 && addr == 32'hfbadbeee) begin
      // read kbd_ready
      // only allow lb
      data_out[31:0] = { 31'b0, kbd_ready };
    end
    else if (load && access == 3'b010 && addr == 32'hfbadbedf) begin
      // read us clock
      // only allow lw
      data_out[31:0] = clk_cnt;
    end
    else begin
      data_out[31:0] = ram_data_out[31:0];
    end
  end
  always @(posedge clk) begin
    if (load && access == 3'b000 && addr == 32'hfbadbeef) begin
      kbd_read_enable <= 1;
      end else begin
      kbd_read_enable <= 0;
    end
    
    if (store && access == 3'b010 && addr == 32'hfbadc0fe) begin
      led_data[31:0] <= data_in[31:0];
    end
  end
endmodule
