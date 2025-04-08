`include "Mux2x1.v"
`include "PC.v"
`include "Add.v"
`include "ImmGen.v"
`include "RegisterFile.v"
`include "BranchComp.v"
`include "ALU.v"
`include "Mux3x1.v"

module Data_Path #(parameter DATA_WIDTH = 32) (
    input   wire                          clk,
    input   wire                          rst_n,
    input   wire                          PCSel,
    input   wire     [2:0]                ImmSel, 
    input   wire                          RegWEn,
    input   wire                          BrUn,
    input   wire                          BSel,
    input   wire                          ASel,
    input   wire     [3:0]                ALUSel,
    input   wire                          MemRW,
    input   wire     [1:0]                WBSel,
    input   wire     [31:0]               Instr,
    input   wire     [DATA_WIDTH-1:0]     Mem,
    output  wire     [DATA_WIDTH-1:0]     PC_Next,
    output  wire     [DATA_WIDTH-1:0]     ALU_Result,
    output  wire     [DATA_WIDTH-1:0]     Rs2,
    output  wire                          BrEq,
    output  wire                          BrLT
    );


// Internal Wires

wire [DATA_WIDTH-1:0] PC_Plus_4;

wire [DATA_WIDTH-1:0] PC_Mux2x1_Out;

wire [DATA_WIDTH-1:0] Imm;

wire [DATA_WIDTH-1:0] Write_Back_Mux3x1;

wire [DATA_WIDTH-1:0] Rs1;

wire [DATA_WIDTH-1:0] Rs1_ALU;
wire [DATA_WIDTH-1:0] Rs2_ALU;




///********************************************************///
////////////////////////// PC Mux ////////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_PC_Mux (
    .Sel(PCSel),
    .In0(PC_Plus_4),
    .In1(ALU_Result),
    .Out(PC_Mux2x1_Out)
);

///********************************************************///
//////////////////////// PC Register /////////////////////////
///********************************************************///

PC #(.DATA_WIDTH(DATA_WIDTH)) U0_PC (
    .clk(clk),
    .rst_n(rst_n),
    .PC_In(PC_Mux2x1_Out),
    .PC_Out(PC_Next)
);

///********************************************************///
///////////////////////// Adder for PC ///////////////////////
///********************************************************///

Add #(.DATA_WIDTH(DATA_WIDTH)) U0_Add (
    .PC(PC_Next),
    .PC_Plus_4(PC_Plus_4)
);

///********************************************************///
/////////////////////// Immediate Generator //////////////////
///********************************************************///

ImmGen U0_ImmGen (
    .Instr(Instr[31:7]),
    .ImmSel(ImmSel),
    .Imm(Imm)
);

///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

RegisterFile #(.DATA_WIDTH(DATA_WIDTH)) U0_Register_File (
    .clk(clk),
    .DataD(Write_Back_Mux3x1),
    .AddrD(Instr[11:7]),
    .AddrA(Instr[19:15]),
    .AddrB(Instr[24:20]),
    .RegWEn(RegWEn),
    .DataA(Rs1),
    .DataB(Rs2)
);

///********************************************************///
////////////////////// Branch Comparator /////////////////////
///********************************************************///

BranchComp #(.DATA_WIDTH(DATA_WIDTH)) U0_BranchComp (
    .DataA(Rs1),
    .DataB(Rs2),
    .BrUn(BrUn),
    .BrEq(BrEq),
	.BrLT(BrLT)
);

///********************************************************///
////////////////////////// Rs1 Mux ///////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_Rs1_Mux (
    .Sel(ASel),
    .In0(Rs1),
    .In1(PC_Next),
    .Out(Rs1_ALU)
);

///********************************************************///
////////////////////////// Rs2 Mux ///////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_Rs2_Mux (
    .Sel(BSel),
    .In0(Rs2),
    .In1(Imm),
    .Out(Rs2_ALU)
);

///********************************************************///
//////////////////////////// ALU /////////////////////////////
///********************************************************///

ALU #(.DATA_WIDTH(DATA_WIDTH)) U0_ALU (
    .Src_A(Rs1_ALU),
    .Src_B(Rs2_ALU),
    .ALUSel(ALUSel),
    .ALU_Result(ALU_Result)
);

///********************************************************///
////////////////////// Write Back Mux ////////////////////////
///********************************************************///

Mux3x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_WriteBack_Mux (
    .Sel(WBSel),
    .In0(Mem),
    .In1(ALU_Result),
    .In2(PC_Plus_4),
    .Out(Write_Back_Mux3x1)
);


endmodule