module regfile (input [4:0] read_reg1_addr,
                input [4:0] read_reg2_addr,
                input [4:0] write_reg_addr,
                input [31:0] data_in,
                input rst,
                input write_ena,
                input clk,
                output [31:0] read_reg1_data,
                output [31:0] read_reg2_data
                );
reg [31:0]regs[31:0];
integer i;

wire [31:0] reg0, reg1, reg2, reg3, reg4, reg9, a0;
assign reg0           = regs[0];
assign reg1           = regs[1];
assign reg2           = regs[2];
assign reg3           = regs[3];
assign reg4           = regs[4];
assign reg9           = regs[9];
assign a0             = regs[10];
assign read_reg1_data = regs[read_reg1_addr];
assign read_reg2_data = regs[read_reg2_addr];
always@(posedge clk) begin
  if (rst == 1) begin
    for (i = 0; i < 32; i = i + 1)
      regs[i] <= 32'b0;
  end
  else begin
    if (write_ena == 1 && write_reg_addr) begin
      regs[write_reg_addr] <= data_in;
    end
  end
end


endmodule
