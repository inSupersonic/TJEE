`timescale 1ns / 1ps
module test_cpu();
    reg clk, rst;
    cpu CPU(clk, rst);
    // 初始复位操作
    initial begin
        clk = 1'b0;
        rst = 1'b0;
        #10 rst = 1'b1;
        #10 rst = 1'b0;
    end
    // 时钟周期
    always begin
        #5 clk = ~clk;
    end
    always @(posedge clk) begin
        $display("Time=%0t, clk=%b, pause=%b, flush=%b, inst=0x%h, alu_out=0x%h",
                 $time, CPU.clk, CPU.pause, CPU.flush, CPU.id_instr, CPU.ex_outAlu);
    end
    // 波形生成
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, test_cpu);
        #1000 $finish;
    end
    
endmodule