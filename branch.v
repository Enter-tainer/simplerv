module branch (input [2:0] funct3,
               input eq,
               input ge,
               input less,
               input ge_u,
               input less_u,
               output taken,
               );
case (funct3[2:0])
  3'b000: begin
    taken <= eq;
  end
  3'b001: begin
    taken <= !eq;
  end
  3'b100: begin
    taken <= less;
  end
  3'b101: begin
    taken <= ge;
  end
  3'b110: begin
    taken <= less_u;
  end
  3'b111: begin
    taken <= ge_u;
  end
endcase
endmodule
