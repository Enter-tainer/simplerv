module pc_reg
  (
  input clk,
  input rst,
  input enable,
  input [31:0] pc_address_in,
  output reg [31:0] pc_address_o
  );
  
  always@(posedge clk) begin
    if (rst == 1) begin
      pc_address_o <= 32'b0;
      end else begin
      if (enable == 1) begin
        pc_address_o <= pc_address_in;
        end else begin
        pc_address_o <= pc_address_o;
      end
    end
  end
  
  
endmodule
