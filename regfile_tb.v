`timescale 1ns/100ps

module regfile_tb();
  reg [4:0] read_reg1_addr;
  reg [4:0] read_reg2_addr;
  reg [4:0] write_reg_addr;
  reg [31:0] data_in;
  reg rst;
  reg write_ena;
  reg clk;
  
  wire [31:0] read_reg1_data;
  wire [31:0] read_reg2_data;
  
  localparam period = 10;
  initial
  begin
    rst           = 1;
    read_reg1_addr = 0;
    read_reg2_addr = 0;
    write_reg_addr = 0;
    data_in        = 0;
    write_ena = 0;
    // reset regs
    
    #period;
    rst           = 0;
    write_ena = 1;
    data_in        = 32'h114beef;
    write_reg_addr = 1;
    
    #period;
    write_ena = 1;
    data_in        = 32'hff1ce11;
    write_reg_addr = 2;
    
    #period;
    write_ena = 1;
    data_in        = 32'h1111111;
    write_reg_addr = 0; // try write to 0
    
    #period;
    write_ena = 0;
    data_in        = 0;
    write_reg_addr = 0;
    read_reg1_addr = 0;
    read_reg2_addr = 1;
    
    #period;
    read_reg1_addr = 2;
    read_reg2_addr = 3;
    #period;
    $stop;
  end
  initial begin
    clk            = 0;
    forever #1 clk = ~clk;
  end
  /*iverilog */
  initial begin
    $dumpfile("regfile_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, reg_tb);    //tb模块名称
  end
  /*iverilog */
  regfile regfile_t0 (
  .read_reg1_addr(read_reg1_addr),
  .read_reg2_addr(read_reg2_addr),
  .write_reg_addr(write_reg_addr),
  .data_in(data_in),
  .rst(rst),
  .write_ena(write_ena),
  .clk(clk),
  // Outputs
  .read_reg1_data(read_reg1_data),
  .read_reg2_data(read_reg2_data)
  );
  
endmodule
