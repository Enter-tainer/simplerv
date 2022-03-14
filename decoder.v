module decoder (input [31:0] IR,
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
                output load,
                output store,
                output branch,
                output jalr,
                output jal,
                output lui,
                output auipc,
                output op_imm,
                output op,
                output system);
assign funct3[2:0] = IR[14:12];
assign funct7[6:0] = IR[31:25];
assign rs1[4:0]    = IR[19:15];
assign rs2[4:0]    = IR[24:20];
assign rd[4:0]     = IR[11:7];
assign i_imm[31:0] = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
assign s_imm[31:0] = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
assign b_imm[31:0] = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0 };
assign u_imm[31:0] = { IR[31], IR[30:20], IR[19:12], 12'b0 };
assign j_imm[31:0] = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
wire [4:0] opcode;
assign opcode[4:0] = IR[6:2];
assign load        = opcode[4:0] == 5'b00000 ? 1'b1 : 1'b0; // lh lu lw ...
assign store       = opcode[4:0] == 5'b01000 ? 1'b1 : 1'b0; // sw sh ...
assign branch      = opcode[4:0] == 5'b11000 ? 1'b1 : 1'b0; // bge ...
assign jalr        = opcode[4:0] == 5'b11001 ? 1'b1 : 1'b0; 
assign jal         = opcode[4:0] == 5'b11011 ? 1'b1 : 1'b0;
assign lui         = opcode[4:0] == 5'b01101 ? 1'b1 : 1'b0;
assign auipc       = opcode[4:0] == 5'b00101 ? 1'b1 : 1'b0;
assign op_imm      = opcode[4:0] == 5'b00100 ? 1'b1 : 1'b0; // addi xori ...
assign op          = opcode[4:0] == 5'b01100 ? 1'b1 : 1'b0; // add xor ...
assign system      = opcode[4:0] == 5'b11100 ? 1'b1 : 1'b0; // ecall csrxxx ebreak ...
endmodule
