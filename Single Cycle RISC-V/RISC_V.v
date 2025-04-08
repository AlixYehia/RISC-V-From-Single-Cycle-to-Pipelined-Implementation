`include "Data_Path/Data_Path.v"
`include "Control_Logic/Control_Logic.v"

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




///********************************************************///
///////////////////////// Data Path //////////////////////////
///********************************************************///

Data_Path #(.DATA_WIDTH(DATA_WIDTH)) U_Data_Path(
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
    .ALU_Result(Addr_DMEM),
    .Rs2(Rs2),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

///********************************************************///
/////////////////////// Control Logic ////////////////////////
///********************************************************///

Control_Logic U_Control_Logic(
	.Instr(Instr),
	.BrEq(BrEq),
	.BrLT(BrLT),
	.PCSel(PCSel),
	.ImmSel(ImmSel), 
	.RegWEn(RegWEn),
	.BrUn(BrUn),
	.BSel(BSel),
	.ASel(ASel),
	.ALUSel(ALUSel),
	.MemRW(MemRW),
	.WBSel(WBSel)
);


endmodule