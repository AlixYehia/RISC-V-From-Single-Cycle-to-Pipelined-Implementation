`include "Data_Path/Data_Path.v"
`include "Control_Logic/Control_Logic_Decode.v"
`include "Control_Logic/Control_Logic_Execute.v"
`include "Control_Logic/Control_Logic_Memory.v"
`include "Control_Logic/Control_Logic_Write.v"

module RISC_V #(parameter DATA_WIDTH = 32) (
	input  wire                       clk,
	input  wire                       rst_n,
	input  wire	  [31:0]              Instr,
	input  wire   [DATA_WIDTH-1:0]    Mem,
	output wire   [DATA_WIDTH-1:0]    Addr_IMEM,
	output wire   [DATA_WIDTH-1:0]    Addr_DMEM,
	output wire   [DATA_WIDTH-1:0]    Rs2,
	output wire                       MemRW
	);


// Internal Wires

wire                  PCSel;

wire [2:0]            ImmSel;

wire                  RegWEn;

wire                  BrUn;

wire                  BrEq;

wire                  BrLT;

wire                  BSel;

wire                  ASel;

wire [3:0]            ALUSel;

wire [1:0]            WBSel;


// Pipeline Wires

wire [DATA_WIDTH-1:0]     Pipelined_Instr_1;
wire [DATA_WIDTH-1:0]     Pipelined_Instr_2;
wire [DATA_WIDTH-1:0]     Pipelined_Instr_3;
wire [DATA_WIDTH-1:0]     Pipelined_Instr_4;

wire                      Pipelined_BrEq;
wire                      Pipelined_BrLT;



///********************************************************///
///////////////////////// Data Path //////////////////////////
///********************************************************///

Data_Path #(.DATA_WIDTH(DATA_WIDTH)) U_Data_Path (
    .clk(clk),
    .rst_n(rst_n),
    .PCSel(PCSel),
    .ImmSel(ImmSel), 
    .RegWEn(RegWEn),
    .BrUn(BrUn),
    .BSel(BSel),
    .ASel(ASel),
    .ALUSel(ALUSel),
    .MemRW(MemRW),
    .WBSel(WBSel),
    .Instr(Instr),
    .Mem(Mem),
    .PC_Next(Addr_IMEM),
    .Pipelined_ALU_Result(Addr_DMEM),          // Modified for Pipeline
    .Pipelined_Rs2_2(Rs2),                     // Modified for Pipeline
    .BrEq(BrEq),
    .BrLT(BrLT),
    .Pipelined_Instr_1(Pipelined_Instr_1),                         // ================= Pipelined Instruction ================= //
    .Pipelined_Instr_2(Pipelined_Instr_2),                         // ================= Pipelined Instruction ================= //
    .Pipelined_Instr_3(Pipelined_Instr_3),                         // ================= Pipelined Instruction ================= //
    .Pipelined_Instr_4(Pipelined_Instr_4),                         // ================= Pipelined Instruction ================= //
    .Pipelined_BrEq(Pipelined_BrEq),                               // -- To Delay BrEq one clk to be used in Memory Control to generate PCSel correctly -- //
    .Pipelined_BrLT(Pipelined_BrLT)                                // -- To Delay BrLT one clk to be used in Memory Control to generate PCSel correctly -- //
);

///********************************************************///
/////////////////// Control Logic Decode /////////////////////
///********************************************************///

Control_Logic_Decode U_Control_Logic_Decode (
	.Instr(Pipelined_Instr_1),
	.ImmSel(ImmSel) 
);

///********************************************************///
////////////////// Control Logic Execute /////////////////////
///********************************************************///

Control_Logic_Execute U_Control_Logic_Execute (
	.Instr(Pipelined_Instr_2),
	.BrEq(BrEq),
	.BrLT(BrLT),
	.BrUn(BrUn),
	.BSel(BSel),
	.ASel(ASel),
	.ALUSel(ALUSel)
);

///********************************************************///
/////////////////// Control Logic Memory /////////////////////
///********************************************************///

Control_Logic_Memory U_Control_Logic_Memory (
	.Instr(Pipelined_Instr_3), 
	.BrEq(Pipelined_BrEq),
	.BrLT(Pipelined_BrLT),
	.PCSel(PCSel),
	.MemRW(MemRW)
);

///********************************************************///
/////////////////// Control Logic Write //////////////////////
///********************************************************///

Control_Logic_Write U_Control_Logic_Write (
	.Instr(Pipelined_Instr_4),
	.RegWEn(RegWEn),
	.WBSel(WBSel)
);


endmodule