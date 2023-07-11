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


module Instr_DataRam#(
    parameter DWIDTH = 32,
    parameter MEM_SIZE = 3840
)
(
    input clk,
    
    input WriteEnable,
    
    // Bran Interface 1
    input [31:0] iAddr,
    input [31:0] iWriteData,
    
    output reg [31:0] oReadData,
    // Bram Interface 2
    
    input WriteEnable2,
    
    input [31:0] iAddr2,
    input [31:0] iWriteData2,
    output reg [31:0] oReadData2
    
    );
    
    (* ram_style = "block"*) reg [DWIDTH-1:0] ram [0:MEM_SIZE-1];
    
    always@(posedge clk) begin
        if(WriteEnable) begin
            ram[iAddr] <= iWriteData;
        end else begin
            oReadData <= ram[iAddr];
        end
    end
    
    always@(posedge clk) begin
        if(WriteEnable2) begin
            ram[iAddr2] <= iWriteData2;
        end else begin
            oReadData2 <= ram[iAddr2];
        end
    end
    
endmodule
