/*
  Truth Table for ALUSel:
  +-------------+-------------------------------+
  | ALUSel      | Operation                     |
  +-------------+-------------------------------+
  | 4'b0000     | Add                           |
  | 4'b1000     | Subtract                      |
  | 4'b0001     | Shift Left Logical (SLL)      |
  | 4'b0010     | Set Less Than signed   (SLT)  |
  | 4'b0011     | Set Less Than unsigned (SLTU) |
  | 4'b0100     | XOR                           |
  | 4'b0101     | Shift Right Logical (SRL)     |
  | 4'b1101     | Shift Right Arithmetic (SRA)  |
  | 4'b0110     | OR                            |
  | 4'b0111     | AND                           |
  | default     | Illegal (Till now)            |
  +-------------+-------------------------------+
*/


// The commented parts have output signals that need correction; only Instruction_Type is correct for them.

module Control_Logic_Execute (
	input	  wire	[31:0]	Instr,
	input	  wire				  BrEq,
	input	  wire				  BrLT,
	output	reg					  BrUn,
	output	reg 				  BSel,
	output	reg 				  ASel,
	output	reg 	[3:0]		ALUSel
	);


wire [8:0] Instruction_Type;


// Extracting bits for all instructions types
assign Instruction_Type = {Instr[30], Instr[14:12], Instr[6:2]};

// Note that I could have concatenated BrEq and BrLT with Instruction type instead of using if-else condition in the B-Format so would have the selection of the case statement 11 bits instead of 9
// Which is also a valid but that would add 2 more conditions for the B-Format checking


always @(*) 
 begin
  casex (Instruction_Type)

   /********************************************************************* R_Format *********************************************************************/
   
   9'b0_000_01100 : begin  // add
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000;
  				          end
   9'b1_000_01100 : begin  // sub
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000;
   				          end
	/*
   9'b0_001_01100 : begin  // sll
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001;
				            end
   9'b0_010_01100 : begin  // slt
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010;
				            end
   9'b0_011_00000 : begin  // sltu
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0011;
				            end
   9'b0_100_00000 : begin  // xor
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0100;
				            end
   9'b0_101_00000 : begin  // srl
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0101;
				            end
   9'b1_101_00000 : begin  // sra
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1101;
				            end
	*/
   9'b0_110_00000 : begin  // or
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0110;
				            end
   9'b0_111_00000 : begin  // and
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0111;
				            end

   /********************************************************************* I_Format *********************************************************************/
   
   9'bx_000_00100 : begin  // addi
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000;
  				          end
	/*
   9'bx_010_00100 : begin  // slti
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010;
   				          end
   9'bx_011_00100 : begin  // sltiu
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001;
				            end
   9'bx_100_00100 : begin  // xori
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010;
				            end
	*/
   9'bx_110_00100 : begin  // ori
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0110;
				            end
   9'bx_111_00100 : begin  // andi
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0111;
				            end
	/*
   9'b0_001_00100 : begin  // slli
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0101;
				            end
   9'b0_101_00100 : begin  // srli
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1101;
				            end
   9'b0_101_00100 : begin  // srai
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0110;
				            end
	*/
   /*************************************************************** I_Format Contd. Load ***************************************************************/
   	/*
   9'bx_000_00000 : begin  // lb
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000;
  				          end
   9'bx_001_00000 : begin  // lh
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000;
   				          end
   	*/
   9'bx_010_00000 : begin  // lw
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000;
				            end
	/*
   9'bx_100_00000 : begin  // lbu
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010;
				            end
   9'bx_101_00000 : begin  // lhu
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0011;
				            end
	*/
   /*************************************************************** I_Format Contd. JLAR ***************************************************************/
   
   9'bx_xxx_11001 : begin  // jalr
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000;
  				          end

   /********************************************************************* S_Format *********************************************************************/
   	/*
   9'bx_000_01000 : begin  // sb
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000;
  				          end
   9'bx_001_01000 : begin  // sh
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000;
   				          end
   	*/
   9'bx_010_01000 : begin  // sw
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000;
				            end

   /********************************************************************* B_Format *********************************************************************/
   
   9'bx_000_11000 : begin  // beq
                     BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000;
  				          end
   9'bx_001_11000 : begin  // bne
                     BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000;
   					        end
	/*
   9'bx_100_11000 : begin  // blt
                     BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001;
				            end
   9'bx_101_11000 : begin  // bge
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000;
  				          end
   9'bx_110_11000 : begin  // bltu
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000;
   				          end
   9'bx_111_11000 : begin  // bgeu
					           BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001;
				            end
	*/
   /********************************************************************* U_Format *********************************************************************/
	/*
   9'bx_xxx_00101 : begin  // lui
   					         BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000;
  				          end
	*/
   9'bx_xxx_00101 : begin  // auipc
   					         BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000;
  				          end

   /********************************************************************* J_Format *********************************************************************/
   
   9'bx_xxx_11011 : begin  // jal
   					         BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000;
  				          end

   /*********************************************************** Env_Calls Not Implemented Yet **********************************************************/
   	

   default        : begin  // illegal
					           BrUn = 1'bx; ASel = 1'bx; BSel = 1'bx; ALUSel = 4'bxxxx;
				            end
  endcase
 end

endmodule