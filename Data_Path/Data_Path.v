`include "Mux2x1.v"
`include "PC.v"
`include "Add.v"
`include "ImmGen.v"
`include "RegisterFile.v"
`include "BranchComp.v"
`include "ALU.v"
`include "Mux3x1.v"
`include "Register.v"
`include "En_Register.v"
`include "../Hazard_Unit/Hazard_Unit.v"

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
    output  wire     [DATA_WIDTH-1:0]     Pipelined_Rs2_2,                 // Modified for Pipeline
    output  wire     [DATA_WIDTH-1:0]     Pipelined_Instr_1,               // ================= Pipelined Instruction ================= //
    output  wire     [DATA_WIDTH-1:0]     Pipelined_Instr_2,               // ================= Pipelined Instruction ================= //
    output  wire     [DATA_WIDTH-1:0]     Pipelined_Instr_3,               // ================= Pipelined Instruction ================= //
    output  wire     [DATA_WIDTH-1:0]     Pipelined_Instr_4,               // ================= Pipelined Instruction ================= //
    output  wire                          Pipelined_BrEq,                  // -- To Delay BrEq one clk to be used in Memory Control to generate PCSel correctly -- //
    output  wire                          Pipelined_BrLT,                  // -- To Delay and BrLT one clk to be used in Memory Control to generate PCSel correctly -- //
    output  wire     [DATA_WIDTH-1:0]     Pipelined_ALU_Result,            // Modified for Piepline
    output  wire                          BrEq,
    output  wire                          BrLT
    );


// Internal Wires

wire [DATA_WIDTH-1:0] PC_Plus_4;

wire [DATA_WIDTH-1:0] PC_Mux2x1_Out;

wire [DATA_WIDTH-1:0] Imm;

wire [DATA_WIDTH-1:0] Write_Back_Mux3x1;

wire [DATA_WIDTH-1:0] Rs1_ALU;
wire [DATA_WIDTH-1:0] Rs2_ALU;


// Pipeline Wires

wire [DATA_WIDTH-1:0] PC_Next_Reg1;
wire [DATA_WIDTH-1:0] PC_Next_Reg2;
wire [DATA_WIDTH-1:0] PC_Next_Reg3;
wire [DATA_WIDTH-1:0] Pipelined_PC_Plus_4;

wire [DATA_WIDTH-1:0] Rs1;
wire [DATA_WIDTH-1:0] Rs2;
wire [DATA_WIDTH-1:0] Pipelined_Rs1;
wire [DATA_WIDTH-1:0] Pipelined_Rs2;

wire [DATA_WIDTH-1:0] ALU_Result;

wire [DATA_WIDTH-1:0] Pipelined_PC_Plus_4_Out_Mux;
wire [DATA_WIDTH-1:0] Pipelined_ALU_Result_Mux;
wire [DATA_WIDTH-1:0] Pipelined_Mem_Mux;

wire [DATA_WIDTH-1:0] Pipelined_Imm;


// Hazard Unit Forawrd Wires

wire [DATA_WIDTH-1:0] Rs1_Forwarding_Result;
wire [DATA_WIDTH-1:0] Rs2_Forwarding_Result;

wire                  Instr_Hazard;
wire                  PC_Hazard;




///********************************************************///
////////////////////////// PC Mux ////////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_PC_Mux (
    .Sel(PCSel),
    .In0(PC_Plus_4),
    .In1(Pipelined_ALU_Result),      // Modified for Pipeline
    .Out(PC_Mux2x1_Out)
);

///********************************************************///
//////////////////////// PC Register /////////////////////////
///********************************************************///

PC #(.DATA_WIDTH(DATA_WIDTH)) U0_PC (
    .clk(clk),
    .rst_n(rst_n),
    .En(PC_Hazard),                  // Added for Load Hazard
    .PC_In(PC_Mux2x1_Out),
    .PC_Out(PC_Next)
);


// ----------------------------------------------------------------------- Pipelined PC ----------------------------------------------------------------------- //

//----------------------------------------------------------//
//---------------- Pipeline_Registered_PC 1 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_PC (
    .clk(clk),
    .rst_n(rst_n),
    .In(PC_Next),
    .Out(PC_Next_Reg1)
);

//----------------------------------------------------------//
//---------------- Pipeline_Registered_PC 2 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U2_Pipeline_Registered_PC (
    .clk(clk),
    .rst_n(rst_n),
    .In(PC_Next_Reg1),
    .Out(PC_Next_Reg2)
);

//----------------------------------------------------------//
//---------------- Pipeline_Registered_PC 3 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U3_Pipeline_Registered_PC (
    .clk(clk),
    .rst_n(rst_n),
    .In(PC_Next_Reg2),
    .Out(PC_Next_Reg3)
);

//----------------------------------------------------------//
//------------ Adder for Pipeline_Registered_PC ------------//
//----------------------------------------------------------//

Add #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Add (
    .PC(PC_Next_Reg3),
    .PC_Plus_4(Pipelined_PC_Plus_4)
);

//----------------------------------------------------------//
//---------------- Pipeline_Registered_PC+4 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_PC_Plus4 (
    .clk(clk),
    .rst_n(rst_n),
    .In(Pipelined_PC_Plus_4),
    .Out(Pipelined_PC_Plus_4_Out_Mux)
);


///********************************************************///
///////////////////////// Adder for PC ///////////////////////
///********************************************************///

Add #(.DATA_WIDTH(DATA_WIDTH)) U0_Add (
    .PC(PC_Next),
    .PC_Plus_4(PC_Plus_4)
);


// ------------------------------------------------------------------- Pipelined Instruction ------------------------------------------------------------------- //

//----------------------------------------------------------//
//------------ Pipeline_Registered_Instruction 1------------//
//----------------------------------------------------------//

En_Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Instruction (
    .clk(clk),
    .rst_n(rst_n),
    .En(Instr_Hazard),      // Added for Load Hazard
    .In(Instr),
    .Out(Pipelined_Instr_1)
);

//----------------------------------------------------------//
//------------ Pipeline_Registered_Instruction 2------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U2_Pipeline_Instruction (
    .clk(clk),
    .rst_n(rst_n),
    .In(Pipelined_Instr_1),
    .Out(Pipelined_Instr_2)
);

//----------------------------------------------------------//
//------------ Pipeline_Registered_Instruction 3------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U3_Pipeline_Instruction (
    .clk(clk),
    .rst_n(rst_n),
    .In(Pipelined_Instr_2),
    .Out(Pipelined_Instr_3)
);


// -- To Delay BrEq and BrLT one clk to be used in Memory Control to generate PCSel correctly -- //

Register #(.DATA_WIDTH(1)) U1_BrEq (
    .clk(clk),
    .rst_n(rst_n),
    .In(BrEq),
    .Out(Pipelined_BrEq)
);

Register #(.DATA_WIDTH(1)) U1_BrLT (
    .clk(clk),
    .rst_n(rst_n),
    .In(BrLT),
    .Out(Pipelined_BrLT)
);


//----------------------------------------------------------//
//------------ Pipeline_Registered_Instruction 4------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U4_Pipeline_Instruction (
    .clk(clk),
    .rst_n(rst_n),
    .In(Pipelined_Instr_3),
    .Out(Pipelined_Instr_4)
);

// ------------------------------------------------------------------------------------------------------------------------------------------------------------- //


///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

RegisterFile #(.DATA_WIDTH(DATA_WIDTH)) U0_Register_File (
    .clk(clk),
    .DataD(Write_Back_Mux3x1),
    .AddrD(Pipelined_Instr_4[11:7]),         // Modified for Pipeline
    .AddrA(Pipelined_Instr_1[19:15]),        // Modified for Pipeline and Hazard
    .AddrB(Pipelined_Instr_1[24:20]),        // Modified for Pipeline and Hazard
    .RegWEn(RegWEn),
    .DataA(Rs1),
    .DataB(Rs2)
);


// ------------------------------------------------------------------- Pipelined Rs1 and Rs2 ------------------------------------------------------------------- //

//----------------------------------------------------------//
//----------------- Pipeline_Registered_Rs1 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_Rs1 (
    .clk(clk),
    .rst_n(rst_n),
    .In(Rs1),
    .Out(Pipelined_Rs1)
);

//----------------------------------------------------------//
//----------------- Pipeline_Registered_Rs2 ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_Rs2 (
    .clk(clk),
    .rst_n(rst_n),
    .In(Rs2),
    .Out(Pipelined_Rs2)
);


// ******************************************************************* Hazard Unit (Forwarding) **************************************************************** //

///********************************************************///
///**************** Hazard_Unit Forwarding ****************///
///********************************************************///

Hazard_Unit #(.DATA_WIDTH(DATA_WIDTH)) U0_Hazard_Unit (
    .clk(clk),
    .rst_n(rst_n),
    .Instr_1(Pipelined_Instr_1),
    .Instr_2(Pipelined_Instr_2),
    .Instr_3(Pipelined_Instr_3),
    .Pipelined_ALU_Result(Pipelined_ALU_Result),
    .Write_Back_Mux3x1(Write_Back_Mux3x1),
    .Pipelined_Rs1(Pipelined_Rs1),
    .Pipelined_Rs2(Pipelined_Rs2),
    .Rs1_Forwarding_Result(Rs1_Forwarding_Result),
    .Rs2_Forwarding_Result(Rs2_Forwarding_Result),
    .Instr_Hazard(Instr_Hazard),
    .PC_Hazard(PC_Hazard)
);

// ************************************************************************************************************************************************************* //


//----------------------------------------------------------//
//---------------- Pipeline_Registered_Rs2_2 ---------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_Rs2_2 (
    .clk(clk),
    .rst_n(rst_n),
    .In(Rs2_Forwarding_Result),        // Modified for Hazard
    .Out(Pipelined_Rs2_2)
);

// ------------------------------------------------------------------------------------------------------------------------------------------------------------- //


///********************************************************///
/////////////////////// Immediate Generator //////////////////
///********************************************************///

ImmGen U0_ImmGen (
    .Instr(Pipelined_Instr_1[31:7]),   // Modified for Pipeline and Hazard
    .ImmSel(ImmSel),
    .Imm(Imm)
);


// ----------------------------------------------------------------------- Pipelined Imm ----------------------------------------------------------------------- //

//----------------------------------------------------------//
//----------------- Pipeline_Registered_Imm ----------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_Imm (
    .clk(clk),
    .rst_n(rst_n),
    .In(Imm),
    .Out(Pipelined_Imm)
);


///********************************************************///
////////////////////// Branch Comparator /////////////////////
///********************************************************///

BranchComp #(.DATA_WIDTH(DATA_WIDTH)) U0_BranchComp (
    .DataA(Rs1_Forwarding_Result),   // Modified for Pipeline and Hazard
    .DataB(Rs2_Forwarding_Result),   // Modified for Pipeline and Hazard
    .BrUn(BrUn),
    .BrEq(BrEq),
	.BrLT(BrLT)
);

///********************************************************///
////////////////////////// Rs1 Mux ///////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_Rs1_Mux (
    .Sel(ASel),
    .In0(Rs1_Forwarding_Result),     // Modified for Pipeline and Hazard
    .In1(PC_Next_Reg2),              // Modified for Pipeline
    .Out(Rs1_ALU)
);

///********************************************************///
////////////////////////// Rs2 Mux ///////////////////////////
///********************************************************///

Mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_Rs2_Mux (
    .Sel(BSel),
    .In0(Rs2_Forwarding_Result),     // Modified for Pipeline and Hazard
    .In1(Pipelined_Imm),             // Modified for Pipeline
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


// ----------------------------------------------------------------------- Pipelined ALU ----------------------------------------------------------------------- //

//----------------------------------------------------------//
//---------------- Pipeline_Registered_ALU 1 ---------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Registered_ALU (
    .clk(clk),
    .rst_n(rst_n),
    .In(ALU_Result),
    .Out(Pipelined_ALU_Result)       // Output form Pipeline to DMEM
);

//----------------------------------------------------------//
//---------------- Pipeline_Registered_ALU 2 ---------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U2_Pipeline_Registered_ALU (
    .clk(clk),
    .rst_n(rst_n),
    .In(Pipelined_ALU_Result),
    .Out(Pipelined_ALU_Result_Mux)   // Output form Pipeline to Mux3X1
);

//----------------------------------------------------------//
//---------------------- Pipeline_Mem ----------------------//
//----------------------------------------------------------//

Register #(.DATA_WIDTH(DATA_WIDTH)) U1_Pipeline_Mem (
    .clk(clk),
    .rst_n(rst_n),
    .In(Mem),
    .Out(Pipelined_Mem_Mux)
);


///********************************************************///
////////////////////// Write Back Mux ////////////////////////
///********************************************************///

Mux3x1 #(.DATA_WIDTH(DATA_WIDTH)) U0_WriteBack_Mux (
    .Sel(WBSel),
    .In0(Pipelined_Mem_Mux),
    .In1(Pipelined_ALU_Result_Mux),          // Modified for Pipeline
    .In2(Pipelined_PC_Plus_4_Out_Mux),       // Modified for Pipeline
    .Out(Write_Back_Mux3x1)
);


endmodule
