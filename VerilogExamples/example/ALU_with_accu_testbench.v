`timescale 1ns / 1ps
module testbench;
    reg clk;
    reg reset;     
    reg [7:0] opa;
    reg [7:0] opb; 
    reg [3:0] opcode;
    reg cin;
    
    wire [7:0] acc_out;
    wire cout; 

    top_module uut (
        .clk(clk),
        .reset(reset),
        .opa(opa),
        .opb(opb),
        .opcode(opcode),
        .cin(cin),
        .acc_out(acc_out),
        .cout(cout)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5 ns
    end

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, testbench);

        // Step 1: Reset the accumulator
        // 将 reset 信号置为 1，持续 10 ns，以异步复位累加器
        // 使其输出 acc_out 初始化为 8'h00。
        // 同时，将输入信号设置为 8'h00
        // cin（进位输入）设置为 0
        reset = 1;
        opa = 8'h00;
        opb = 8'h00;
        opcode = 4'b0000;
        cin = 0;
        #10;
        reset = 0;

        // Step 2: ADD 8'h05 + 8'h23
        opa = 8'h05;
        opb = 8'h23;
        opcode = 4'b0000;
        cin = 0;
        #10;

        // Step 3: AND with 8'h56
        opa = acc_out;
        opb = 8'h56;
        opcode = 4'b0011;
        #10;

        // Step 4: ROL on the result
        opa = acc_out;
        opb = 8'h00;
        opcode = 4'b0110;
        #10;

        // Step 5: ADD 8'hA0
        opa = acc_out;
        opb = 8'hA0;
        opcode = 4'b0000;
        cin = 0;
        #10;
        $display("Accumulator value: %h", acc_out);
        #20;
        $finish;
    end
endmodule