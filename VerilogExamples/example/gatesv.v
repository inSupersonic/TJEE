module top_module( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );

    // out_both：检查当前位与左边高位是否同时为1
    assign out_both[2] = in[3] & in[2];  // 最高两位比较
    assign out_both[1] = in[2] & in[1];
    assign out_both[0] = in[1] & in[0];

    // out_any：检查当前位与右边低位是否有至少1个1
    assign out_any[3] = in[3] | in[2];   // 最高两位比较
    assign out_any[2] = in[2] | in[1];
    assign out_any[1] = in[1] | in[0];

    // out_different：循环比较当前位与左边高位
    assign out_different[3] = in[3] ^ in[0];  // 最高位与最低位比较（循环）
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule