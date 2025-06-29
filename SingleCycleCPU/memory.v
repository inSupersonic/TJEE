module data_mem(
    input clk, reset, 
    input [1: 0] MemWrite, 
    input [2: 0] MemRead,
    input [31: 0] address, write_data,

    output reg [31: 0] MemRead_data
);

reg [7: 0] data [127: 0];

always @(*) begin
    case (MemRead[1: 0])
        2'b00:begin
            MemRead_data = 32'b0;
        end
        2'b01:begin
            MemRead_data = {data[address + 3], data[address + 2], data[address + 1], data[address]};
        end
        2'b10:begin
            if(MemRead[2]) MemRead_data = {{16{data[address + 1][7]}}, data[address + 1], data[address]};
            else MemRead_data = {16'b0, data[address + 1], data[address]};
        end
        2'b11:begin
            if(MemRead[2]) MemRead_data = {{24{data[address][7]}}, data[address]};
            else MemRead_data = {24'b0, data[address]};
        end 
        default:begin
            MemRead_data = 32'b0;
        end
    endcase
end

always @(posedge clk) begin
    case (MemWrite)
        2'b01:begin
            data[address + 3] = write_data[31: 24];
            data[address + 2] = write_data[23: 16];
            data[address + 1] = write_data[15: 8];
            data[address] = write_data[7: 0];
        end
        2'b10:begin
            data[address + 1] = write_data[15: 8];
            data[address] = write_data[7: 0];
        end
        2'b11:begin
            data[address] = write_data[7: 0];
        end 
        default: begin
            
        end
    endcase
end
endmodule

module Instr_mem (
    input [31: 0] pc,

    output [31: 0] Instr
);
    reg [31: 0] inst_mem[63: 0];
    initial begin
        $readmemh("codes.txt", inst_mem);
    end
    assign Instr = inst_mem[pc >> 2];
endmodule