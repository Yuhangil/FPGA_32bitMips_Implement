module RegisterFile(
    input clk,
    input reset_n,
    input WriteEnable,
    
    input [4:0] iRegAddrA,
    input [4:0] iRegAddrB,
    input [4:0] iRegAddrC,
    
    input [31:0] iWriteData,
    
    output [31:0] oReadDataA,
    output [31:0] oReadDataB
    );
endmodule