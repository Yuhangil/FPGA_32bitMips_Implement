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
    
    reg is_done;
    
    MipsProcessor#(
    ) u_MipsProcessor(
        .clk                (clk),
        .reset_n            (reset_n),
        
        .is_done            (is_done)
    );
endmodule
