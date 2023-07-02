`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Hanyang Univercity
// Engineer: Hangil Yu
// 
// Create Date: 2023/07/01 21:44:37
// Design Name: 32bit Mips MainController
// Module Name: MainController
// Project Name: 32Bit Multicycle Mips Implementation
// Target Devices: Zybo Z7-20
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module MainController(
    input clk,

    input [5:0] iOpcode,
    
    input reset_n,
    // Multiplexer Selects
    output oMemtoReg,
    output oRegDst,
    output oIorD,
    output oPCSrc,
    output [1:0] oALUSrcB,
    output oALUSrcA,
    // Register Enables
    output oIRWrite,
    output oMemWrite,
    output oPCWrite,
    output oBranch,
    output oRegWrite,
    
    output [1:0] oALUOp   // To ALU Decoder
    );
    
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
    
    reg [3:0] c_state;
    reg [3:0] n_state;
    reg [5:0] Opcode_Capture;
    

    
    wire is_Rtype = (Opcode_Capture == 6'b000000);  // Rtype = ADD, ADDU, AND, NOR, OR, SLT, SLTU, SUB, SUBU, XOR, SLL, SLLV, SRA, SRAV, SRL, SRLV, DIV, DIVU, MFHI, MFLO, MTHI, MTLO, MULT, MULTU
    wire is_Branch = (Opcode_Capture ==  6'b000100);    // BEQ
    wire is_Immediate = (Opcode_Capture ==  6'b001000 | Opcode_Capture ==  6'b001001);  // ADDI, ADDIU
    wire is_Jump = (Opcode_Capture ==  6'b000010); // J target
    wire is_Load_Mem = (Opcode_Capture ==  6'b100000 | Opcode_Capture ==  6'b100100 | Opcode_Capture ==  6'b100001 | Opcode_Capture ==  6'b100101 | Opcode_Capture ==  6'b100011);  // LB, LBU, LH, LHU, LW
    wire is_Store_Mem = (Opcode_Capture ==  6'b101000 | Opcode_Capture ==  6'b101001 | Opcode_Capture ==  6'b101011);   // SB, SH, SW
    
    wire is_Memory = is_Load_Mem | is_Store_Mem;    // Load or Store
    
    assign oMemtoReg = (c_state == S_MemWriteBack); // Multiplexer Selects
    assign oRegDst = (c_state == S_ALUWriteBack);
    assign oIorD = (c_state == S_MemRead | c_state == S_MemWrite);
    assign oPCSrc = {(c_state == S_Jump), (c_state == S_Branch)};
    assign oALUSrcB = {(c_state == S_Decode | c_state == S_MemAdr | c_state == S_ADDIExcute), (c_state == S_Decode | c_state == S_Branch)};
    assign oALUSrcA = (c_state == S_MemAdr | c_state == S_Excute | c_state == S_Branch | c_state == S_ADDIExcute);
    
    assign oALUOp = {(c_state == S_Excute), (c_state == S_Branch)}; // To ALU
    
    assign oIRWrite = (c_state == S_MemRead | c_state == S_MemWrite);   // to Register Enables
    assign oMemWrite = (c_state == S_MemWrite);
    assign oPCWrite = (c_state == S_Jump);
    assign oBranch = (c_state == S_Branch);
    assign oRegWrite = (c_state == S_MemWriteBack | c_state == S_ALUWriteBack | c_state == S_ADDIWriteBack);
    
    always@(posedge clk or negedge reset_n) begin   // Switch to Next State
        if(!reset_n) begin
            c_state <= S_Fetch;
        end else begin
            c_state <= n_state;
        end
    end
    
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            Opcode_Capture <= 6'b000000;
        end else if(c_state == S_Fetch) begin   // Fetch Instruction
            Opcode_Capture <= iOpcode;
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
            default:
                n_state = S_Fetch;
        endcase
    end
    
    
endmodule
