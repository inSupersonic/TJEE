module instruction_mem (
    input  [31: 0] pc,
    output [31: 0] instruction
);
    reg [31: 0] inst_mem[63: 0];
    initial begin
       $readmemh("program.txt", inst_mem);
    end
    assign instruction = inst_mem[pc >> 2];
endmodule;