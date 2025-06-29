module controller(
    input [6: 0] opcode,
    input [2: 0] func3,
    input [6: 0] func7,

    output reg [4: 0] ALUcontrols,
    output reg ALUResult_WB_MemRead_data, rs1Data_EX_PC, 
    output reg [1: 0] rs2Data_EX_imm32_4,
    output reg RegWrite, 
    output reg [1: 0] MemWrite, 
    output reg [2: 0] MemRead,
    output reg [2: 0] ImmSrc,
    output reg [1: 0] BranchNoCondition
);
    // 对于每一种类型定义的指令，给出对应的控制信号。
always @(*) begin
    case (opcode)
        // lui
        7'b0110111:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b00000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b001;
        end
        // auipc
        7'b0010111:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b01;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b00000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b001;
        end
        // jal
        7'b1101111:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b11;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b00000;
            BranchNoCondition = 2'b01;
            ImmSrc = 3'b100;
        end
        // jalr
        7'b1100111:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b11;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b01010;
            BranchNoCondition = 2'b10;
            ImmSrc = 3'b000;
        end
        // B型指令
        7'b1100011:begin
            RegWrite = 0;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b00;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b011;
            case (func3)
                // beq
                3'b000:begin
                    ALUcontrols = 5'b01011;
                end
                // bne
                3'b001:begin
                    ALUcontrols = 5'b01100;
                end
                // blt
                3'b100: begin
                    ALUcontrols = 5'b01101;
                end
                // bge
                3'b101:begin
                    ALUcontrols = 5'b01110;
                end
                // bltu
                3'b110:begin
                    ALUcontrols = 5'b01111;
                end
                // bgeu
                3'b111:begin
                    ALUcontrols = 5'b10000;
                end
                default:begin
                    
                end
            endcase
        end
        // L型指令
        7'b0000011:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 1;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b00000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b000;
            case (func3)
                // lw
                3'b010:begin
                    MemRead = 3'b001;
                end
                // lh
                3'b001:begin
                    MemRead = 3'b110;
                end
                // lb
                3'b000:begin
                    MemRead = 3'b111;
                end
                // lbu
                3'b100:begin
                    MemRead = 3'b011;
                end
                // lhu
                3'b101:begin
                    MemRead = 3'b010;
                end
                default: begin
                    
                end
            endcase
        end
        // S型指令
        7'b0100011:begin
            RegWrite = 0;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            ALUcontrols = 5'b00000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b010;
            case (func3)
                // sw
                3'b010:begin
                    MemWrite = 2'b01;
                end
                // sh
                3'b001:begin
                    MemWrite = 2'b10;
                end
                // sb
                3'b000:begin
                    MemWrite = 2'b11;
                end
                default: begin
                    
                end
            endcase
        end
        // I型指令
        7'b0010011:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            BranchNoCondition = 2'b00;

            ImmSrc = 3'b000;
            case (func3)
                // addi
                3'b000:begin
                    ALUcontrols = 5'b00000;
                end
                // slti
                3'b010:begin
                    ALUcontrols = 5'b00110;
                end
                // sltiu
                3'b011:begin
                    ALUcontrols = 5'b00111;
                end
                // xori
                3'b100:begin
                    ALUcontrols = 5'b00100;
                end
                // ori
                3'b110:begin
                    ALUcontrols = 5'b00011;
                end
                // andi
                3'b111:begin
                    ALUcontrols = 5'b00010;
                end
                // slli
                3'b001:begin
                    ALUcontrols = 5'b00101;
                end
                // srli, srai
                3'b101:begin
                    if(func7[5])begin
                        ImmSrc = 3'b101;
                        ALUcontrols = 5'b01001;
                    end
                    else ALUcontrols = 5'b01000;
                end
                default:begin
                    
                end
            endcase
        end
        // R型指令
        7'b0110011:begin
            RegWrite = 1;
            ALUResult_WB_MemRead_data = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b00;
            MemWrite = 2'b00;
            MemRead = 3'b000;
            BranchNoCondition = 2'b00;
            ImmSrc = 3'b111;
            case (func3)
                // sub, add
                3'b000:begin
                    if(func7[5])begin
                        ALUcontrols = 5'b00001;
                    end else begin
                        ALUcontrols = 5'b00000;
                    end
                end
                // or
                3'b110:begin
                    ALUcontrols = 5'b00011;
                end
                // and
                3'b111:begin
                    ALUcontrols = 5'b00010;
                end
                // xor
                3'b100:begin
                    ALUcontrols = 5'b00100;
                end
                // sll
                3'b001:begin
                    ALUcontrols = 5'b00101;
                end
                // slt
                3'b010:begin
                    ALUcontrols = 5'b00110;
                end
                // sltu
                3'b011:begin
                    ALUcontrols = 5'b00111;
                end
                // srl, sra
                3'b101:begin
                    if(func7[5]) ALUcontrols = 5'b01001;
                    else ALUcontrols = 5'b01000;
                end 
                default: begin
                    
                end
            endcase
        end
        default: begin
            
        end
    endcase
end

endmodule;