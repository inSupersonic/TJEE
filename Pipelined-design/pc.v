module pc(
    input rst, clk, pause, flush,
    input      [31: 0] next_pc, //从next_pc模块输入新指令
    output reg [31: 0] pc // 处理得到本条指令
);
    always @(posedge clk) begin
        if(rst) begin
            pc <= 32'h5c;
        end else if(flush) begin
            pc <= next_pc;
            // 发生跳转分支的时候把指令强制更新，清空流水线
        end else if(pause) begin
            // 解决datahazard，空操作阻止寄存器值改变
        end else begin
            pc <= next_pc;
        end 
    end
endmodule