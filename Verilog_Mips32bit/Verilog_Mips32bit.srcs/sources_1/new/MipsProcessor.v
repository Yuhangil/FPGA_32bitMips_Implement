`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips Topmodule MipsProcessor
// Module Name: MipsProcessor
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module MipsProcessor(
    input clk,
    input reset_n,
    input [31:0] instrCount,
    
    output is_done
    );
    
    reg [31:0] PC;  // Program Counter
    wire [31:0] n_PC;
    // Control Unit Interface Signals
    // Register Enables
    wire PCWrite;   // PCWrite Signal
    wire PCEnable;  // PC Register Enable
    wire IRWrite;   // Instruction Write
    wire Branch;    // Branch
    wire MemWrite;  // Memory Write Enable
    
    // Multiplexer Signals
    
    wire IorD;  // Instruction or Data
    wire MemToReg;
    wire RegisterWriteEnable;
    wire RegisterDestination;   // Write Register Address Mux Select
    // Control Unit Interface Signal End
    
    // Memory Interface Signals
    wire [31:0] InstructionAddress = (IorD) ? ALUOutput : PC;
    
    wire [31:0] Instruction = MemData;        // Instruction PipeLine
    reg [31:0] InstructionRegister;
    
    wire [31:0] MemData;
    reg [31:0] MemDataRegister;    // MemData PipeLine
    // Memory Interface End
    
    // ALU Interface Signals
    wire [31:0] ALUOutput;
    wire ALUSrcASelect;
    wire [1:0] ALUSrcBSelect;
    reg [31:0] ALUOutputRegister;
    wire [31:0] ALUSrcA = (ALUSrcASelect)? (RegisterReadDataARegister) : (PC);  // 2x1 Mux
    wire [31:0] ALUSrcB = (ALUSrcBSelect == 2'b11)? ({{16{InstructionRegister[15]}}, InstructionRegister[15:0]} << 32'h2) : (ALUSrcBSelect == 2'b10) ? ({{16{InstructionRegister[15]}}, InstructionRegister[15:0]}) : (ALUSrcBSelect == 2'b01) ? (32'h4) :( RegisterReadDataBRegister);
    wire [2:0] ALUControl;
    wire is_Zero;
    wire is_Overflow;
    // ALU Interface End
    
    // Register File Interface Signals
    wire [31:0] RegisterReadDataA;
    wire [31:0] RegisterReadDataB;
    
    reg [31:0] RegisterReadDataARegister;
    reg [31:0] RegisterReadDataBRegister;
    
    wire [4:0] Write_Register_Address = (RegisterDestination) ? (InstructionRegister[15:11]) : (InstructionRegister[20:16]);        // 2x1 Mux
    wire [31:0] Write_Register_Data = (MemToReg)? (MemDataRegister) : (ALUOutput);
    // Reigster File Interface End
    

    

    
    assign n_PC = (PCSrc) ? (ALUOutputRegister): (ALUOutput);
    assign PCEnable = PCWrite | (Branch & is_Zero);
    
    // PC Update
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            PC <= 32'h0;
        end else if(PCEnable) begin
            PC <= n_PC;
        end
    end
    
    // Memory Instruction Update
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            InstructionRegister <= 32'h0;
        end else if(IRWrite) begin
            InstructionRegister <= Instruction;
        end
    end
    
    // Memory Data Update
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            MemDataRegister <= 32'h0;
        end else begin
            MemDataRegister <= MemData;
        end
    end
    
    // Register File Update
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            RegisterReadDataARegister <= 32'h0;
            RegisterReadDataBRegister <= 32'h0;
        end else begin
            RegisterReadDataARegister <= RegisterReadDataA;
            RegisterReadDataBRegister <= RegisterReadDataB;
        end
    end
    
    // ALUOutput Update
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            ALUOutputRegister <= 32'h0;
        end else begin
            ALUOutputRegister <= ALUOutput;
        end
    end
    
    assign is_done = (PC == instrCount);
    
    // Control Unit
    ControlUnit#(
    ) u_ControlUnit
    (
        .clk                    (clk),
        .reset_n                (reset_n),
    
        .iOpCode                (InstructionRegister[31:26]),
        .iFunct                 (InstructionRegister[5:0]),
   
        .oIorD                  (IorD),
        .oMemWrite              (MemWrite),
        .oIRWrite               (IRWrite),
    
        .oPCWrite               (PCWrite),
        .oBranch                (Branch),
        .oPCSrc                 (PCSrc),
        .oALUControl            (ALUControl),
        .oALUSrcB               (ALUSrcBSelect),
        .oALUSrcA               (ALUSrcASelect),
        .oRegWrite              (RegisterWriteEnable),
        .oRegDst                (RegisterDestination),
        .oMemToReg              (MemToReg)
    );
    
    // 32bit ALU
    ALU32bit#(
    ) u_ALU32bit(
        .ALUControl             (ALUControl),
        .A                      (ALUSrcA),
        .B                      (ALUSrcB),
    
        .ALUOutput              (ALUOutput),
        .is_Zero                (is_Zero),
        .is_Overflow            (is_Overflow)
    );
    
    Instr_DataRam#(
    ) u_Instr_DataRam(
        .clk                    (clk),
    
        .WriteEnable            (MemWrite),
    
        .iAddr                  (InstructionAddress),
        .iWriteData             (RegisterReadDataBRegister),
    
        .oReadData              (MemData)
    );
    
    
    // Register File
    RegisterFile#(
    ) u_RegisterFile(
        .clk                    (clk),
        .reset_n                (reset_n),
        .WriteEnable            (RegisterWriteEnable),
    
        .iRegAddrA              (InstructionRegister[25:21]),
        .iRegAddrB              (InstructionRegister[20:16]),
        .iRegAddrC              (Write_Register_Address),
    
        .iWriteData             (Write_Register_Data),
    
        .oReadDataA             (RegisterReadDataA),
        .oReadDataB             (RegisterReadDataB)
    );
    
    
endmodule