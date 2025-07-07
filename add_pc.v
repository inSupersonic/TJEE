module add_pc(
    input [31: 0] pc,
    input [31: 0] imm32,
    input [31: 0] rs1Data,

    output reg [31: 0] pcImm,
    output reg [31: 0] rs1Imm
);
    always @(*) begin
        pcImm = pc + imm32; // 用于计算目标地址，实现程序跳转
        rs1Imm = rs1Data + imm32;// 用于计算内存访问地址或直接算术运算
    end
endmodule