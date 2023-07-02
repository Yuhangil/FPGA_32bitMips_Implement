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
    input reset_n
    );
    
    reg [31:0] PC;  // Program Counter
    wire [31:0] n_PC;
    
    wire PCwrite;
    wire PCEnable;
    
    wire Branch;
    
    wire is_ALU_Zero;
    
    wire IorD;  // Instruction or Data
    wire MemWrite;
    
    assign PCEnable = PCWrite | (Branch & is_ALU_Zero);
    
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            PC <= 32'h0;
        end else if(PCEnable) begin
            PC <= n_PC;
        end
    end
    
    wire [31:0] Instruction;        // Instruction PipeLine
    reg [31:0] InstructionRegister;
    
    wire IRWrite;
    
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            InstructionRegister <= 32'h0;
        end else if(IRWrite) begin
            InstructionRegister <= Instruction;
        end
    end
    
    wire [31:0] Data;
    reg [31:0] DataRegister;    // Data PipeLine
    
        always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            DataRegister <= 32'h0;
        end else begin
            DataRegister <= Data;
        end
    end
    
    ControlUnit#(
    ) u_ControlUnit
    (
        .clk            (clk),
        .reset_n        (reset_n),
    
        .iOpCode        (InstructionRegister[31:26]),
        .iFunct         (InstructionRegister[5:0]),
   
        .oIorD          (IorD),
        .oMemWrite      (),
        .oIRWrite       (),
    
        .oPCWrite       (),
        .oBranch        (),
        .oPCSrc         (),
        .oALUControl    (),
        .oALUSrcB       (),
        .oALUSrcA       (),
        .oRegWrite      (),
        .oRegDst        (),
        .oMemToReg      ()
    );
    
endmodule