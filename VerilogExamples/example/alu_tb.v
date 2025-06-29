`timescale 1ns/1ps

module alu_tb;

    reg clk;
    reg reset;
    reg [7:0] opb;
    reg [3:0] opcode;
    reg cin;
    wire [7:0] result;
    wire cout;

    // 实例化 ALU 顶层模块
    alu_with_acc uut (
        .clk(clk),
        .reset(reset),
        .opb(opb),
        .opcode(opcode),
        .cin(cin),
        .result(result),
        .cout(cout)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz 时钟
    end

    // 主测试过程
    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_tb);

        // 初始化
        reset = 1;
        cin = 0;
        opb = 8'h00;
        opcode = 4'b0000;
        #20;          // 延长复位时间，覆盖一个时钟边沿
        reset = 0;
        @(posedge clk); // 等待复位后的第一个时钟边沿

        // ========== 第一步：ADD ==========
        opb = 8'h23;
        opcode = 4'b0000; // ADD
        cin = 0;
        @(posedge clk);   // 等待时钟边沿更新 acc
        #1;               // 稍作延迟以观察波形

        // ========== 第二步：ADD again ==========
        opb = 8'h05;
        @(posedge clk);
        #1;

        // ========== 第三步：AND ==========
        opcode = 4'b0011; // AND
        opb = 8'h56;
        @(posedge clk);
        #1;

        // ========== 第四步：ROL ==========
        opcode = 4'b0110; // ROL
        @(posedge clk);
        #1;

        // ========== 第五步：ADD A0 ==========
        opcode = 4'b0000; // ADD
        opb = 8'hA0;
        @(posedge clk);
        #1;

        // ========== 第六步：CMP ==========
        opcode = 4'b1001; // CMP
        opb = 8'h50;
        @(posedge clk);
        #1;

        $finish;
    end
endmodule