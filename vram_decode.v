  module vram_decode (
    input [7:0] num,
    output reg [11:0] data
    );
    always @(*) begin
      data = { num[7:6], num[7:6], num[5:4], num[5:4], num[3:2], num[3:2] };
    end
  endmodule
