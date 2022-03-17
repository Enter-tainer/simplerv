module vram_decode (input [7:0] num,
                    output reg [11:0] data);
always @(*) begin
  data = 12'hf0f;
  case (num[5:0])
    6'b000000: begin
      data = 12'h4ad; // I, cyan
    end
    6'b000001: begin
      data = 12'hb5a; // T, purple
    end
    6'b000010: begin
      data = 12'hfd3; // O, yellow
    end
    6'b000011: begin
      data = 12'h18b; // J, blue
    end
    6'b000100: begin
      data = 12'he93; // L, orange
    end
    6'b000101: begin
      data = 12'h6c5; // S, green
    end
    6'b000110: begin
      data = 12'he64; // Z, red
    end
    6'b000111: begin
      data = 12'h666; // shadow, grey
    end
    6'b001000: begin
      data = 12'h666; // garbage
    end
    6'b001001: begin
      data = 12'hffe; // background
    end
    6'b001010: begin
      data = 12'heed; // dark background
    end
    6'b001011: begin
      data = 12'h4df; // I, light cyan
    end
    6'b001100: begin
      data = 12'he6d; // T, light purple
    end
    6'b001101: begin
      data = 12'hff5; // O, light yellow
    end
    6'b001110: begin
      data = 12'h1af; // J, light blue
    end
    6'b001111: begin
      data = 12'hfb6; // L, light orange
    end
    6'b010000: begin
      data = 12'h8e8; // S, light green
    end
    6'b010001: begin
      data = 12'hf98; // Z, light red
    end
    6'b010010: begin
      data = 12'h4df; // I, light cyan
    end
    6'b010011: begin
      data = 12'he6d; // T, light purple
    end
    6'b010100: begin
      data = 12'hff5; // O, light yellow
    end
    6'b010101: begin
      data = 12'h1af; // J, light blue
    end
    6'b010110: begin
      data = 12'hfb6; // L, light orange
    end
    6'b010111: begin
      data = 12'h8e8; // S, light green
    end
    6'b011000: begin
      data = 12'hf98; // Z, light red
    end
    // 4'b011001: begin
      
    // end
    // 4'b011010: begin
      
    // end
    // 4'b011011: begin
      
    // end
    // 4'b011100: begin
      
    // end
    // 4'b011101: begin
      
    // end
    // 4'b011110: begin
      
    // end
    // 4'b011111: begin
      
    // end
    // 4'b100000: begin
      
    // end
  endcase
end
endmodule
