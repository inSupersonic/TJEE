module overflow_two8bits_tb();
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] s;
    wire overflow;

    // 实例化待测试的模块
    top_module uut (
        .a(a),
        .b(b),
        .s(s),
        .overflow(overflow)
    );

    initial begin
        // 初始化输入信号
        a = 8'b00000000;
        b = 8'b00000000;

        // 遍历一些关键测试用例
        #10 {a, b} = {8'b01111111, 8'b00000001}; // 正溢出测试
        #10 {a, b} = {8'b10000000, 8'b11111111}; // 负溢出测试
        #10 {a, b} = {8'b01111111, 8'b01111111}; // 正数相加不溢出
        #10 {a, b} = {8'b10000000, 8'b10000000}; // 负数相加不溢出
        #10 $finish;
    end

    // 波形记录
    initial begin
        $dumpfile("overflow_two8bits.vcd");
        $dumpvars(0, overflow_two8bits_tb);
    end
endmodule