`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/12 1:36:37
// Design Name: 32bit Mips ALU TestBench
// Module Name: 32bit Mips ALU TestBench
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: Work Done
//////////////////////////////////////////////////////////////////////////////////


module ALUTest(

    );
    reg clk;
    reg reset_n;
    
    reg [2:0] ALUControl;
    reg [31:0] A;
    reg [31:0] B;
    
    wire [31:0] ALUOutput;
    wire is_Zero;
    wire is_Overflow;
    
    integer i;
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        reset_n = 1;
        A = 32'h00FF;
        B = 32'hFF00;
        for(i=0;i<=3'b111;i=i+1) begin
            ALUControl = i;
            @(posedge clk);
            $display("operand : %b %b", ALUControl, ALUOutput);
        end
        $finish;
    end
//////////////////////////////////////////////////////////////////////////////////
// ALU Controll Table
//ALUControl[2] |    00    |    01    |    10    |    11
//--------------|-----------------------------------------------------------------
//     0        |    and   |    or    |    add   |   not defined       
//     1        | not de  |  not de  |    sub   |    slt        
//////////////////////////////////////////////////////////////////////////////////
    ALU32bit#(
    ) u_ALU32bit(
        .ALUControl                 (ALUControl),
        .A                          (A),
        .B                          (B),
        
        .ALUOutput                  (ALUOutput),
        .is_Zero                    (is_Zero),
        .is_Overflow                (is_Overflow)
    );
endmodule
