`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Wang Xingda
// 
// Create Date: 2025-06-05
// Design Name: Stopwatch on EGO1
// Module Name: countdown
// Project Name: Stopwatch
// Target Devices: Xilinx Artix-7 EGO1
// Tool Versions: Vivado 2024.2
// Description: Countdown timer functionality for stopwatch
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module countdown(
    input clk,                      // 系统时钟
    input rst,                      // 复位信号
    input [1:0] statue,             // 状态：0-运行，1-暂停，2-倒计时
    input [6:0] centiseconds_in,    // 输入百秒
    input [5:0] seconds_in,         // 输入秒
    input [5:0] minutes_in,         // 输入分钟
    output reg [6:0] centiseconds_out, // 输出百秒
    output reg [5:0] seconds_out,   // 输出秒
    output reg [5:0] minutes_out,   // 输出分钟
    output reg countdown_done        // 倒计时完成信号
);

    integer timer_cnt;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            centiseconds_out <= centiseconds_in;
            seconds_out <= seconds_in;
            minutes_out <= minutes_in;
            timer_cnt <= 0;
            countdown_done <= 0;
        end else if (statue == 2) begin // 倒计时模式
            if (centiseconds_out == 0 && seconds_out == 0 && minutes_out == 0) begin
                countdown_done <= 1; // 倒计时结束
                timer_cnt <= 0;
            end else if (timer_cnt >= 1_000_000) begin // 0.01秒计时
                timer_cnt <= 0;
                if (centiseconds_out == 0) begin
                    centiseconds_out <= 99;
                    if (seconds_out == 0) begin
                        seconds_out <= 59;
                        if (minutes_out == 0) begin
                            minutes_out <= 0; // 防止负数
                        end else begin
                            minutes_out <= minutes_out - 1;
                        end
                    end else begin
                        seconds_out <= seconds_out - 1;
                    end
                end else begin
                    centiseconds_out <= centiseconds_out - 1;
                end
            end else begin
                timer_cnt <= timer_cnt + 1;
            end
        end else begin
            // 非倒计时模式，保持输入时间
            centiseconds_out <= centiseconds_in;
            seconds_out <= seconds_in;
            minutes_out <= minutes_in;
            countdown_done <= 0;
            timer_cnt <= 0;
        end
    end

endmodule