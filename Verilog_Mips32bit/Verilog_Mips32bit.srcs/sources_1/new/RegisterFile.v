`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips RegisterFile
// Module Name: RegisterFile
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module RegisterFile(
    input clk,
    input reset_n,
    input WriteEnable,
    
    input [4:0] iRegAddrA,
    input [4:0] iRegAddrB,
    input [4:0] iRegAddrC,
    
    input [31:0] iWriteData,
    
    output reg [31:0] oReadDataA,
    output reg [31:0] oReadDataB
    );
    
    reg [31:0] Registers [0:31];    // Zero, At, V0-1, A0-3, t0-7, s0-7, t8-9, k0-k1, GP, SP, S8, RA
    integer i;
    always@(negedge reset_n) begin  // Reset Signal
        if(!reset_n) begin
            for(i=0;i<32;i=i+1) begin
                Registers[i] = 32'h0;
            end
        end else begin
            if(WriteEnable) begin
                Registers[iRegAddrC] <= iWriteData;
            end
        end
    end

    always@(posedge clk) begin
        oReadDataA <= Registers[iRegAddrA];
        oReadDataB <= Registers[iRegAddrB];
    end
    
endmodule