module forward_unit(
    // 前递转发：检测数据冒险并控制数据前递路径，避免流水线暂停

    input me_writeReg,      // ME是否写寄存器 (1:写, 0:不写)
    input wb_writeReg,      // WB是否写寄存器 (1:写, 0:不写)
    input [4:0] me_rd,      // ME目标寄存器地址
    input [4:0] wb_rd,      // WB目标寄存器地址
    input [4:0] ex_rs1,     // EXrs1源寄存器
    input [4:0] ex_rs2,     // EXrs2源寄存器
    input [4:0] me_rs2,     // MEM -- rs2 -- store

    output reg [1: 0] ex_forwardA, ex_forwardB,
    // EX前递: 00 = 不转发（用寄存器文件值）; 01 = 转发ME结果 ; 10 = 转发WB结果
    output reg me_forwardC
    // ME控制: 0 = 不转发（用寄存器文件值）; 1 = 转发WB结果
);

    always @(*) begin
        // 默认值不转发
        ex_forwardA = 2'b00;
        ex_forwardB = 2'b00;
        me_forwardC = 1'b0;

        // 所有检测的wb_rd写回寄存器不能是5'b0, 且wb_writeReg控制信号为1
        // 情况1：WB EX-rs1转发ALU-A 目标EX.rs1
        if(wb_writeReg && (wb_rd != 5'd0) && (wb_rd == ex_rs1)) begin
            ex_forwardA = 2'b10;
        end

        // 情况2：WB EX-rs2转发ALU-B 目标EX.rs2
        if(wb_writeReg && (wb_rd != 5'd0) && (wb_rd == ex_rs2)) begin
            ex_forwardB = 2'b10;
        end

        // 情况3：MEM EX-rs1转发（更高优先级）目标EX.rs1
        if(me_writeReg && (me_rd != 5'd0) && (me_rd == ex_rs1)) begin
            ex_forwardA = 2'b01;
        end

        // 情况4：MEM EX-rs2转发（更高优先级）目标EX.rs2
        if(me_writeReg && (me_rd != 5'd0) && (me_rd == ex_rs2)) begin
            ex_forwardB = 2'b01;
        end

        // lw sw
        if(wb_writeReg && (wb_rd != 5'd0) && (wb_rd == me_rs2)) begin
            me_forwardC = 1'b1;
        end
    end

endmodule