module top_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );

    // out_both：截取高99位与低99位进行按位与
    assign out_both = in[99:1] & in[98:0];  // [99&98, 98&97,...,1&0]

    // out_any：截取高99位与低99位进行按位或
    assign out_any = in[99:1] | in[98:0];   // [99|98, 98|97,...,1|0]

    // out_different：使用循环左移后的向量进行异或
    // { } 位拼接：将多个信号/位按顺序组合
    // 拼接结果	100 -- 新向量结构：[原最低位][原第99位][原第98位]...[原第1位]
    assign out_different = in[99:0] ^ {in[0],in[99:1]}; // 循环左移后异或

endmodule
