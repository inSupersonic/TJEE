module alu(
    input [4:0] ALUcontrols,
    input [31:0] a, b,

    output reg [31: 0] out, 
    output reg BranchCondition
);

always @(*) begin
    BranchCondition = 0;
    out = 32'b0;
    case (ALUcontrols)
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
        5'b01011: BranchCondition = (a == b) ? 1'b1 : 1'b0;
        5'b01100: BranchCondition = (a != b) ? 1'b1 : 1'b0;
        5'b01101: BranchCondition = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
        5'b01110: BranchCondition = ($signed(a) >= $signed(b)) ? 1'b1 : 1'b0;
        5'b01111: BranchCondition = (a < b) ? 1'b1: 1'b0;
        5'b10000: BranchCondition = (a >= b) ? 1'b1: 1'b0;
        default: out = 32'b0;
    endcase
end

endmodule

module imm(
    input [31: 0] instr,
    input [2: 0] ImmSrc,

    output reg [31: 0] ImmExtend
);

always @(*) begin
    case (ImmSrc)
        3'b000:begin
            ImmExtend = {{20{instr[31]}}, instr[31:20]};
        end
        3'b001:begin
            ImmExtend = {instr[31:12], 12'b0};
        end
        3'b010:begin
            ImmExtend = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end
        3'b011:begin
            ImmExtend = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        end
        3'b100:begin
            ImmExtend = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        3'b101:begin
            ImmExtend = {{20{instr[31]}}, instr[31:20]};
            ImmExtend[10] = 0;
        end
        3'b111:begin
            ImmExtend = 32'b0;
        end 
        default:begin
            
        end 
    endcase
end
endmodule;