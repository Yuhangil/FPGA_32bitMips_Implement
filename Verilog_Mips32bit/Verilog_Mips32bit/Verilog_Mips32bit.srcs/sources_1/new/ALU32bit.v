`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips ALU
// Module Name: 32bit Mips ALU
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// ALU Controll Table
//ALUControl[2] |    00    |    01    |    10    |    11
//--------------|-----------------------------------------------------------------
//     0        |    and   |    or    |    add   |   not defined       
//     1        | not de  |  not de  |    sub   |    slt        
//////////////////////////////////////////////////////////////////////////////////


module ALU32bit(
    input [2:0] ALUControl,
    input [31:0] A,
    input [31:0] B,
    
    output [31:0] ALUOutput,
    output is_Zero,
    output Cout
    );
    wire [31:0] RealB = (ALUControl[2])? -B : B;
    wire [31:0] AdderOutput = A + RealB;
    
    // wire Cout = ... add Calculate Carry
    
    
    assign is_Zero = (ALUOutput == 32'h0);
    assign ALUOutput = (ALUControl[1]) ? ((ALUControl[0])? ({0, AdderOutput[30:0]}) : (AdderOutput)) : ((ALUControl[0])? (A | RealB) : (A & RealB));    //
    
endmodule
