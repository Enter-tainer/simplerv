module counter (
  input clk,
  input rst,
  output reg [31:0] cnt
);
  always @(posedge clk) begin
    if (rst) begin
      cnt <= 32'b0;
    end
    else begin
      cnt <= cnt + 1;
    end
  end
endmodule
