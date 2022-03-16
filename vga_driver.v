`timescale 1ns / 1ps
module vga_driver (vga_clk,
                   rst,
                   d_in,
                   addr,
                   load_vram,
                   r,
                   g,
                   b,
                   hs,
                   vs);       // vgac
  input            vga_clk;  // 25MHz
  input            rst;
  input     [11:0] d_in;     // rrrr gggg bbbb, pixel
  output  [12:0] addr;
  output        load_vram;      // read pixel RAM
  output reg [3:0] r,g,b; // red, green, blue colors
  output reg       hs,vs;    // horizontal and vertical synchronization
  // h_count: VGA horizontal counter (0-799)
  reg [8:0] row_addr; // pixel ram row address, 480 (512) lines
  reg [9:0] col_addr; // pixel ram col address, 640 (1024) pixels
  
  reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
  always @ (posedge vga_clk) begin
    if (rst) begin
      h_count <= 10'h0;
      end else if (h_count == 10'd799) begin
      h_count <= 10'h0;
      end else begin
      h_count <= h_count + 10'h1;
    end
  end
  // v_count: VGA vertical counter (0-524)
  reg [9:0] v_count; // VGA vertical   counter (0-524): lines
  always @ (posedge vga_clk or posedge rst) begin
    if (rst) begin
      v_count <= 10'h0;
      end else if (h_count == 10'd799) begin
      if (v_count == 10'd524) begin
        v_count <= 10'h0;
        end else begin
        v_count <= v_count + 10'h1;
      end
    end
  end
  // signals, will be latched for outputs
  wire  [9:0] row    = v_count - 10'd35;     // pixel ram row addr
  wire  [9:0] col    = h_count - 10'd143;    // pixel ram col addr
  wire        h_sync = (h_count > 10'd95);    //  96 -> 799
  wire        v_sync = (v_count > 10'd1);     //   2 -> 524
  wire        read = (h_count > 10'd142) && // 143 -> 782
  (h_count < 10'd783) && //        640 pixels
  (v_count > 10'd34)  && //  35 -> 514
  (v_count < 10'd515);   //        480 lines
  // vga signals
  wire [12:0] new_row = row[8:3];
  assign addr[12:0]      = new_row[12:0] * 80 + col[9:3];
  assign load_vram = read;
  always @ (posedge vga_clk) begin
    hs <= h_sync;   // horizontal synchronization
    vs <= v_sync;   // vertical   synchronization
    r  <= load_vram ? d_in[11:8] : 4'h0; // 4-bit r
    g  <= load_vram ? d_in[7:4] : 4'h0; // 4-bit green
    b  <= load_vram ? d_in[3:0] : 4'h0; // 4-bit b
  end
endmodule
