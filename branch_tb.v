`timescale 1ns/1ns

module branch_tb();
  reg [2:0] funct3;
  reg eq;
  reg ge;
  reg less;
  reg ge_u;
  reg less_u;
  reg branch;

  wire taken;
  
  localparam period = 1;
  initial
  begin
    branch = 1;
    // test branch succeed
    // beq
    eq = 1;
    funct3 = 3'b000;
    #period;
    if (taken !== 1) $display("failed");
    // bne
    eq = 0;
    funct3 = 3'b001;
    #period;
    if (taken !== 1) $display("failed");
    // blt
    less = 1;
    funct3 = 3'b100;
    #period;
    if (taken !== 1) $display("failed");
    // bge
    ge = 1;
    funct3 = 3'b101;
    #period;
    if (taken !== 1) $display("failed");
    // bltu
    less_u = 1;
    funct3 = 3'b110;
    #period;
    if (taken !== 1) $display("failed");
    // bgeu
    ge_u = 1;
    funct3 = 3'b111;
    #period;
    if (taken !== 1) $display("failed");

    
    // test branch failed
    // beq
    eq = 0;
    funct3 = 3'b000;
    #period;
    if (taken !== 0) $display("failed");
    // bne
    eq = 1;
    funct3 = 3'b001;
    #period;
    if (taken !== 0) $display("failed");
    // blt
    less = 0;
    funct3 = 3'b100;
    #period;
    if (taken !== 0) $display("failed");
    // bge
    ge = 0;
    funct3 = 3'b101;
    #period;
    if (taken !== 0) $display("failed");
    // bltu
    less_u = 0;
    funct3 = 3'b110;
    #period;
    if (taken !== 0) $display("failed");
    // bgeu
    ge_u = 0;
    funct3 = 3'b111;
    #period;
    if (taken !== 0) $display("failed");
  end
  
  /*iverilog */
  initial
  begin
    $dumpfile("branch_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, branch_tb);    //tb模块名称
  end
  /*iverilog */
  branch branch_t0 (
  .funct3(funct3),
  .eq(eq),
  .ge(ge),
  .less(less),
  .ge_u(ge_u),
  .less_u(less_u),
  .branch(branch),
  
  // Outputs
  .taken(taken)
  );
  
endmodule
