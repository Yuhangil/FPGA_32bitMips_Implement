`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/12 02:03:58
// Design Name: 
// Module Name: ControllerTest
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

// Work Done
module ControllerTest(

    );
    
    reg clk;
    reg reset_n;
    
    reg [5:0] iOpCode;
    reg [5:0] iFunct;
   
    wire oIorD;
    wire oMemWrite;
    wire oIRWrite;
    
    wire oPCWrite;
    wire oBranch;
    wire [1:0] oPCSrc;
    wire [2:0] oALUControl;
    wire [1:0] oALUSrcB;
    wire oALUSrcA;
    wire oRegWrite;
    wire oRegDst;
    wire oMemToReg;
    
    integer i;
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        reset_n = 1;
        iOpCode = 6'b000000;
        iFunct = 6'b100000; // Add 4 cycles
        #10
        reset_n = 0;
        #10
        
        reset_n = 1;
        $display("Add");
        for(i=0;i<4;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        $display("LW");
        iOpCode = 6'b100011;
        iFunct = 6'b000000; // LW 5cycles
        for(i=0;i<5;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        $display("SW");
        iOpCode = 6'b101011;
        iFunct = 6'b000000; // SW 4cycles
        for(i=0;i<4;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        $display("Branch");
        iOpCode = 6'b000100;
        iFunct = 6'b000000; // beq 3cycles
        for(i=0;i<3;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        
        $display("Addi");
        iOpCode = 6'b001000;
        iFunct = 6'b000000; // addi 4cycles
        for(i=0;i<4;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        
        $display("Jump");
        iOpCode = 6'b000010;
        iFunct = 6'b000000; // jump 3cycles
        for(i=0;i<3;i=i+1) begin
            @(posedge clk);
            $display("$time IorD: %b MemWrite: %b IRWrite: %b PCWrite: %b Branch: %b PCSrc: %b ALUControl: %b ALUSrcB: %b ALUSrcA: %b RegWrite: %b RegDst: %b MemToReg: %b", oIorD, oMemWrite, oIRWrite, oPCWrite, oBranch, oPCSrc, oALUControl, oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oMemToReg);
        end
        $finish;
    end
    
    ControlUnit#(
    ) u_ControlUnit(
        .clk                    (clk),
        .reset_n                (reset_n),
         // input
        .iOpCode                (iOpCode),
        .iFunct                 (iFunct),
         // output
        .oIorD                  (oIorD),
        .oMemWrite              (oMemWrite),
        .oIRWrite               (oIRWrite),
    
        .oPCWrite               (oPCWrite),
        .oBranch                (oBranch),
        .oPCSrc                 (oPCSrc),
        .oALUControl            (oALUControl),
        .oALUSrcB               (oALUSrcB),
        .oALUSrcA               (oALUSrcA),
        .oRegWrite              (oRegWrite),
        .oRegDst                (oRegDst),
        .oMemToReg              (oMemToReg)
    );
    
endmodule
