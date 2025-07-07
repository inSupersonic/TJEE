module id_ex(
    input clk, rst, pause, flush,
    // flush 清空流水线寄存器 处理分支预测
    // pause 暂停并保存当前值 处理数据冒险
    input [ 4: 0] id_aluc,
    input id_aluOut_WB_memOut,
    input id_rs1Data_EX_PC,
    input [ 1: 0] id_rs2Data_EX_imm32_4,
    
    input id_writeReg,
    input [ 1: 0] id_writeMem,
    input [ 2: 0] id_readMem,
    input [ 1: 0] id_pcImm_NEXTPC_rs1Imm,
    input [31: 0] id_pc,
    input [31: 0] id_rs1Data, id_rs2Data,
    input [31: 0] id_imm32,
    input [ 4: 0] id_rd,
    input [ 4: 0] id_rs1,
    input [ 4: 0] id_rs2,
    /*
    * ID/EX pipeline reg
    * ------------------------------------------------------------------------------------
    * | signal                  | in/out | bits  | use                             
    * ------------------------------------------------------------------------------------
    * | 控制信号（来自ID阶段）：                                                       
    * | ------------------------|--------|-------|----------------------------------------
    * | id_aluc                 | input  | [4:0] | alucontrol            
    * | id_aluOut_WB_memOut     | input  | 1     | 写回选择：0=ALUout，1=data in mem         
    * | id_rs1Data_EX_PC        | input  | 1     | rs1数据源：0=Regfile，1=PC auipc    
    * | id_rs2Data_EX_imm32_4   | input  | [1:0] | rs2数据源：00=Regfile，01=Imm，11='+4'
    * | id_writeReg             | input  | 1     | RegWrite               
    * | id_writeMem             | input  | [1:0] | 内存写入控制：00=不写，01=word，10=half   
    * | id_readMem              | input  | [2:0] | 内存读取控制：000=不读，001=word，010=half 
    * | id_pcImm_NEXTPC_rs1Imm  | input  | [1:0] | PC更新源：00=PC+4，01=pcImm,10=rs1Imm 
    * | 数据信号（来自ID阶段）：                                                       
    * | ------------------------|--------|-------|----------------------------------------
    * | id_pc                   | input  | [31:0]| pc now                       
    * | id_rs1Data/id_rs2Data   | input  | [31:0]| data in rs1/rs2                 
    * | id_imm32                | input  | [31:0]| extended imm32             
    * | id_rd/id_rs1/id_rs2     | input  | [4:0] | address of reg
    */
    output reg [ 4: 0] ex_aluc,
    output reg ex_aluOut_WB_memOut,
    output reg ex_rs1Data_EX_PC,
    output reg [ 1: 0] ex_rs2Data_EX_imm32_4,
    output reg ex_writeReg,
    output reg [ 1: 0] ex_writeMem,
    output reg [ 2: 0] ex_readMem,
    output reg [ 1: 0] ex_pcImm_NEXTPC_rs1Imm,
    output reg [31: 0] ex_pc,
    output reg [31: 0] ex_rs1Data, ex_rs2Data,
    output reg [31: 0] ex_imm32,
    output reg [ 4: 0] ex_rd,
    output reg [ 4: 0] ex_rs1,
    output reg [ 4: 0] ex_rs2
);

    always @(posedge clk) begin
        if(rst || pause || flush)begin
            ex_aluc = 5'b00000;
            ex_aluOut_WB_memOut = 1'b0;
            ex_rs1Data_EX_PC = 1'b0;
            ex_rs2Data_EX_imm32_4 = 2'b01;
            ex_writeReg = 1'b1;
            ex_writeMem = 2'b00;
            ex_readMem = 3'b000;
            ex_pcImm_NEXTPC_rs1Imm = 2'b00;
            ex_pc = 32'h0;
            ex_rs1Data = 32'd0;
            ex_rs2Data = 32'd0;
            ex_imm32 = 32'd0;
            ex_rd = 5'd0;
            ex_rs1 = 5'd0;
            ex_rs2 = 5'd0;
        end else begin
            ex_aluc <= id_aluc;
            ex_aluOut_WB_memOut <= id_aluOut_WB_memOut;
            ex_rs1Data_EX_PC <= id_rs1Data_EX_PC;
            ex_rs2Data_EX_imm32_4 <= id_rs2Data_EX_imm32_4;
            ex_writeReg <= id_writeReg;
            ex_writeMem <= id_writeMem;
            ex_readMem <= id_readMem;
            ex_pcImm_NEXTPC_rs1Imm <= id_pcImm_NEXTPC_rs1Imm;
            ex_pc <= id_pc;
            ex_rs1Data <= id_rs1Data;
            ex_rs2Data <= id_rs2Data;
            ex_imm32 <= id_imm32;
            ex_rd <= id_rd;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
        end
    end
endmodule