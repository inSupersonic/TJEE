module led(
    input clk,
    input rst,
    input [1:0] statue,             // 状态：0-运行，1-暂停，2-倒计时
    input countdown_done,           // 倒计时完成信号
    output reg [7:0] led2
);

    integer led_cnt;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            led_cnt <= 0;
            led2 <= 8'b01010101;
        end else if (statue == 0 && led_cnt >= 100_000_000) begin // 运行模式，1秒闪烁
            led_cnt <= 0;
            led2 <= ~led2;
        end else if (statue == 1 && led_cnt >= 33_333_333) begin // 暂停模式，0.333秒闪烁
            led_cnt <= 0;
            led2 <= ~led2;
        end else if (statue == 2) begin // 倒计时模式
            if (countdown_done && led_cnt >= 10_000_000) begin // 倒计时结束，0.1秒快速闪烁
                led_cnt <= 0;
                led2 <= ~led2;
            end else if (!countdown_done) begin // 倒计时进行中，全亮
                led_cnt <= 0;
                led2 <= 8'b11111111;
            end else begin
                led_cnt <= led_cnt + 1;
            end
        end else begin
            led_cnt <= led_cnt + 1;
        end
    end

endmodule