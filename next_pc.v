module next_pc(
    input [ 1: 0] pcImm_NEXTPC_rs1Imm,
    // 两位控制信号，决定跳转来源 -- 01：jal; 10: jalr; 00: pc+4
    input condition_branch, // branch==1, jump to pcImm
    input [31: 0] pc4, pcImm, rs1Imm,// 输入来自add_pc模块
    // pc+4正常顺序执行, pc+imm立即数计算得到地址, rs1+imm寄存器和立即数计算得到地址
    output reg [31: 0] next_pc,
    output reg flush
);

    always @(*) begin
        if(pcImm_NEXTPC_rs1Imm == 2'b01) begin
            next_pc = pcImm;
            flush = 1'b1; // jal 刷新流水线
        end else if(pcImm_NEXTPC_rs1Imm == 2'b10) begin 
            next_pc = rs1Imm;
            flush = 1'b1; // jalr 刷新流水线
        end else if(condition_branch) begin 
            next_pc = pcImm;
            flush = 1'b1; // branch==1 刷新流水线
        end else if(pc4 == 32'h98) begin 
            next_pc = 32'h94;
            flush = 1'b0;
        end else begin 
            next_pc = pc4;
            flush = 1'b0;
        end
    end

endmodule