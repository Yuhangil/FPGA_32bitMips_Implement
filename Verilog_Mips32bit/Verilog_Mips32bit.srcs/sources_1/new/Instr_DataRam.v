`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/01 22:34:41
// Design Name: 
// Module Name: Instr_DataRam
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
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
