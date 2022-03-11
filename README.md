# simple rv
## 如何进行测试

- 安装 iverilog 和 gtkwave
- 参考 `alu_tb.v` ，写一个测试文件。
- 编译： `iverilog -o alu_tb ./alu_tb.v alu.v`
- 运行，并生成波形图： `./alu_tb`
- 使用 gtkwave 打开生成的波形图文件： `open alu_wave.vcd`
- 检查波形是否正确，即可
