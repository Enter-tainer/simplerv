module regfile (input [4:0] read_reg1_addr,
                input [4:0] read_reg2_addr,
                input [4:0] write_reg_addr,
                input [31:0] data_in,
                input rstn,
                input write_read_ena,
                input clk,
                output reg [31:0] read_reg1_data	,
                output reg [31:0] read_reg2_data);
reg [31:0]regs[31:0];
integer i;
initial begin
  for (i = 0; i < 32; i = i + 1)
    regs[i] <= 32'b0;
end
always@(rstn, posedge clk) begin
  if (rstn == 0) begin
    for (i = 0; i < 32; i = i + 1)
      regs[i] <= 32'b0;
  end
  else begin
    if (write_read_ena == 1) begin
      if (write_reg_addr ! = 0)
        regs[write_reg_addr] <= data_in;
      else
        regs[write_reg_addr] <= 32'b0;
    end
    else begin
      read_reg1_data <= regs[read_reg1_addr];
      read_reg2_data <= regs[read_reg2_addr];
    end
  end
end


endmodule

module pc_reg
  (
  input clk,
  input rstn,
  input [31:0] pc_address_in,
  output reg [31:0] pc_address_o
  );
  
  always@(rstn, posedge clk) begin
    if (rstn == 0) begin
      pc_address_o <= 32'b0;
      end else begin
      if (clk) begin
        pc_address_o <= pc_address_in;
        end else begin
        pc_address_o <= pc_address_o;
      end
    end
  end
  
  
endmodule
