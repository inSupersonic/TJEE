module second_counter_12 (
    input clk_100MHz,      // 100MHz系统时钟
    input reset,           // 复位按钮(低电平有效)
    input enable,          // 使能开关(SW0)
    output reg [3:0] leds  // LED0-LED3输出
);

reg [26:0] counter;
wire clk_1Hz;

assign clk_1Hz = (counter == 27'd99_999_999);
always @(posedge clk_100MHz or negedge reset) begin
    if (!reset) begin
        counter <= 0;
    end else begin
        if (counter == 27'd99_999_999) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

always @(posedge clk_100MHz or negedge reset) begin
    if (!reset) begin
        leds <= 4'b0000;  // 同步复位
    end else if (enable && clk_1Hz) begin
        if (leds == 4'b1011) begin
            leds <= 4'b0000;
        end else begin
            leds <= leds + 1;
        end
    end
end

endmodule