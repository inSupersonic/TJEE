// 非门
module not_gate(input a, output y);
  assign y = ~a;
endmodule

// 与门
module and_gate(input a, b, output y);
  assign y = a & b;
endmodule

// 或门
module or_gate(input a, b, output y);
  assign y = a | b;
endmodule

// 顶层模块
module gates_top(
  input [1:0] sel,
  input a, b,
  output reg y
);
  wire and_out, or_out, not_out;
  
  and_gate u_and(a, b, and_out);
  or_gate  u_or(a, b, or_out);
  not_gate u_not(a, not_out);
  
  always @(*) begin
    case(sel)
      2'b00: y = and_out;
      2'b01: y = or_out;
      2'b10: y = not_out;
      default: y = 0;
    endcase
  end
endmodule