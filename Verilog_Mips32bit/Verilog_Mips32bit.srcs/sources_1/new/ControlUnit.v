`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips Control Unit
// Module Name: Control Unit
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit(
    input clk,
    input reset_n,
    
    input [5:0] iOpCode,
    input [5:0] iFunct,
   
    output oIorD,
    output oMemWrite,
    output oIRWrite,
    
    output oPCWrite,
    output oBranch,
    output oPCSrc,
    output [2:0] oALUControl,
    output [1:0] oALUSrcB,
    output oALUSrcA,
    output oRegWrite,
    output oRegDst,
    output oMemToReg
    
    );
endmodule