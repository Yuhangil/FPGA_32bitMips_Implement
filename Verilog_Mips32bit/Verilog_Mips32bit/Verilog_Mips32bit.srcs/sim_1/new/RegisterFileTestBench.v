`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/12 01:37:46
// Design Name: 
// Module Name: RegisterFileTestBench
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

// Well Work
module RegisterFileTestBench(

    );
    reg clk;
    reg reset_n;
    
    reg WriteEnable;
    reg [4:0] iRegAddrA;
    reg [4:0] iRegAddrB;
    reg [4:0] iRegAddrC;
    
    reg [31:0] iWriteData;
    wire [31:0] oReadDataA;
    wire [31:0] oReadDataB;
    
    integer i;
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        reset_n = 1;
        WriteEnable = 0;
        iRegAddrA = 5'h0;
        iRegAddrB = 5'h0;
        iRegAddrC = 5'h0;
        iWriteData = 32'h1;
        #10
        reset_n = 0;
        #10
        reset_n = 1;
        iRegAddrA = 5'd14;
        iRegAddrB = 5'd15;
        iRegAddrC = 5'd14;
        iWriteData = 32'h00FF;
        @(posedge clk);
        $display("A: %d B: %d\n", oReadDataA, oReadDataB);
        WriteEnable = 1;
        @(posedge clk);
        $display("A: %d B: %d\n", oReadDataA, oReadDataB);
        iRegAddrC = 5'd15;
        iWriteData = 32'hFF00;
        @(posedge clk);
        $display("A: %d B: %d\n", oReadDataA, oReadDataB);
        @(posedge clk);
        $display("A: %d B: %d\n", oReadDataA, oReadDataB);
        @(posedge clk);
        $finish;
    end
    RegisterFile#(
        .DWIDTH                     (32),
        .AWIDTH                     (5),
        .NumOfReg                   (32)
    ) u_RegisterFile(
        .clk                        (clk),
        .reset_n                    (reset_n),
        .WriteEnable                (WriteEnable),
    
        .iRegAddrA                  (iRegAddrA),
        .iRegAddrB                  (iRegAddrB),
        .iRegAddrC                  (iRegAddrC),
    
        .iWriteData                 (iWriteData),
    
        .oReadDataA                 (oReadDataA),
        .oReadDataB                 (oReadDataB)
    );
endmodule
