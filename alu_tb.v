`timescale 1ns/1ns

module alu_tb();
  reg unsigned [31:0] a;
  reg unsigned [31:0] b;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg op;
  reg op_imm;
  
  wire eq;
  wire ge;
  wire less;
  wire ge_u;
  wire less_u;
  wire [31:0] res1;
  
  localparam period = 1;
  initial
  begin
    a      = 20;
    b      = 7;
    op     = 1;
    op_imm = 0;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    // +
    #period;
    funct7 = 7'b0100000;
    // -
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b001;
    // <<
    #period;
    funct3 = 3'b010;
    // slt
    #period;
    funct3 = 3'b011;
    // sltu
    #period;
    funct3 = 3'b100;
    // xor
    #period;
    funct3 = 3'b101;
    // logical right
    #period;
    funct7 = 7'b0100000;
    // arithmetic right
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b110;
    // or
    #period;
    funct3 = 3'b111;
    // and
    
    #period;
    
    a      = -100;
    b      = 4;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    // +
    #period;
    funct7 = 7'b0100000;
    // -
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b001;
    // <<
    #period;
    funct3 = 3'b010;
    // slt
    #period;
    funct3 = 3'b011;
    // sltu
    #period;
    funct3 = 3'b100;
    // xor
    #period;
    funct3 = 3'b101;
    // logical right
    #period;
    funct7 = 7'b0100000;
    // arithmetic right
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b110;
    // or
    #period;
    funct3 = 3'b111;
    // and
    
    #period;
    
    a      = 10000000;
    b      = -10000000;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    // +
    #period;
    funct7 = 7'b0100000;
    // -
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b001;
    // <<
    #period;
    funct3 = 3'b010;
    // slt
    #period;
    funct3 = 3'b011;
    // sltu
    #period;
    funct3 = 3'b100;
    // xor
    #period;
    funct3 = 3'b101;
    // logical right
    #period;
    funct7 = 7'b0100000;
    // arithmetic right
    #period;
    funct7 = 7'b0000000;
    funct3 = 3'b110;
    // or
    #period;
    funct3 = 3'b111;
    // and
  end
  
  /*iverilog */
  initial
  begin
    $dumpfile("alu_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, alu_tb);    //tb模块名称
  end
  /*iverilog */
  alu alu_t0 (
  .a(a),
  .b(b),
  .funct3(funct3),
  .funct7(funct7),
  
  // Outputs
  .eq(eq),
  .ge(ge),
  .less(less),
  .ge_u(ge_u),
  .less_u(less_u),
  .res1(res1)
  );
  
endmodule
