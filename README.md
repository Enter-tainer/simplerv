# simple rv
## 如何进行测试

- 安装 iverilog 和 gtkwave
- 参考 `alu_tb.v` ，写一个测试文件。
- 编译： `iverilog -o alu_tb ./alu_tb.v alu.v`
  - 编译单周期 CPU 的命令： `iverilog ./single_cycle_cpu_tb.v -y . -o single_cycle_cpu_tb`
- 运行，并生成波形图： `./alu_tb`
  - 注意，运行时序电路时，需要使用命令 `vvp -n reg_tb -vcd` 来生成波形图
- 使用 gtkwave 打开生成的波形图文件： `open alu_wave.vcd`
- 检查波形是否正确，即可
