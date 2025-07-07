module alu(
    input [ 4: 0] aluc, // ALUcontrol从opcode解码得到五位
    input [31: 0] a, b,

    output reg [31: 0] out, // ALUResult
    output reg condition_branch // 分支条件B类型指令
);

    always @(*) begin
        condition_branch = 0;
        out = 32'b0;
        case (aluc)
            5'b00000: out = a + b;
            5'b00001: out = a - b;
            5'b00010: out = a & b;
            5'b00011: out = a | b;
            5'b00100: out = a ^ b;
            5'b00101: out = a << b;
            5'b00110: out = ($signed(a) < ($signed(b))) ? 32'b1 : 32'b0;
            5'b00111: out = (a < b) ? 32'b1 : 32'b0;
            5'b01000: out = a >> b;
            5'b01001: out = ($signed(a)) >>> b;
            5'b01010: begin 
                out = a + b;
                out[0] = 1'b0;
            end
            // B - type Instr
            5'b01011: condition_branch = (a == b) ? 1'b1 : 1'b0;
            5'b01100: condition_branch = (a != b) ? 1'b1 : 1'b0;
            5'b01101: condition_branch = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
            5'b01110: condition_branch = ($signed(a) >= $signed(b)) ? 1'b1 : 1'b0;
            5'b01111: condition_branch = (a < b) ? 1'b1: 1'b0;
            5'b10000: condition_branch = (a >= b) ? 1'b1: 1'b0;
            default: out = 32'b0;
        endcase
    end

endmodule

/*
 *                 ALU 操作码 (aluc) 与功能对照表
 * -----------------------------------------------------------------
 * | 指令类型         | aluc (5'b) | 操作                             
 * -----------------------------------------------------------------
 * | ADD             | 00000      | out = a + b                     
 * | SUB             | 00001      | out = a - b                      
 * | AND             | 00010      | out = a & b                      
 * | OR              | 00011      | out = a | b                      
 * | XOR             | 00100      | out = a ^ b                     
 * | SLL             | 00101      | out = a << b                     
 * | SLT (signed)    | 00110      | out = (a < b) ? 1 : 0 有符号比    
 * | SLTU (unsigned) | 00111      | out = (a < b) ? 1 : 0 (无符号比)  
 * | SRL             | 01000      | out = a >> b                    
 * | SRA             | 01001      | out = a >>> b (算术右移)          
 * | JALR_ALIGN      | 01010      | out = (a + b) & ~1 (地址对齐)     
 * | BEQ             | 01011      | condition_branch = (a == b)      
 * | BNE             | 01100      | condition_branch = (a != b)      
 * | BLT (signed)    | 01101      | condition_branch = (a < b)       
 * | BGE (signed)    | 01110      | condition_branch = (a >= b)      
 * | BLTU (unsigned) | 01111      | condition_branch = (a < b)       
 * | BGEU (unsigned) | 10000      | condition_branch = (a >= b)      
 * -----------------------------------------------------------------
 */