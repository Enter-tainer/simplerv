
module ram (input clk,
            input rst,
            input load,
            input store,
            input [2:0] access,
            input [31:0] addr,
            input [31:0] data_in,
            output reg [31:0] data_out);
  // 000 LB
  // 001 LH
  // 010 LW
  // 100 LBU
  // 101 LHU
  localparam addr_width = 11;
  localparam mem_size   = (2**addr_width);
  wire [addr_width-1:0] actual_address, actual_address00, actual_address01, actual_address10, actual_address11;
  assign actual_address[addr_width-1:0] = addr[addr_width+1:2];
  wire [1:0] byte_offset, half_word_offset;
  assign byte_offset                      = addr[1:0];
  assign half_word_offset                 = {addr[1], 1'b0};
  assign actual_address00[addr_width-1:0] = {addr[addr_width-1:2], 2'b00};
  assign actual_address01[addr_width-1:0] = {addr[addr_width-1:2], 2'b01};
  assign actual_address10[addr_width-1:0] = {addr[addr_width-1:2], 2'b10};
  assign actual_address11[addr_width-1:0] = {addr[addr_width-1:2], 2'b11};
  reg [31:0] mem[mem_size - 1:0];
  initial begin
    $readmemh("/home/mgt/project/rvcpu/test/vram.ram.hex", mem);
  end
  wire [31:0] load_tmp;
  wire [31:0] data_shifted;
  wire [3:0] byte_we_pattern;
  we_pattern_gen we_gen0(
  .access(access),
  .address(byte_offset),
  .data_in(data_in),
  
  .byte_we_pattern(byte_we_pattern),
  .data_shifted(data_shifted)
  );
  wire [31:0]data0, data1, data2, data3;
  assign data0    = mem[0];
  assign data1    = mem[1];
  assign data2    = mem[2];
  assign data3    = mem[3];
  assign load_tmp = mem[actual_address];
  
  // assign data4 = mem[4];
  // assign data5 = mem[5];
  // assign data6 = mem[6];
  // assign data7 = mem[7];
  always @(*) begin
    if (load) begin
      case (access[2:0])
        3'b000: begin
          data_out[31:0] = {
          {24{ load_tmp[byte_offset * 8 + 7] }}, load_tmp[byte_offset * 8 +: 8]
          };
        end
        3'b001: begin
          data_out[31:0] = {
          {16{ load_tmp[half_word_offset * 8 + 15] }}, load_tmp[half_word_offset * 8 +: 16]
          };
        end
        3'b010: begin
          data_out[31:0] = load_tmp[31:0];
        end
        3'b100: begin
          data_out[31:0] = {
          24'b0, load_tmp[byte_offset * 8 +: 8]
          };
        end
        3'b101: begin
          data_out[31:0] = {
          16'b0, load_tmp[half_word_offset * 8 +: 16]
          };
        end
        default: begin
          data_out = 32'b0;
        end
      endcase
    end
    else begin
      data_out = 32'b0;
      
    end
  end
  always@(posedge clk) begin
    if (store) begin
      if (byte_we_pattern[0]) begin
        mem[actual_address][7:0] <= data_shifted[7:0];
      end
      
      if (byte_we_pattern[1]) begin
        mem[actual_address][15:8] <= data_shifted[15:8];
      end
      
      if (byte_we_pattern[2]) begin
        mem[actual_address][23:16] <= data_shifted[23:16];
      end
      
      if (byte_we_pattern[3]) begin
        mem[actual_address][31:24] <= data_shifted[31:24];
      end
    end
  end
endmodule
  
  module we_pattern_gen (
    input [2:0] access,
    input [1:0] address,
    input [31:0] data_in,
    
    output reg [3:0] byte_we_pattern,
    output reg [31:0] data_shifted
    );
    always @(*) begin
      data_shifted <= data_in;
      case (access[2:0])
        3'b000: begin
          case (address[1:0])
            2'b00: begin
              byte_we_pattern <= 4'b0001;
            end
            2'b01: begin
              byte_we_pattern <= 4'b0010;
              data_shifted    <= (data_in << 8);
            end
            2'b10: begin
              byte_we_pattern <= 4'b0100;
              data_shifted    <= (data_in << 16);
            end
            2'b11: begin
              byte_we_pattern <= 4'b1000;
              data_shifted    <= (data_in << 24);
            end
          endcase
        end
        3'b001: begin
          case (address[1])
            1'b0: begin
              byte_we_pattern <= 4'b0011;
              data_shifted    <= data_in;
            end
            1'b1: begin
              byte_we_pattern <= 4'b1100;
              data_shifted    <= (data_in << 16);
            end
          endcase
        end
        3'b010: begin
          byte_we_pattern <= 4'b1111;
        end
        default: begin
          byte_we_pattern <= 4'b0000;
        end
      endcase
      
    end
  endmodule
