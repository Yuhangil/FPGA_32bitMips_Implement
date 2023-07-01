`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 
// Module Name: MainController
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


module MainController(
    input clk,

    input [5:0] iOpcode,
    
    input reset_n,
    
    output oMemtoReg,
    output oRegDst,
    output oIorD,
    output oPCSrc,
    output [1:0] oALUSrcB,
    output oALUSrcA,
    output oIRWrite,
    output oMemWrite,
    output OPCWrite,
    output oBranch,
    output oRegWrite,
    
    output [1:0] ALUOp   // To ALU Decoder
    );
    
    reg [3:0] c_state;
    reg [3:0] n_state;
    
    localparam S_Fetch = 4'b0000;
    localparam S_Decode = 4'b0001;
    localparam S_MemAdr = 4'b0010;
    localparam S_MemRead = 4'b0011;
    localparam S_MemWriteBack = 4'b0100;
    localparam S_MemWrite = 4'b0101;
    localparam S_Excute = 4'b0110;
    localparam S_ALUWriteBack = 4'b0111;
    localparam S_Branch = 4'b1000;
    localparam S_ADDIExcute = 4'b1001;
    localparam S_ADDIWriteBack = 4'b1010;
    localparam S_Jump = 4'b1011;
    
    wire is_Rtype;
    wire is_Memory;
    wire is_Branch;
    wire is_Immediate;
    wire is_Jump;
    wire is_Load_Mem;
    wire is_Store_Mem;
    
    always@(posedge clk or negedge reset_n) begin   // Switch to Next State
        if(!reset_n) begin
            c_state <= S_Fetch;
            n_state <= S_Fetch;
        end else begin
            c_state <= n_state;
        end
    end
    
    always@(*) begin    // FSM
        n_state = c_state;
        case(c_state)
            S_Fetch:
                n_state = S_Decode;
            S_Decode:
                if(is_Rtype) begin
                    n_state = S_Excute;
                end else if(is_Memory) begin
                    n_state = S_MemAdr;
                end else if(is_Branch) begin
                    n_state = S_Branch;
                end else if(is_Immediate) begin
                    n_state = S_ADDIExcute;
                end else if(is_Jump) begin
                    n_state = S_Jump;
                end
            S_MemAdr:
                if(is_Load_Mem) begin
                    n_state = S_MemRead;
                end else if(is_Store_Mem) begin
                    n_state = S_MemWrite;
                end
            S_MemRead:
                n_state = S_MemWriteBack;
            S_MemWriteBack:
                n_state = S_Fetch;
            S_MemWrite:
                n_state = S_Fetch;
            S_Excute:
                n_state = S_ALUWriteBack;
            S_ALUWriteBack:
                n_state = S_Fetch;
            S_Branch:
                n_state = S_Fetch;
            S_ADDIExcute:
                n_state = S_ADDIWriteBack;
            S_ADDIWriteBack:
                n_state = S_Fetch;
            S_Jump:
                n_state = S_Fetch;
        endcase
    end
    
    
endmodule
