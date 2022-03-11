module decoder
(
  input [31:0] IR,
  output [2:0] funct3,
  output [6:0] funct7,
  output [4:0] rs1,
  output [4:0] rs2,
  output [4:0] rd,
  output [31:0] i_imm,
  output [31:0] s_imm,
  output [31:0] b_imm,
  output [31:0] u_imm,
  output [31:0] j_imm,
  output [4:0] opcode
);
  assign funct3[2:0] = IR[14:12];
  assign funct7[6:0] = IR[31:25];
  assign rs1[4:0] = IR[19:15];
  assign rs2[4:0] = IR[24:20];
  assign rd[4:0] = IR[11:7];
  assign i_imm[31:0] = { 21{IR[31]}, IR[30:25], IR[24:21], IR[20] };
  assign s_imm[31:0] = { 21{IR[31]}, IR[30:25], IR[11:8], IR[7] };
  assign b_imm[31:0] = { 20{IR[31]}, IR[7], IR[30:25], IR[11:8], 1'b0 };
  assign u_imm[31:0] = { IR[31], IR[30:20], IR[19:12], 13{'b0} };
  assign j_imm[31:0] = { 12{IR[31]}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
  assign opcode[4:0] = IR[6:2];
endmodule
