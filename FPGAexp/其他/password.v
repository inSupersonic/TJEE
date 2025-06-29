module password_lock (
    input wire SW1, SW2, SW3, SW4, SW5, // 5位密码输入
    input wire SW8,                     // 使能信号
    output reg LED0,                    // 密码正确指示（1正确，0错误）
    output reg LED3                     // 报警指示（1报警，0不报警）
);

    // 定义4个有效密码
    wire [4:0] password = {SW5, SW4, SW3, SW2, SW1}; // 组合输入密码
    wire correct; // 密码是否正确的标志

    // 检查密码是否匹配4个预设密码之一
    assign correct = (password == 5'b11001) || 
                     (password == 5'b10111) || 
                     (password == 5'b01010) || 
                     (password == 5'b11100);

    // 输出逻辑
    always @(*) begin
        if (SW8 == 1'b0) begin
            LED0 = 1'b0; // SW8=0时，输出全为0
            LED3 = 1'b0;
        end else begin
            if (correct) begin
                LED0 = 1'b1; // 密码正确，LED0=1，LED3=0
                LED3 = 1'b0;
            end else begin
                LED0 = 1'b0; // 密码错误，LED0=0，LED3=1
                LED3 = 1'b1;
            end
        end
    end

endmodule