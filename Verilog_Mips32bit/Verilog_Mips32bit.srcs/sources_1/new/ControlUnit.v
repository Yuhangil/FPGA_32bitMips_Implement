module ControlUnit(
    input clk,
    input reset_n,
    
    input [5:0] iOpCode,
    input [5:0] iFunct,
   
    output oIorD,
    output oMemWrite,
    output oIRWrite,
    
    output oPCWrite,
    output oBranch,
    output oPCSrc,
    output [2:0] oALUControl,
    output [1:0] oALUSrcB,
    output oALUSrcA,
    output oRegWrite,
    output oRegDst,
    output oMemToReg
    
    );
endmodule