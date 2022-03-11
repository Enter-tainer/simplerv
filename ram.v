
module ram (input clk,
            input rstn,
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
  localparam addr_width = 12;
  wire [addr_width-1:0] actual_address, actual_addressp1, actual_addressp2, actual_addressp3;
  assign actual_address[addr_width-1:0]   = addr[addr_width-1:0];
  assign actual_addressp1[addr_width-1:0] = {actual_address[addr_width-1:1], 1'b0};
  assign actual_addressp2[addr_width-1:0] = {actual_address[addr_width-1:2], 2'b10};
  assign actual_addressp3[addr_width-1:0] = {actual_address[addr_width-1:2], 2'b11};
  reg [7:0]mem[4095:0];
  integer i;
  initial begin
    for (i = 0; i < 4095; i = i + 1)
      mem[i] <= 8'b0;
  end
  always@(rstn, posedge clk) begin
    if (rstn == 0) begin
      for (i = 0; i < 4095; i = i + 1)
        mem[i] <= 8'b0;
    end
    else begin
      if (clk) begin
        if (load) begin
          case (access[2:1])
            3'b000: begin
              data_out[31:0] <= {
              {24{mem[actual_address[addr_width-1:0]][7]}}, mem[actual_address[addr_width-1:0]][7:0]
              };
            end
            3'b001: begin
              data_out[31:0] <= {
              {16{mem[actual_addressp1[addr_width-1:0]][7]}}, mem[actual_addressp1[addr_width-1:0]][7:0], mem[actual_address[addr_width-1:0]][7:0]
              };
            end
            3'b010: begin
              data_out[31:0] <= {
              mem[actual_addressp3[addr_width-1:0]][7:0], mem[actual_addressp2[addr_width-1:0]][7:0], mem[actual_addressp1[addr_width-1:0]][7:0], mem[actual_address[addr_width-1:0]][7:0]
              };
            end
            3'b100: begin
              data_out[31:0] <= {
              24'b0, mem[actual_address[addr_width-1:0]][7:0]
              };
            end
            3'b101: begin
              data_out[31:0] <= {
              16'b0, mem[actual_addressp1[addr_width-1:0]][7:0], mem[actual_address[addr_width-1:0]][7:0]
              };
            end
          endcase
        end
          if (store) begin
            case (access[2:1])
              3'b000: begin
                mem[actual_address[addr_width-1:0]][7:0] <= data_in[7:0];
              end
              3'b001: begin
                mem[actual_address[addr_width-1:0]][7:0]   <= data_in[7:0];
                mem[actual_addressp1[addr_width-1:0]][7:0] <= data_in[15:8];
              end
              3'b010: begin
                mem[actual_address[addr_width-1:0]][7:0]   <= data_in[7:0];
                mem[actual_addressp1[addr_width-1:0]][7:0] <= data_in[15:8];
                mem[actual_addressp2[addr_width-1:0]][7:0] <= data_in[23:16];
                mem[actual_addressp3[addr_width-1:0]][7:0] <= data_in[31:24];
              end
              
            endcase
          end
      end
    end
  end
endmodule
