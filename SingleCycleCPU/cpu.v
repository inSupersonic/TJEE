`timescale 1ns / 1ps

module test_cpu();

    reg clk, reset;
    
    cpu cputest(clk, reset);
    
    initial begin
        clk = 1'b0;
        reset = 1'b0;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
    end

    always begin
        #1 clk = ~clk;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, test_cpu);
        #100 $finish;
    end
    
endmodule

module cpu(
    input clk, reset
);
    // Data
    wire [31: 0] Instr;               // Instruction
    wire [31: 0] RegWrite_data;       // Data written into rd
    wire [31: 0] RegRead_data1;       // Data read from rs1
    wire [31: 0] RegRead_data2;       // Data read from rs2
    wire [31: 0] ImmExtend;           // Immediate 32bits
    wire [31: 0] SrcA;                // ALU SrcA
    wire [31: 0] SrcB;                // ALU SrcB
    wire [31: 0] ALUResult;           // ALU Result
    wire [31: 0] MemRead_data;        // Data read from memory
    wire [31: 0] pc;                  // Instruction Addr
    wire [31: 0] next_pc;             // Instruction AddrNext 

    wire [4: 0] rd, rs1, rs2; 
    wire [6: 0] opcode;
    wire [2: 0] func3;
    wire [6: 0] func7;

    // Controller
    wire [4: 0] ALUcontrols;          // Ctrl
    wire ALUResult_WB_MemRead_data;   // 
    wire rs1Data_EX_PC;               // 
    wire [1: 0] rs2Data_EX_imm32_4;   // 
    wire RegWrite;                    // sel write back to reg
    wire [1: 0] MemWrite;             // sel write to memory
    wire [2: 0] MemRead;              // sel read from memory
    wire [2: 0] ImmSrc;               // choose immediate type
    wire [1: 0] BranchNoCondition;    // Jump
    wire BranchCondition;             // Branch

    pc PC(
        .reset(reset),
        .clk(clk),
        .next_pc(next_pc),

        .pc(pc)
    );

    next_pc NEXT_PC(
        .BranchNoCondition(BranchNoCondition),
        .BranchCondition(BranchCondition),
        .pc(pc),
        .offset(ImmExtend),
        .rs1Data(RegRead_data1),

        .next_pc(next_pc)
    );

    controller CONTROLLER(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),

        .ALUcontrols(ALUcontrols),
        .ALUResult_WB_MemRead_data(ALUResult_WB_MemRead_data),
        .rs1Data_EX_PC(rs1Data_EX_PC),
        .rs2Data_EX_imm32_4(rs2Data_EX_imm32_4),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ImmSrc(ImmSrc),
        .BranchNoCondition(BranchNoCondition)
    );

    imm IMM(
        .instr(Instr),
        .ImmSrc(ImmSrc),

        .ImmExtend(ImmExtend)
    );

    id ID(
        .instr(Instr),

        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );

    Instr_mem INSTRUCTION_MEM(
        .pc(pc),

        .Instr(Instr)
    );

    reg_file REG_FILE(
        .reset(reset),
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .target_reg(rd),
        .RegWrite_data(RegWrite_data),

        .RegRead_data1(RegRead_data1),
        .RegRead_data2(RegRead_data2)
    );

    mux_2 MUX_WB(
        .signal(ALUResult_WB_MemRead_data),
        .a(ALUResult),
        .b(MemRead_data),

        .out(RegWrite_data)
    );

    mux_3 MUX_EX_B(
        .signal(rs2Data_EX_imm32_4),
        .a(RegRead_data2),
        .b(ImmExtend),
        .c(32'd4),

        .out(SrcB)
    );

    mux_2 MUX_EX_A(
        .signal(rs1Data_EX_PC),
        .a(RegRead_data1),
        .b(pc),

        .out(SrcA)
    );

    alu ALU(
        .ALUcontrols(ALUcontrols),
        .a(SrcA),
        .b(SrcB),

        .out(ALUResult),
        .BranchCondition(BranchCondition)
    );

    data_mem DATA_MEM(
        .clk(clk),
        .reset(reset),
        .address(ALUResult),
        .write_data(RegRead_data2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),

        .MemRead_data(MemRead_data)
    );
endmodule