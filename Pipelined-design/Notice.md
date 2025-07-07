# 使用方式
1. design文件夹内部包含了所有模块的Verilog代码和tb文件，以及波形仿真结果。
**运行方式**
``` verilog 
    iverilog -o output *.v
    vvp output
    gtkwave waveform.vcd
```
