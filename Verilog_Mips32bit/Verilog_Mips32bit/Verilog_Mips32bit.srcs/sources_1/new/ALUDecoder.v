`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips ALUDecoder
// Module Name: ALUDecoder
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module ALUDecoder(
    input [5:0] iFunct,
    input [1:0] iALUOp,
    
    output [2:0] oALUControl
    );
    
    assign oALUControl = (iALUOp == 2'b00) ? (3'b010) : // 00 -> Add 010
                         (iALUOp[0] == 1'b1) ? (3'b110) : // x1 -> Sub 110
                         (iALUOp[1] == 1'b1) ?     // Look at Funct
                         ((iFunct == 6'b100000) ? (3'b010) : // add -> 010
                         (iFunct == 6'b100010) ? (3'b110) :  // sub -> 110
                         (iFunct == 6'b100100) ? (3'b000) :  // and -> 000
                         (iFunct == 6'b100101) ? (3'b001) :  // or -> 001
                         (iFunct == 6'b101010) ? (3'b111) :  // slt -> 111
                         (3'b010)) :  // default : add
                         (3'b010); // default
    // will add Immediate ALU Control
endmodule
