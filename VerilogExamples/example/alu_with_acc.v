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
