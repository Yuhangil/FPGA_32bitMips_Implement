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

module RegisterFile#(
    parameter DWIDTH = 32,
    parameter AWIDTH = 5,
    parameter NumOfReg = 32
)
(
    input clk,
    input reset_n,
    input WriteEnable,
    
    input [AWIDTH-1:0] iRegAddrA,
    input [AWIDTH-1:0] iRegAddrB,
    input [AWIDTH-1:0] iRegAddrC,
    
    input [DWIDTH-1:0] iWriteData,
    
    output reg [DWIDTH-1:0] oReadDataA,
    output reg [DWIDTH-1:0] oReadDataB
    );
    
    reg [DWIDTH-1:0] Registers [0:NumOfReg-1];    // Zero, At, V0-1, A0-3, t0-7, s0-7, t8-9, k0-k1, GP, SP, S8, RA
    integer i;
    always@(posedge clk or negedge reset_n) begin  // Reset Signal
        if(!reset_n) begin
            for(i=0;i<32;i=i+1) begin
                Registers[i] = 32'h0;
            end
        end else begin
            if(WriteEnable) begin // Address 0 is Zero Register
                Registers[iRegAddrC] <= iWriteData;
            end
        end
    end

    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            oReadDataA <= 32'h0;
            oReadDataB <= 32'h0;
        end else begin
            oReadDataA <= Registers[iRegAddrA];
            oReadDataB <= Registers[iRegAddrB];
        end
    end
    
endmodule