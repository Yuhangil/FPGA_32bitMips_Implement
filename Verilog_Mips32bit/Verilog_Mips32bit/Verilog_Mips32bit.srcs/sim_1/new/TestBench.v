`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 07:05:58
// Design Name: 
// Module Name: TestBench
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


module TestBench(

    );
    reg clk;
    reg reset_n;
    
    reg Mips_Run;
    
    reg [31:0] InstrCount;
    
    reg Instruction_Write_Enable;
    reg [31:0] Instruction_Data;
    reg [31:0] Instruction_Set [0:4];
    wire is_done;
    wire Instruction_Write_Done;    
    
    integer i;
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        Instruction_Set[0] = 32'h2008001F; 
        Instruction_Set[1] = 32'h200907C0; 
        Instruction_Set[2] = 32'h1095020;
        Instruction_Set[3] = 32'h1095822;
        Instruction_Set[4] = 32'h1096024;
        clk = 0;
        reset_n = 1;
        InstrCount = 5;
        Instruction_Write_Enable = 0;
        Mips_Run = 0;
        reset_n = 0;
        # 10
        reset_n = 1;
        Instruction_Write_Enable = 1;
        for(i=0;i<5;i=i+1) begin
            Instruction_Data = Instruction_Set[i];
            @(posedge clk);
        end
        Instruction_Write_Enable = 0;
        @(posedge clk);
        Mips_Run = 1;
        wait(is_done);
        $finish;
    end
    
    MipsProcessor#(
    ) u_MipsProcessor(
        .clk                            (clk),
        .reset_n                        (reset_n),
        .instrCount                     (InstrCount),
        
        .Mips_Run                       (Mips_Run),
        
        .Instruction_Write_Enable       (Instruction_Write_Enable),
        .Instruction_Data               (Instruction_Data),
    
        .Instruction_Write_Done         (Instruction_Write_Done),
        .is_done                        (is_done)
    );
endmodule
