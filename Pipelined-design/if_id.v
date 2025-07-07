module if_id(
    input clk, rst, pause, flush,
    // flush 清空流水线寄存器 处理分支预测
    // pause 暂停并保存当前值 处理数据冒险
    input [31: 0] if_pc,
    input [31: 0] if_instr,

    output reg [31: 0] id_pc,
    output reg [31: 0] id_instr
);
    // 三种模式
    always @(posedge clk) begin
        if(rst || flush) begin
            // 设置一个NOP操作
            id_pc = 32'd0;
            id_instr = {12'h0, 5'b0, 3'b000, 5'b0, 7'b0010011};
        end else if(pause) begin
            // 空操作
            // 阻止寄存器值改变
        end else begin
            // 正常工作
            id_pc <= if_pc;
            id_instr <= if_instr;
        end
    end

endmodule