module controller(
    // 输入信号来自于解码阶段ID -- 由于指令数量变多用funct7代替f7b5
    input [6: 0] opcode,
    input [2: 0] func3,
    input [6: 0] func7,
    // 以下为控制信号
    output reg [4: 0] aluc,
    output reg aluOut_WB_memOut, rs1Data_EX_PC, 
    output reg [1: 0] rs2Data_EX_imm32_4,
    output reg write_reg, 
    output reg [1: 0] write_mem, 
    output reg [2: 0] read_mem,
    output reg [2: 0] extOP,
    output reg [1: 0] pcImm_NEXTPC_rs1Imm
);
    /*
    * 控制信号功能说明
    * ------------------------------------------------------------------------------------
    * | 信号名称               | 位宽  | 含义与作用                                         
    * ------------------------------------------------------------------------------------
    * | aluc                  | [4:0] | ALU操作码，控制ALU执行的算术和逻辑运算类型            
    * | aluOut_WB_memOut      | 1     | WB-   数据选择：0=ALUout，1=内存读取数据          
    * | rs1Data_EX_PC         | 1     | EX-rs1数据来源：0=regfile，1=PC-now
    * | rs2Data_EX_imm32_4    | [1:0] | EX-rs2数据来源： 00=regfile，01=immext，11=+4(jal)    
    * | write_reg             | 1     | 是否写regfile                    
    * | write_mem             | [1:0] | 内存写入控制:                                      
    * |                       |       |   00=no，01=word，10=half，11=byte          
    * | read_mem              | [2:0] | 内存读取控制:                             
    * |                       |       |   000-no，001-word，010-half(u)，011-byte(un) 
    * |                       |       |   110-half(signed)，111-byte(signed)    
    * | extOP                 | [2:0] | 立即数扩展方式:              
    * |                       |       |   000-I，001-U，010-S，011-B, 100-J        
    * |                       |       |   101-srai，111-R          
    * | pcImm_NEXTPC_rs1Imm   | [1:0] | PC来源：
    * |                       |       |   00=PC+4，01=pcImm(jal)，10=rs1Imm(JALR)       
    * ------------------------------------------------------------------------------------
    */
always @(*) begin
    case (opcode)
        // lui
        7'b0110111:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b00000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b001;
        end
        // auipc
        7'b0010111:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b01;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b00000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b001;
        end
        // jal
        7'b1101111:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b11;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b00000;
            pcImm_NEXTPC_rs1Imm = 2'b01;
            extOP = 3'b100;
        end
        // jalr
        7'b1100111:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 1;
            rs2Data_EX_imm32_4 = 2'b11;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b01010;
            pcImm_NEXTPC_rs1Imm = 2'b10;
            extOP = 3'b000;
        end
        // B型指令
        7'b1100011:begin
            write_reg = 0;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b00;
            write_mem = 2'b00;
            read_mem = 3'b000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b011;
            case (func3)
                // beq
                3'b000:begin
                    aluc = 5'b01011;
                end
                // bne
                3'b001:begin
                    aluc = 5'b01100;
                end
                // blt
                3'b100: begin
                    aluc = 5'b01101;
                end
                // bge
                3'b101:begin
                    aluc = 5'b01110;
                end
                // bltu
                3'b110:begin
                    aluc = 5'b01111;
                end
                // bgeu
                3'b111:begin
                    aluc = 5'b10000;
                end
                default:begin
                    
                end
            endcase
        end
        // L型指令
        7'b0000011:begin
            write_reg = 1;
            aluOut_WB_memOut = 1;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b00000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b000;
            case (func3)
                // lw
                3'b010:begin
                    read_mem = 3'b001;
                end
                // lh
                3'b001:begin
                    read_mem = 3'b110;
                end
                // lb
                3'b000:begin
                    read_mem = 3'b111;
                end
                // lbu
                3'b100:begin
                    read_mem = 3'b011;
                end
                // lhu
                3'b101:begin
                    read_mem = 3'b010;
                end
                default: begin
                    
                end
            endcase
        end
        // S型指令
        7'b0100011:begin
            write_reg = 0;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            write_mem = 2'b00;
            read_mem = 3'b000;
            aluc = 5'b00000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b010;
            case (func3)
                // sw
                3'b010:begin
                    write_mem = 2'b01;
                end
                // sh
                3'b001:begin
                    write_mem = 2'b10;
                end
                // sb
                3'b000:begin
                    write_mem = 2'b11;
                end
                default: begin
                    
                end
            endcase
        end
        // I型指令
        7'b0010011:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b01;
            write_mem = 2'b00;
            read_mem = 3'b000;
            pcImm_NEXTPC_rs1Imm = 2'b00;

            extOP = 3'b000;
            case (func3)
                // addi
                3'b000:begin
                    aluc = 5'b00000;
                end
                // slti
                3'b010:begin
                    aluc = 5'b00110;
                end
                // sltiu
                3'b011:begin
                    aluc = 5'b00111;
                end
                // xori
                3'b100:begin
                    aluc = 5'b00100;
                end
                // ori
                3'b110:begin
                    aluc = 5'b00011;
                end
                // andi
                3'b111:begin
                    aluc = 5'b00010;
                end
                // slli
                3'b001:begin
                    aluc = 5'b00101;
                end
                // srli, srai
                3'b101:begin
                    if(func7[5])begin
                        extOP = 3'b101;
                        aluc = 5'b01001;
                    end
                    else aluc = 5'b01000;
                end
                default:begin
                    
                end
            endcase
        end
        // R型指令
        7'b0110011:begin
            write_reg = 1;
            aluOut_WB_memOut = 0;
            rs1Data_EX_PC = 0;
            rs2Data_EX_imm32_4 = 2'b00;
            write_mem = 2'b00;
            read_mem = 3'b000;
            pcImm_NEXTPC_rs1Imm = 2'b00;
            extOP = 3'b111;
            case (func3)
                // sub, add
                3'b000:begin
                    if(func7[5])begin
                        aluc = 5'b00001;
                    end else begin
                        aluc = 5'b00000;
                    end
                end
                // or
                3'b110:begin
                    aluc = 5'b00011;
                end
                // and
                3'b111:begin
                    aluc = 5'b00010;
                end
                // xor
                3'b100:begin
                    aluc = 5'b00100;
                end
                // sll
                3'b001:begin
                    aluc = 5'b00101;
                end
                // slt
                3'b010:begin
                    aluc = 5'b00110;
                end
                // sltu
                3'b011:begin
                    aluc = 5'b00111;
                end
                // srl, sra
                3'b101:begin
                    if(func7[5]) aluc = 5'b01001;
                    else aluc = 5'b01000;
                end 
                default: begin
                    
                end
            endcase
        end
        default: begin
            
        end
    endcase
end
endmodule