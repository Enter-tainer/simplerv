module single_cycle_cpu (input clk,
                         input vga_clk,
                         input rst,
                         input halt,
                         input kbd_ready,
                         input kbd_overflow,
                         input [7:0] kbd_data,
                         input [31:0] clk_cnt,
                         input [9:0] vram_addr_x,
                         input [9:0] vram_addr_y,
                         input uart_r_ready,
                         input uart_w_ready, 
                         input [7:0] uart_r_data,
                         input new_frame,
                        
                         output uart_r_enable, 
                         output uart_w_enable,
                         output [7:0] uart_w_data,
                         output vram_num,
                         output [11:0] vram_data,
                         output kbd_read_enable,
                         output [31:0] led_data);
  // IF stage
  wire [31:0] new_pc, current_pc;
  wire [31:0] IR;
  pc_reg pc0(
  .clk(clk),
  .rst(rst),
  .enable(~halt),
  .pc_address_in(new_pc),
  .pc_address_o(current_pc));
  rom instruction_rom(
  .addr(current_pc),
  .data_out(IR)
  );
  // ID stage
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire [4:0] rs1, rs2, rd;
  wire [31:0] i_imm, s_imm, b_imm, u_imm, j_imm;
  wire load, store, branch, jalr, jal, lui, auipc, op_imm, op, system;
  decoder instruction_decoder(
  .IR(IR),
  .funct3(funct3),
  .funct7(funct7),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .i_imm(i_imm),
  .s_imm(s_imm),
  .b_imm(b_imm),
  .u_imm(u_imm),
  .j_imm(j_imm),
  .load(load),
  .store(store),
  .branch(branch),
  .jalr(jalr),
  .jal(jal),
  .lui(lui),
  .auipc(auipc),
  .op_imm(op_imm),
  .op(op),
  .system(system)
  );
  reg [31:0] rd_in;
  reg write_ena;
  wire [31:0] rs1_data, rs2_data;
  regfile regs(
  .read_reg1_addr(rs1),
  .read_reg2_addr(rs2),
  .write_reg_addr(rd),
  .data_in(rd_in),
  .rst(rst),
  .write_ena(write_ena),
  .clk(clk),
  .read_reg1_data(rs1_data),
  .read_reg2_data(rs2_data)
  );
  // EX stage
  wire [31:0] alu_input_a, alu_input_b, alu_out;
  wire eq, ge, less, ge_u, less_u;
  assign alu_input_a = rs1_data;
  assign alu_input_b = op_imm ? i_imm : rs2_data;
  alu alu_0(
  .a(alu_input_a),
  .b(alu_input_b),
  .funct3(funct3),
  .funct7(funct7),
  .op(op),
  .op_imm(op_imm),
  
  .eq(eq),
  .ge(ge),
  .less(less),
  .ge_u(ge_u),
  .less_u(less_u),
  .res1(alu_out)
  );
  wire branch_taken;
  branch branch_0 (
  .funct3(funct3),
  .eq(eq),
  .ge(ge),
  .less(less),
  .ge_u(ge_u),
  .less_u(less_u),
  .branch(branch),
  .taken(branch_taken));
  wire [31:0] branch_target, jal_target, jalr_target, load_address, store_address, auipc_res, mem_address;
  assign branch_target = b_imm[31:0] + current_pc[31:0];
  assign jal_target    = current_pc[31:0] + j_imm[31:0];
  assign jalr_target   = rs1_data[31:0] + i_imm[31:0];
  assign load_address  = rs1_data[31:0] + i_imm[31:0];
  assign store_address = rs1_data[31:0] + s_imm[31:0];
  assign auipc_res     = current_pc[31:0] + u_imm[31:0];
  // MEM stage
  assign mem_address = load ? load_address : store_address;
  wire [31:0] ram_data_in, ram_data_out;
  assign ram_data_in[31:0] = rs2_data[31:0];
  mmio mmio0(.clk(clk),
  .vga_clk(vga_clk),
  .rst(rst),
  .load(load),
  .store(store),
  .access(funct3[2:0]),
  .addr(mem_address[31:0]),
  .data_in(ram_data_in),
  .kbd_ready(kbd_ready),
  .kbd_overflow(kbd_overflow),
  .kbd_data(kbd_data),
  .clk_cnt(clk_cnt),
  .vram_addr_x(vram_addr_x),
  .vram_addr_y(vram_addr_y),
  .uart_r_ready(uart_r_ready),
  .uart_w_ready(uart_w_ready), 
  .uart_r_data(uart_r_data),
  .new_frame(new_frame),
  
  .uart_r_enable(uart_r_enable), 
  .uart_w_enable(uart_w_enable),
  .uart_w_data(uart_w_data),
  .vram_data(vram_data),
  .led_data(led_data),
  .kbd_read_enable(kbd_read_enable),
  .vram_num(vram_num),
  .data_out(ram_data_out));
  // WB stage
  always @(*) begin
    write_ena = 1;
    if (auipc) begin
      rd_in[31:0] = auipc_res;
      end else if (jal || jalr) begin
      rd_in[31:0] = current_pc[31:0] + 4;
      end else if (load) begin
      rd_in[31:0] = ram_data_out[31:0];
      end else if (lui) begin
      rd_in[31:0] = u_imm[31:0];
      end else if (op || op_imm) begin
      rd_in[31:0] = alu_out[31:0];
      end else begin
      write_ena   = 0;
      rd_in[31:0] = 32'b0;
    end
  end
  next_pc next_pc_0(
  .branch_taken(branch_taken),
  .jalr(jalr),
  .jal(jal),
  .branch_target(branch_target),
  .jalr_target(jalr_target),
  .jal_target(jal_target),
  .current_pc(current_pc),
  
  .new_pc(new_pc));
endmodule
