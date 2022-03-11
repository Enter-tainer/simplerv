`timescale 1ns/100ps

module ram_tb();
  reg clk;
  reg rst;
  reg load;
  reg store;
  reg [2:0] access;
  reg [31:0] addr;
  reg [31:0] data_in;
  wire [31:0] data_out;
  // 000 LB
  // 001 LH
  // 010 LW
  // 100 LBU
  // 101 LHU
  localparam period = 2;
  initial
  begin
    rst     = 1;
    load    = 0;
    store   = 0;
    access  = 0;
    addr    = 0;
    data_in = 0;
    // reset ram
    
    #period;
    rst = 0;
    // test sw
    store   = 1;
    access  = 3'b010;
    addr    = 0;
    data_in = 32'h01234567;
    
    #period;
    // test sw
    store   = 1;
    access  = 3'b010;
    addr    = 4;
    data_in = 32'h76543201;
    
    #period;
    // test sh
    store   = 1;
    access  = 3'b001;
    addr    = 2;
    data_in = 32'hAABB;
    #period;
    // test sh
    store   = 1;
    access  = 3'b001;
    addr    = 6;
    data_in = 32'hCCDD;
    
    #period;
    // test sb
    store   = 1;
    access  = 3'b000;
    addr    = 5;
    data_in = 32'h77;
    #period;
    // test sb
    store   = 1;
    access  = 3'b000;
    addr    = 7;
    data_in = 32'h88;
    
    #period;
    rst = 0;
    // fill data
    store   = 1;
    access  = 3'b010;
    addr    = 0;
    data_in = 32'h00112233;
    
    #period;
    // fill data
    store   = 1;
    access  = 3'b010;
    addr    = 4;
    data_in = 32'hAABBCCDD;
    
    
    #period;
    store = 0;
    load  = 1;
    // start test load
    
    #period;
    // test lb
    addr   = 7;
    access = 3'b000;
    
    #period;
    // test lb
    addr   = 1;
    access = 3'b000;
    
    #period;
    // test lbu
    addr   = 7;
    access = 3'b100;
    
    #period;
    // test lbu
    addr   = 1;
    access = 3'b100;
    
    #period;
    // test lh
    addr   = 6;
    access = 3'b001;
    
    #period;
    // test lh
    addr   = 2;
    access = 3'b001;
    
    #period;
    // test lhu
    addr   = 6;
    access = 3'b101;
    #period;
    // test lhu
    addr   = 2;
    access = 3'b101;
    
    #period;
    // test lw
    addr   = 0;
    access = 3'b010;
    
    #period;
    // test lw
    addr   = 4;
    access = 3'b010;
    #period;
    $stop;
    
  end
  initial begin
    clk            = 0;
    forever #1 clk = ~clk;
  end
  /*iverilog */
  initial begin
    $dumpfile("ram_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, ram_tb);    //tb模块名称
  end
  /*iverilog */
  ram ram_t0 (
  .clk(clk),
  .rst(rst),
  .load(load),
  .store(store),
  .access(access),
  .addr(addr),
  .data_in(data_in),
  // Outputs
  .data_out(data_out)
  );
  
endmodule
