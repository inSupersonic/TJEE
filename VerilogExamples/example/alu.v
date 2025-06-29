module alu (
    input  [7:0] opa,
    input  [7:0] opb,
    input  [3:0] opcode,
    input        cin,
    output reg [7:0] result,
    output reg       cout
);
    always @(*) begin
        // 默认值设置，防止综合时出现 latch
        result = 8'b0;
        cout   = 0;

        case (opcode)
            4'b0000: {cout, result} = opa + opb + cin; // 唯一需要设置 cout 的地方

            4'b0001: result = ~opa;
            4'b0010: result = opa | opb;
            4'b0011: result = opa & opb;
            4'b0100: result = {opa[6:0], 1'b0};   // SHL
            4'b0101: result = {1'b0, opa[7:1]};   // SHR
            4'b0110: result = {opa[6:0], opa[7]}; // ROL
            4'b0111: result = {opa[0], opa[7:1]}; // ROR
            4'b1001: cout = (opa > opb);          // CMP，只设置 cout，result 已初始化为 0

            default: begin
                result = 8'b0;
                cout   = 0;
            end
        endcase
    end
endmodule

module alu_with_acc (
    input clk,
    input reset,
    input [7:0] opb,
    input [3:0] opcode,
    input cin,
    output [7:0] result,
    output       cout
);

    reg [7:0] acc;
    wire [7:0] alu_result;

    alu u_alu (
        .opa(acc),
        .opb(opb),
        .opcode(opcode),
        .cin(cin),
        .result(alu_result),
        .cout(cout)   // ✅ 直接输出，无需中间变量
    );

    assign result = alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            acc <= 8'b0;
        else
            acc <= alu_result;
    end
endmodule
