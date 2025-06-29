module full_adder_2bit (
    input wire cin,        // Carry-in (SW0)
    input wire a0, a1,     // First 2-bit input (a0=SW2, a1=SW3)
    input wire b0, b1,     // Second 2-bit input (b0=SW6, b1=SW7)
    output wire sum0, sum1,// 2-bit sum output (sum0=LED0, sum1=LED1)
    output wire cout       // Carry-out (LED3)
);
    // Internal carry signal
    wire carry_intermediate;

    // First 1-bit full adder (low bit)
    assign {carry_intermediate, sum0} = a0 + b0 + cin;

    // Second 1-bit full adder (high bit)
    assign {cout, sum1} = a1 + b1 + carry_intermediate;

endmodule