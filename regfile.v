module regfile (input [4:0] read_reg1_addr,
                input [4:0] read_reg2_addr,
                input [4:0] write_reg_addr,
                input [31:0] data_in,
                input rst,
                input write_ena,
                input clk,
                output reg [31:0] read_reg1_data	,
                output reg [31:0] read_reg2_data);
reg [31:0]regs[31:0];
integer i;
always@(posedge clk) begin
  if (rst == 1) begin
    for (i = 0; i < 32; i = i + 1)
      regs[i] <= 32'b0;
  end
  else begin
    if (write_ena == 1) begin
      if (write_reg_addr != 0)
        regs[write_reg_addr] <= data_in;
      else
        regs[write_reg_addr] <= 32'b0;
    end
    read_reg1_data[31:0] <= regs[read_reg1_addr][31:0];
    read_reg2_data[31:0] <= regs[read_reg2_addr][31:0];
  end
end


endmodule
