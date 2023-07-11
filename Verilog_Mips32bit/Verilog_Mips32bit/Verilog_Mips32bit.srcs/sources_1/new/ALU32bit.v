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
    output is_Overflow
    );
    wire [31:0] RealB = (ALUControl[2])? (~B+32'h1) : B;
    wire [31:0] AdderOutput;
    wire [31:0] Cout;
    genvar i;
    generate
        for (i=0;i<32;i=i+1) begin : gen_adder
            if(i == 0) begin
                assign Cout[i] = RealB[i] & A[i];
                assign AdderOutput[i] = RealB[i] ^ A[i];
            end else begin
                assign Cout[i] = ( RealB[i] & A[i] ) | (RealB[i] & Cout[i-1]) | (A[i] & Cout[i-1]);
                assign AdderOutput[i] = RealB[i] ^ A[i] ^ Cout[i-1];
            end
        end
    endgenerate
    assign is_Overflow = Cout[31];
    
    assign is_Zero = (ALUOutput == 32'h0);
    assign ALUOutput = (ALUControl[1]) ? ((ALUControl[0])? ({31'h0, AdderOutput[31]}) : (AdderOutput)) : ((ALUControl[0])? (A | RealB) : (A & RealB));    // SLT, Add or Sub, Or, AND
    
endmodule
