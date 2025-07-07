module hazard_detection_unit(
    input [2: 0] ex_readMem,
    input [4: 0] ex_rd, id_rs1, id_rs2,

    output reg pause
);
    // 此模块检验加载指令是否存在数据冒险
    // 将当前指令的读寄存器和前面指令的源寄存器进行比较
    // 如果存在相同，则暂停当前指令的执行
    always @(*) begin
        pause = 1'b0;
        if((ex_readMem != 3'b000) && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            pause = 1'b1;
        end
    end

endmodule