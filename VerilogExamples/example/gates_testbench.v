`timescale 1ps/1ps  // 设置时间精度为1ps

module gates_testbench;
    // 输入信号（每2ps自动翻转）
    reg a;
    reg b;
    reg [1:0] sel;  // 门选择信号
    wire y;         // 输出
    
    // 实例化被测模块
    gates_top uut (
        .sel(sel),
        .a(a),
        .b(b),
        .y(y)
    );
    
    // 生成每2ps翻转的a信号
    initial begin
        a = 0;
        forever #2 a = ~a;  // 每2ps翻转一次
    end
    
    // 生成每2ps翻转的b信号（相位偏移1ps）
    initial begin
        b = 0;
        #1;  // 初始相位偏移
        forever #2 b = ~b;
    end
    
    // 控制门选择信号
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, gates_testbench);
        
        // 测试AND门
        sel = 2'b00;
        #16;  // 观察8个完整周期
        
        // 测试OR门
        sel = 2'b01;
        #16;
        
        // 测试NOT门（只关注a信号）
        sel = 2'b10;
        #16;
        
        $finish;
    end
endmodule
