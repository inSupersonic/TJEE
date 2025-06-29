module pc(
    input reset, clk,
    input [31: 0] next_pc,
    output reg [31: 0] pc
);
    always @(posedge clk) begin
        if(reset) pc <= 32'h5c;
        else pc <= next_pc;
    end
endmodule

module next_pc(
    input [1: 0] BranchNoCondition,
    input BranchCondition,
    input [31: 0] pc, offset, rs1Data,

    output reg [31: 0] next_pc
);
    always @(*) begin
        if(BranchNoCondition == 2'b01) next_pc = pc + offset;
        else if(BranchNoCondition == 2'b10) next_pc = rs1Data + offset;
        else if(BranchCondition) next_pc = pc + offset;
        else if(pc == 32'h94) next_pc = 32'h94;
        else next_pc = pc + 4;
    end
endmodule