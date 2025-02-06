`include "../Data_Path/Mux3x1.v"
`include "../Data_Path/Mux2x1.v" 

module Hazard_Unit #(parameter DATA_WIDTH = 32) (
	input   wire                    clk,
	input   wire                    rst_n,
	input   wire  [DATA_WIDTH-1:0]  Instr_1,
	input   wire  [DATA_WIDTH-1:0] 	Instr_2,
	input   wire  [DATA_WIDTH-1:0] 	Instr_3,
	input   wire  [DATA_WIDTH-1:0] 	Pipelined_ALU_Result,
	input   wire  [DATA_WIDTH-1:0] 	Write_Back_Mux3x1,
	input   wire  [DATA_WIDTH-1:0] 	Pipelined_Rs1,
	input   wire  [DATA_WIDTH-1:0] 	Pipelined_Rs2,
	output  wire  [DATA_WIDTH-1:0] 	Rs1_Forwarding_Result,
	output  wire  [DATA_WIDTH-1:0] 	Rs2_Forwarding_Result,
	output  reg                     Instr_Hazard,
	output  reg                     PC_Hazard
	);


// ************************************************************ Data Hazard ************************************************************ //

reg [1:0] Rs1_Mux_Sel;
reg [1:0] Rs2_Mux_Sel;


// Instr_1 for rs1 or rs2
// Instr_2 and Inst_3 for rd



// Note: I used a sequential always block here to delay the action to the next clock edge, 
// ensuring that the multiplexer select signal is ready when the next instruction causing 
// the hazard reaches the Execute stage.


// Rs1 Forwarding Selection
always@(posedge clk or negedge rst_n)
 begin
  if (!rst_n)
   begin
   	Rs1_Mux_Sel <= 2'd0;
   end
  else
   begin
   	if (Instr_1[19:15] == 5'b0 || Instr_2[11:7] == 5'b0 || Instr_3[11:7] == 5'b0)
     begin
   	  Rs1_Mux_Sel <= 2'd0;                      // No forwarding
     end
    else
     begin
   	  if (Instr_2[11:7] == Instr_1[19:15])
  	  	Rs1_Mux_Sel <= 2'd1;                    // Take Result from ALU
      else if (Instr_3[11:7] == Instr_1[19:15])
  	  	Rs1_Mux_Sel <= 2'd2;                    // Take Result from Write Back
      else
  	  	Rs1_Mux_Sel <= 2'd0;                    // No Forwarding
     end
   end
 end


// Rs2 Forwarding Selection
always@(posedge clk or negedge rst_n)
 begin
  if (!rst_n)
   begin
   	Rs2_Mux_Sel <= 2'd0;
   end
  else
   begin
   	if (Instr_1[24:20] == 5'b0 || Instr_2[11:7] == 5'b0 || Instr_3[11:7] == 5'b0 || Instr_1[6:2] == 5'b00100) // In I-type instruction, rs2 bits are repurposed for the immediate value. So it will be misleading if rs2 was equal to rd
     begin                                                                                                    // Therefore, the opcode of I-type instructions is included to handle this issue (effective 5 bits )
   	  Rs2_Mux_Sel <= 2'd0;                      // No forwarding
     end
    else
     begin
   	  if (Instr_2[11:7] == Instr_1[24:20])
  	  	Rs2_Mux_Sel <= 2'd1;                    // Take Result from ALU
      else if (Instr_3[11:7] == Instr_1[24:20])
  	  	Rs2_Mux_Sel <= 2'd2;                    // Take Result from Write Back
      else
  	  	Rs2_Mux_Sel <= 2'd0;                    // No Forwarding
     end
   end
 end


Mux3x1 Rs1_Mux(.In0(Pipelined_Rs1), .In1(Pipelined_ALU_Result), .In2(Write_Back_Mux3x1), .Sel(Rs1_Mux_Sel), .Out(Rs1_Forwarding_Result));
Mux3x1 Rs2_Mux(.In0(Pipelined_Rs2), .In1(Pipelined_ALU_Result), .In2(Write_Back_Mux3x1), .Sel(Rs2_Mux_Sel), .Out(Rs2_Forwarding_Result));


// ************************************************************ Load Hazard ************************************************************ //


always@(*)
 begin
  if ( Instr_2[6:0] == 7'b0000011 && (Instr_2[11:7] == Instr_1[19:15] || Instr_2[11:7] == Instr_1[24:20]) )
   begin
   	Instr_Hazard <= 1'b0;   // Stall Instruction
   	PC_Hazard <= 1'b0;      // Stall PC
   end
  else 
   begin
   	Instr_Hazard <= 1'b1;
   	PC_Hazard <= 1'b1;
   end
 end

endmodule


