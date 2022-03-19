module ps2_kbd (input clk,
                input rst,
                input ps2_clk,
                input ps2_data,
                input read_enable,
                output [7:0] data,
                output ready,
                output reg overflow);
  
  reg [3:0] count;     // count ps2_data bits, internal signal, for test
  reg [9:0] buffer;     // ps2_data bits
  reg [31:0] fifo[7:0];   // data fifo
  reg [5:0] w_ptr, r_ptr;  // fifo write and read pointers
  reg [2:0] ps2_clk_sync;
  
  always @ (posedge clk) begin
    ps2_clk_sync <= {ps2_clk_sync[1:0],ps2_clk};
  end
  wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
  always @ (posedge clk) begin
    if (rst == 1) begin
      count    <= 0;
      w_ptr    <= 0;
      r_ptr    <= 0;
      overflow <= 0;
      end else if (sampling) begin
      if (count == 4'd10) begin
        if ((buffer[0] == 0) &&  (ps2_data) &&  (~buffer[9:1])) begin
          fifo[w_ptr] <= buffer[8:1];   // kbd scan code
          overflow <= overflow |  (r_ptr == (w_ptr + 1));
          if (r_ptr != (w_ptr + 1)) begin
            w_ptr <= w_ptr + 1;
          end
        end
        count <= 0; // for next
      end
      else begin
        buffer[count] <= ps2_data;   // store ps2_data
        count         <= count + 1'b1;   // count ps2_data bits
      end
    end
      if (read_enable && ready) begin
        r_ptr    <= r_ptr + 1;
        overflow <= 0;
      end
  end
  assign ready = (w_ptr != r_ptr);
  assign data  = fifo[r_ptr];
  
endmodule
