module reg_file(
    input reset, clk, RegWrite,
    input [4: 0] rs1, rs2, target_reg,
    input [31: 0] RegWrite_data,

    output reg [31: 0] RegRead_data1,
    output reg [31: 0] RegRead_data2
);

    reg [31: 0] regs[31: 0];

    always @(posedge clk) begin
        if(RegWrite && target_reg != 5'h0) regs[target_reg] = RegWrite_data;
    end

    initial begin
        regs[5'd2] = 32'd128;
    end

    always @(*) begin
        if(rs1 == 5'h0)begin
            RegRead_data1 = 32'h0000_0000;
        end else begin
            RegRead_data1 = regs[rs1];
        end
    end

    always @(*) begin
        if(rs2 == 5'h0)begin
            RegRead_data2 = 32'h0000_0000;
        end else begin
            RegRead_data2 = regs[rs2];
        end
    end

endmodule