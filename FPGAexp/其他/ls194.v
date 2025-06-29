
module clock_divider_1s (
    input wire clk_100MHz,   // 100MHz输入时钟
    input wire rst_n,        // 低电平有效复位
    output reg clk_1s        // 1Hz输出时钟
);

    // 50,000,000计数需要26位计数器 (2^26=67,108,864)
    reg [25:0] counter;
    
    always @(posedge clk_100MHz or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_1s <= 0;
        end
        else begin
            if (counter == 26'd49_999_999) begin  // 从0计数到49,999,999
                counter <= 0;
                clk_1s <= ~clk_1s;  // 翻转时钟信号
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule

module switch_control (
    input wire clk,          // 系统时钟
    input wire rst_n,       // 低电平有效复位
    input wire [3:0] sw,    // 4位拨码开关输入
    input wire [1:0] ctrl,  // 2位控制信号 (00:保持, 11:输入, 01:左移, 10:右移)
    input wire  shift,
    output reg [3:0] led    // 4位LED输出
);

    reg [3:0] reg_data;     // 4位寄存器存储当前值
    clock_divider_1s uut(
        .clk_100MHz(clk),
        .rst_n(rst_n),
        .clk_1s(clk_1s)
        
    );
    // 时序逻辑：根据控制信号更新寄存器
    always @(posedge clk_1s or negedge rst_n) begin
        if (!rst_n) begin
            reg_data <= 4'b0000; // 复位时寄存器清零
        end else begin
            case (ctrl)
                2'b00: begin
                    reg_data <= reg_data; // 保持当前值
                end
                2'b11: begin
                    reg_data <= sw; // 输入拨码开关值
                end
                2'b01: begin
                     reg_data <= {reg_data[2:0], shift}; // 左移1位，低位补0                  
                end
                2'b10: begin
                        reg_data <= {shift, reg_data[3:1]}; 
                end
                default: begin
                    reg_data <= reg_data; // 默认保持
                end
            endcase
        end
    end

    // 输出逻辑：寄存器值直接驱动LED
    always @(posedge clk_1s or negedge rst_n) begin
        if (!rst_n) begin
            led <= 4'b0000; // 复位时LED清零
        end else begin
            led <= reg_data; // LED显示寄存器值
        end
    end

endmodule