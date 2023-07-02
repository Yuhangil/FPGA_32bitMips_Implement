`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips Instruction_Data_Ram
// Module Name: MInstr_DataRam
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module Instr_DataRam(
    input clk,
    input reset_n,
    
    input WriteEnable,
    
    input [31:0] iAddr,
    input [31:0] iWriteData,
    
    output [31:0] oReadData
    
    );
endmodule
