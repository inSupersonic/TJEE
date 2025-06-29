`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Wang Xingda
// 
// Create Date: 2025-05-29 12:02:24
// Design Name: Stopwatch on EGO1
// Module Name: number
// Project Name: Stopwatch
// Target Devices: Xilinx Artix-7 EGO1
// Tool Versions: Vivado 2024.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 1. 按钮输入消抖和上升沿检测
// 2. 秒表计时运行和暂停
// 3. 时间调节设置
// 4. 时间输出在数码管上
// 5. 协调显示和LED
/*
module Key(
    input   clk,
    input   rst,
    input   [4:0] btn,
    output  [7:0] seg_data,
    output  [7:0] seg_data2,
    output  [7:0] seg_cs,
    output  reg [5:0] led1,
    output  [7:0] led2
    );

    // 按键消抖和上升沿检测
    reg [4:0] key_vc;
    reg [4:0] key_vp;
    reg [19:0] keycnt;
    always @(posedge clk or negedge rst) begin
        if(!rst)
            begin
                keycnt <= 0;
                key_vc <= 4'd0;
            end else begin
            if (keycnt>=20'd999_999) begin
                keycnt <= 0;
                key_vc <= btn;
            end else 
                keycnt<=keycnt+20'd1;
            end
    end
    always @(posedge clk) begin
        key_vp <= key_vc;
    end
    // 按钮上升沿
    wire [4:0] key_rise_edge;
    assign key_rise_edge = (~key_vp[4:0]) & key_vc[4:0];
    // 时间的存储
    reg [6:0] centiseconds = 0;  // 0-99
    reg [5:0] seconds = 0;       // 0-59
    reg [5:0] minutes = 0;       // 0-59
    reg [1:0] statue = 0; // 0-run , 1-pause, 2-cd

    reg [5:0] location = 6'b000001;// 标记当前位置
    parameter Sm = 5'b00100;   //中
    parameter Su = 5'b10000;   //上
    parameter Sd = 5'b00010;   //下
    parameter Sl = 5'b01000;   //左
    parameter Sr = 5'b00001;   //右
    
    // 计时计数器 -- 把计数转换为时间
    integer timer_cnt;
    always @(posedge clk or negedge rst) begin
        if(!rst)
            begin
            location[5:0] = 6'b000001;
            led1[5:0] = 6'b111111;
            statue = 0;
            centiseconds = 0;
            seconds = 0;
            minutes = 0;
            timer_cnt <= 0;
            end
        else
            begin
            if(key_rise_edge==Sm)
                begin
                statue = ~statue;
                if(!statue) led1[5:0] = 6'b111111;
                else led1[5:0] = 6'b000001;
                end
            if(statue)
                begin
                case(key_rise_edge)
                    Sl: begin 
                        location[5:0] = {location[4:0],location[5]};
                        led1[5:0] = location[5:0];
                    end
                    Sr: begin 
                        location[5:0] = {location[0],location[5:1]};
                        led1[5:0] = location[5:0];
                    end
                    Su: 
                        case(location)
                            6'b000001: begin 
                                if(centiseconds >= 99) begin
                                    centiseconds = 0;
                                    if(seconds >= 59) begin
                                        seconds = 0;
                                        if(minutes >= 59) minutes = 0;
                                        else minutes = minutes + 1;
                                    end else seconds = seconds + 1;
                                end else centiseconds = centiseconds + 1;
                            end
                            6'b000010: begin 
                                if(centiseconds/10 >= 9) begin 
                                    centiseconds = centiseconds % 10;
                                    if(seconds >= 59) begin
                                        seconds = 0;
                                        if(minutes >= 59) minutes = 0;
                                        else minutes = minutes + 1;
                                    end else seconds = seconds + 1;
                                end else centiseconds = centiseconds + 10;
                            end
                            6'b000100: begin 
                                if(seconds >= 59) begin
                                    seconds = 0;
                                    if(minutes >= 59) minutes = 0;
                                    else minutes = minutes + 1;
                                end else seconds = seconds + 1;
                            end
                            6'b001000: begin 
                                if(seconds/10 >= 5) begin 
                                    seconds = seconds % 10;
                                    if(minutes >= 59) minutes = 0;
                                    else minutes = minutes + 1;
                                end else seconds = seconds + 10;
                            end
                            6'b010000: begin 
                                if(minutes >= 59) minutes = 0;
                                else minutes = minutes + 1;
                            end
                            6'b100000: begin 
                                if(minutes/10 >= 5) minutes = minutes % 10;
                                else minutes = minutes + 10;
                                if(minutes > 59) minutes = 59;
                            end
                        endcase  
                    Sd:  
                        case(location) 
                            6'b000001: begin 
                                if(centiseconds == 0) begin
                                    centiseconds = 99;
                                    if(seconds == 0) begin
                                        seconds = 59;
                                        if(minutes == 0) minutes = 59;
                                        else minutes = minutes - 1;
                                    end else seconds = seconds - 1;
                                end else centiseconds = centiseconds - 1;
                            end
                            6'b000010: begin 
                                if(centiseconds/10 == 0) begin
                                    centiseconds = centiseconds % 10 + 90;
                                    if(seconds == 0) begin
                                        seconds = 59;
                                        if(minutes == 0) minutes = 59;
                                        else minutes = minutes - 1;
                                    end else seconds = seconds - 1;
                                end else centiseconds = centiseconds - 10;
                            end
                            6'b000100: begin 
                                if(seconds == 0) begin
                                    seconds = 59;
                                    if(minutes == 0) minutes = 59;
                                    else minutes = minutes - 1;
                                end else seconds = seconds - 1;
                            end
                            6'b001000: begin 
                                if(seconds/10 == 0) begin
                                    seconds = seconds % 10 + 50;
                                    if(minutes == 0) minutes = 59;
                                    else minutes = minutes - 1;
                                end else seconds = seconds - 10;
                            end
                            6'b010000: begin 
                                if(minutes == 0) minutes = 59;
                                else minutes = minutes - 1;
                            end
                            6'b100000: begin 
                                if(minutes/10 == 0) minutes = minutes % 10 + 50;
                                else minutes = minutes - 10;
                            end
                        endcase
                endcase
                end
            else if(statue == 0 && timer_cnt >= 1_000_000)  // 0.01秒计时
                begin
                timer_cnt <= 0;
                if(centiseconds >= 99) begin
                    centiseconds = 0;
                    if(seconds >= 59) begin
                        seconds = 0;
                        if(minutes >= 59) minutes = 0;
                        else minutes = minutes + 1;
                    end else seconds = seconds + 1;
                end else centiseconds = centiseconds + 1;
                end
            else timer_cnt <= timer_cnt + 1;
            end
    end
    // 时间数据输出到data寄存器中转换为数码管显示
    reg [31:0] data;
    always @(centiseconds or seconds or minutes) begin

        data[31:28] = (minutes)/10;
        data[27:24] = (minutes)%10;

        data[23:20] = 04'hf;  // -

        data[19:16] = (seconds)/10;
        data[15:12] = (seconds)%10;

        data[11:8]  = 04'hf;  // -

        data[7:4]   = (centiseconds)/10;
        data[3:0]   = (centiseconds)%10;
    end
  
    number u1(  
        .clk(clk),
        .rst(rst),
        .data(data),
        .seg_data(seg_data),
        .seg_data2(seg_data2),
        .seg_cs(seg_cs)
    );

    led u2(
        .clk(clk),
        .rst(rst),
        .statue(statue),
        .led2(led2)
    );
endmodule
*/
module Key(
    input clk,
    input rst,
    input [4:0] btn,
    output [7:0] seg_data,
    output [7:0] seg_data2,
    output [7:0] seg_cs,
    output reg [5:0] led1,
    output [7:0] led2
);

    // 按键消抖和上升沿检测（保持不变）
    reg [4:0] key_vc;
    reg [4:0] key_vp;
    reg [19:0] keycnt;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            keycnt <= 0;
            key_vc <= 5'b0;
        end else begin
            if (keycnt >= 20'd999_999) begin
                keycnt <= 0;
                key_vc <= btn;
            end else begin
                keycnt <= keycnt + 1;
            end
        end
    end
    always @(posedge clk) begin
        key_vp <= key_vc;
    end
    wire [4:0] key_rise_edge;
    assign key_rise_edge = (~key_vp) & key_vc;

    // 时间存储和状态
    reg [6:0] centiseconds = 0;  // 0-99
    reg [5:0] seconds = 0;       // 0-59
    reg [5:0] minutes = 0;       // 0-59
    reg [1:0] statue = 0;        // 0-运行，1-暂停，2-倒计时
    reg [5:0] location = 6'b000001; // 标记当前位置
    parameter Sm = 5'b00100;     // 中
    parameter Su = 5'b10000;     // 上
    parameter Sd = 5'b00010;     // 下
    parameter Sl = 5'b01000;     // 左
    parameter Sr = 5'b00001;     // 右

    // 倒计时模块输出
    wire [6:0] centiseconds_out;
    wire [5:0] seconds_out;
    wire [5:0] minutes_out;
    wire countdown_done;

    // 计时和倒计时逻辑
    integer timer_cnt;
    /*
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            location <= 6'b000001;
            led1 <= 6'b111111;
            statue <= 0;
            centiseconds <= 0;
            seconds <= 0;
            minutes <= 0;
            timer_cnt <= 0;
        end else begin
            if (key_rise_edge == Sm) begin // 中键切换运行/暂停
                if (statue == 0) begin
                    statue <= 1;
                    led1 <= 6'b000001;
                end else if (statue == 1) begin
                    statue <= 0;
                    led1 <= 6'b111111;
                end
            end else if (key_rise_edge == Sr && statue == 1) begin // 暂停模式下右键进入倒计时
                statue <= 2;
                led1 <= 6'b000010;
            end else if (countdown_done && statue == 2 && key_rise_edge == Sm) begin // 倒计时结束时中键返回暂停
                statue <= 1;
                led1 <= 6'b000001;
            end*/
        always @(posedge clk or negedge rst) begin
        if(!rst) begin
            location[5:0] = 6'b000001; // 默认选中百秒个位
            led1[5:0] = 6'b000001;
            statue = 0;
            centiseconds = 0;
            seconds = 0;
            minutes = 0;
            timer_cnt <= 0;
        end else begin
            // 状态切换：运行 <-> 暂停，暂停 -> 倒计时
            if(key_rise_edge == Sm) begin
                if (statue == 0) begin
                    statue = 1;
                    location[5:0] = 6'b000001;
                    led1[5:0] = 6'b000001; // 显示当前调整位置
                end else if (statue == 1) begin
                    statue = 0;
                    led1[5:0] = 6'b111111; // 运行模式 LED 全亮
                end
            end else if (key_rise_edge == Sr && statue == 1) begin
                statue = 2;
                led1[5:0] = 6'b000000; // 倒计时模式 LED 指示
            end

            // 倒计时结束自动返回暂停模式
            if (statue == 2 && countdown_done) begin
                statue = 1;
                location[5:0]=6'b000001;
                led1[5:0] = 6'b000001; 
            end
            if (statue == 1) begin // 暂停模式，时间调整
                case (key_rise_edge)
                    Sl: begin 
                        location[5:0] = {location[4:0],location[5]};
                        led1[5:0] = location[5:0];
                    end
                    
                    // 时间取值的修改
                    Su: 
                        case(location)
                            6'b000001: begin 
                                if(centiseconds >= 99) begin
                                    centiseconds = 0;
                                    if(seconds >= 59) begin
                                        seconds = 0;
                                        if(minutes >= 59) minutes = 0;
                                        else minutes = minutes + 1;
                                    end else seconds = seconds + 1;
                                end else centiseconds = centiseconds + 1;
                            end
                            6'b000010: begin 
                                if(centiseconds/10 >= 9) begin 
                                    centiseconds = centiseconds % 10;
                                    if(seconds >= 59) begin
                                        seconds = 0;
                                        if(minutes >= 59) minutes = 0;
                                        else minutes = minutes + 1;
                                    end else seconds = seconds + 1;
                                end else centiseconds = centiseconds + 10;
                            end
                            6'b000100: begin 
                                if(seconds >= 59) begin
                                    seconds = 0;
                                    if(minutes >= 59) minutes = 0;
                                    else minutes = minutes + 1;
                                end else seconds = seconds + 1;
                            end
                            6'b001000: begin 
                                if(seconds/10 >= 5) begin 
                                    seconds = seconds % 10;
                                    if(minutes >= 59) minutes = 0;
                                    else minutes = minutes + 1;
                                end else seconds = seconds + 10;
                            end
                            6'b010000: begin 
                                if(minutes >= 59) minutes = 0;
                                else minutes = minutes + 1;
                            end
                            6'b100000: begin 
                                if(minutes/10 >= 5) minutes = minutes % 10;
                                else minutes = minutes + 10;
                                if(minutes > 59) minutes = 59;
                            end
                        endcase  
                    Sd:  
                        case(location) 
                            6'b000001: begin 
                                if(centiseconds == 0) begin
                                    centiseconds = 99;
                                    if(seconds == 0) begin
                                        seconds = 59;
                                        if(minutes == 0) minutes = 59;
                                        else minutes = minutes - 1;
                                    end else seconds = seconds - 1;
                                end else centiseconds = centiseconds - 1;
                            end
                            6'b000010: begin 
                                if(centiseconds/10 == 0) begin
                                    centiseconds = centiseconds % 10 + 90;
                                    if(seconds == 0) begin
                                        seconds = 59;
                                        if(minutes == 0) minutes = 59;
                                        else minutes = minutes - 1;
                                    end else seconds = seconds - 1;
                                end else centiseconds = centiseconds - 10;
                            end
                            6'b000100: begin 
                                if(seconds == 0) begin
                                    seconds = 59;
                                    if(minutes == 0) minutes = 59;
                                    else minutes = minutes - 1;
                                end else seconds = seconds - 1;
                            end
                            6'b001000: begin 
                                if(seconds/10 == 0) begin
                                    seconds = seconds % 10 + 50;
                                    if(minutes == 0) minutes = 59;
                                    else minutes = minutes - 1;
                                end else seconds = seconds - 10;
                            end
                            6'b010000: begin 
                                if(minutes == 0) minutes = 59;
                                else minutes = minutes - 1;
                            end
                            6'b100000: begin 
                                if(minutes/10 == 0) minutes = minutes % 10 + 50;
                                else minutes = minutes - 10;
                            end
                        endcase
                endcase
            end else if (statue == 0 && timer_cnt >= 1_000_000) begin
                timer_cnt <= 0;
                if (centiseconds >= 99) begin
                    centiseconds <= 0;
                    if (seconds >= 59) begin
                        seconds <= 0;
                        if (minutes >= 59) minutes <= 0;
                        else minutes <= minutes + 1;
                    end else seconds <= seconds + 1;
                end else centiseconds <= centiseconds + 1;
            end else if (statue == 0) begin
                timer_cnt <= timer_cnt + 1;
            end
        end
    end

    // 时间数据输出到 data 寄存器
    reg [31:0] data;
    always @(centiseconds or seconds or minutes or centiseconds_out or seconds_out or minutes_out) begin
        if (statue == 2) begin // 倒计时模式显示倒计时时间
            data[31:28] = minutes_out / 10;
            data[27:24] = minutes_out % 10;
            data[23:20] = 4'hf; // -
            data[19:16] = seconds_out / 10;
            data[15:12] = seconds_out % 10;
            data[11:8]  = 4'hf; // -
            data[7:4]   = centiseconds_out / 10;
            data[3:0]   = centiseconds_out % 10;
        end else begin // 运行或暂停模式显示正常时间
            data[31:28] = minutes / 10;
            data[27:24] = minutes % 10;
            data[23:20] = 4'hf; // -
            data[19:16] = seconds / 10;
            data[15:12] = seconds % 10;
            data[11:8]  = 4'hf; // -
            data[7:4]   = centiseconds / 10;
            data[3:0]   = centiseconds % 10;
        end
    end

    // 实例化 number 模块
    number u1(  
        .clk(clk),
        .rst(rst),
        .data(data),
        .seg_data(seg_data),
        .seg_data2(seg_data2),
        .seg_cs(seg_cs)
    );

    // 实例化 countdown 模块
    countdown u3(
        .clk(clk),
        .rst(rst),
        .statue(statue),
        .centiseconds_in(centiseconds),
        .seconds_in(seconds),
        .minutes_in(minutes),
        .centiseconds_out(centiseconds_out),
        .seconds_out(seconds_out),
        .minutes_out(minutes_out),
        .countdown_done(countdown_done)
    );

    // 实例化 led 模块
    led u2(
        .clk(clk),
        .rst(rst),
        .statue(statue),
        .countdown_done(countdown_done),
        .led2(led2)
    );

endmodule