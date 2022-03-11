
module alu (input unsigned [31:0] a,
            input unsigned [31:0] b,
            input [2:0] funct3,
            input [6:0] funct7,
            output eq,
            output ge,
            output less,
            output ge_u,
            output less_u,
            output reg [31:0] res1);
assign eq     = (a[31:0] == b[31:0]);
assign ge     = !($signed(a[31:0]) < $signed(b[31:0]));
assign less   = ($signed(a[31:0]) < $signed(b[31:0]));
assign ge_u   = !(a[31:0] < b[31:0]);
assign less_u = !(a[31:0] < b[31:0]);
wire [63:0] mul_res, mul_res_u, mul_res_su;
wire [31:0] div_res, rem_res;
wire [31:0] div_res_u, rem_res_u;
assign mul_res    = $signed(a[31:0]) * $signed(b[31:0]);
assign mul_res_u  = a[31:0] * b[31:0];
assign mul_res_su = $signed(a[31:0]) * b[31:0];
assign div_res    = $signed(a[31:0]) / $signed(b[31:0]);
assign rem_res    = $signed(a[31:0]) % $signed(b[31:0]);
assign div_res_u  = a[31:0] / b[31:0];
assign rem_res_u  = a[31:0] % b[31:0];


always @(*) begin
  res1[31:0] <= 32'b0;
  if (funct7[6:0] == 7'b0000001) begin
    // RV32-M
    case (funct3[2:0])
      3'b000: begin
        res1[31:0] <= mul_res[31:0];
      end
      3'b001: begin
        res1[31:0] <= mul_res[63:32];
      end
      3'b010: begin
        res1[31:0] <= mul_res_su[63:32];
      end
      3'b011: begin
        res1[31:0] <= mul_res_u[63:32];
      end
      3'b100: begin
        res1[31:0] <= div_res[31:0];
      end
      3'b101: begin
        res1[31:0] <= div_res_u[31:0];
      end
      3'b110: begin
        res1[31:0] <= rem_res[31:0];
      end
      3'b111: begin
        res1[31:0] <= rem_res_u[31:0];
      end
    endcase
  end
  else begin
    // RV32-I
    case (funct3[2:0])
      3'b000: begin
        if (funct7[6:0] == 7'b0) begin
          res1[31:0] <= a[31:0] + b[31:0];
        end
        else begin
          res1[31:0] <= a[31:0] - b[31:0];
        end
      end
      3'b001: begin
        res1[31:0] <= a[31:0] << b[4:0];
      end
      3'b010: begin
        res1[31:0] <= less ? 1'b1 : 1'b0;
      end
      3'b011: begin
        res1[31:0] <= less_u ? 1'b1 : 1'b0;
      end
      3'b100: begin
        res1[31:0] <= a[31:0] ^ b[31:0];
      end
      3'b101: begin
        if (funct7[6:0] == 7'b0) begin
          res1[31:0] <= a[31:0] >> b[4:0];
        end
        else begin
          res1[31:0] <= a[31:0] >>> b[4:0];
        end
      end
      3'b110: begin
        res1[31:0] <= a[31:0] | b[31:0];
      end
      3'b111: begin
        res1[31:0] <= a[31:0] & b[31:0];
      end
    endcase
  end
  // case (op)
  //   4'b0000: begin
  //     res1[31:0] <= a[31:0] << b[4:0];
  //   end
  //   4'b0001: begin
  //     res1[31:0] <= a[31:0] >>> b[4:0];
  //   end
  //   4'b0010: begin
  //     res1[31:0] <= a[31:0] >> b[4:0];
  //   end
  //   4'b0011: begin
  //     {res2[31:0], res1[31:0]} <= a[31:0] * b[31:0];
  //     // note that we do not support mulh[[s]u]
  //   end
  //   4'b0100: begin
  //     res1[31:0] <= a[31:0] / b[31:0];
  //     res2[31:0] <= a[31:0] % b[31:0];
  //   end
  //   4'b0101: begin
  //     res1[31:0] <= a[31:0] + b[31:0];
  //   end
  //   4'b0110: begin
  //     res1[31:0] <= a[31:0] - b[31:0];
  //   end
  //   4'b0111: begin
  //     res1[31:0] <= a[31:0] & b[31:0];
  //   end
  //   4'b1000: begin
  //     res1[31:0] <= a[31:0] | b[31:0];
  //   end
  //   4'b1001: begin
  //     res1[31:0] <= a[31:0] ^ b[31:0];
  //   end
  //   4'b1010: begin
  //     res1[31:0] <= ~(a[31:0] | b[31:0]);
  //   end
  //   4'b1011: begin
  //     ge   <= !($signed(a[31:0]) < $signed(b[31:0]));
  //     less <= ($signed(a[31:0]) < $signed(b[31:0]));
  //   end
  //   4'b1100: begin
  //     ge   <= !(a[31:0] < b[31:0]);
  //     less <= (a[31:0] < b[31:0]);
  //   end
  //   default:
  // endcase
end
endmodule

