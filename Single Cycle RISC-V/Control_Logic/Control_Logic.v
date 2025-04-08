/*
  Truth Table for ImmSel:
  +-------------+---------+----------------------+
  | ImmSel Value| Type    | Description          |
  +-------------+---------+----------------------+
  |    3'b001   | I-Format| Immediate            |
  |    3'b010   | S-Format| Store Instructions   |
  |    3'b011   | B-Format| Branch Instructions  |
  |    3'b100   | J-Format| Jump                 |
  |    3'b101   | U-Format| Upper Immediate      |
  +-------------+---------+----------------------+
*/

/*
  Truth Table for WBSel:
  +-------------+---------+------------------+
  | WBSel Value | Source  | Description      |
  +-------------+---------+------------------+
  |    2'b00    | Mem     | Memory Read Data |
  |    2'b01    | ALU     | ALU Result       |
  |    2'b10    | PC+4    | Return Address   |
  +-------------+---------+------------------+
*/

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

module Control_Logic (
	input	  wire	[31:0]	Instr,
	input	  wire				  BrEq,
	input	  wire				  BrLT,
	output	reg					  PCSel,
	output	reg		[2:0]		ImmSel, 
	output	reg					  RegWEn,
	output	reg					  BrUn,
	output	reg 				  BSel,
	output	reg 				  ASel,
	output	reg 	[3:0]		ALUSel,
	output	reg 				  MemRW,
	output	reg 	[1:0]		WBSel
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
   					         PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
  				          end
   9'b1_000_01100 : begin  // sub
   					         PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
   				          end
	/*
   9'b0_001_01100 : begin  // sll
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_010_01100 : begin  // slt
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_011_00000 : begin  // sltu
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0011; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_100_00000 : begin  // xor
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0100; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_101_00000 : begin  // srl
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0101; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b1_101_00000 : begin  // sra
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1101; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
	*/
   9'b0_110_00000 : begin  // or
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0110; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_111_00000 : begin  // and
					           PCSel = 1'b0; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0111; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end

   /********************************************************************* I_Format *********************************************************************/
   
   9'bx_000_00100 : begin  // addi
   					         PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
  				          end
	/*
   9'bx_010_00100 : begin  // slti
   					         PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   9'bx_011_00100 : begin  // sltiu
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'bx_100_00100 : begin  // xori
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   9'bx_110_00100 : begin  // ori
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0110; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'bx_111_00100 : begin  // andi
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0111; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
				            end
	/*
   9'b0_001_00100 : begin  // slli
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0101; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'b0_101_00100 : begin  // srli
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1101; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'b0_101_00100 : begin  // srai
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0110; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /*************************************************************** I_Format Contd. Load ***************************************************************/
   	/*
   9'bx_000_00000 : begin  // lb
   					         PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_001_00000 : begin  // lh
   					         PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   	*/
   9'bx_010_00000 : begin  // lw
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
	/*
   9'bx_100_00000 : begin  // lbu
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0010; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'bx_101_00000 : begin  // lhu
					           PCSel = 1'b0; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0011; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /*************************************************************** I_Format Contd. JLAR ***************************************************************/
   
   9'bx_xxx_11001 : begin  // jalr
   					         PCSel = 1'b1; ImmSel = 3'b001; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b10;
  				          end

   /********************************************************************* S_Format *********************************************************************/
   	/*
   9'bx_000_01000 : begin  // sb
   					         PCSel = 1'b0; ImmSel = 3'b010; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_001_01000 : begin  // sh
   					         PCSel = 1'b0; ImmSel = 3'b010; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   	*/
   9'bx_010_01000 : begin  // sw
					           PCSel = 1'b0; ImmSel = 3'b010; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b1; RegWEn = 1'b0; WBSel = 2'bxx;
				            end

   /********************************************************************* B_Format *********************************************************************/
   
   9'bx_000_11000 : begin  // beq
                     PCSel = (BrEq == 0) ? 1'b0 : 1'b1; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;
   					         /*
   					         if (BrEq == 0)
   					          begin
   					           PCSel = 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;
   					          end
   					         else
   					          begin
   					           PCSel = 1'b1; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;
   					          end
   					         */
  				          end
   9'bx_001_11000 : begin  // bne
                     PCSel = (BrEq == 0) ? 1'b1 : 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;
   					         /*
   					         if (BrEq == 0)
   					          begin
   					           PCSel = 1'b1; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;
   					          end
   					         else
   					          begin
   					           PCSel = 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b0; WBSel = 2'bxx;	
   					          end
   					        */
   					        end
	/*
   9'bx_100_11000 : begin  // blt
   					         if (BrLT)
   					          begin
					             PCSel = 1'b1; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				   	          end
				   	         else
				   	          begin  	
					             PCSel = 1'bx; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'bx; BSel = 1'bx; ALUSel = 4'bxxxx; MemRW = 1'bx; RegWEn = 1'bx; WBSel = 2'bxx;
				              end
				            end
   9'bx_101_11000 : begin  // bge
   					         PCSel = 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_110_11000 : begin  // bltu
   					         PCSel = 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b1000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   9'bx_111_11000 : begin  // bgeu
					           PCSel = 1'b0; ImmSel = 3'b011; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0001; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /********************************************************************* U_Format *********************************************************************/
	/*
   9'bx_xxx_00101 : begin  // lui
   					         PCSel = 1'b0; ImmSel = 3'b101; BrUn = 1'bx; ASel = 1'b0; BSel = 1'b0; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b00;
  				          end
	*/
   9'bx_xxx_00101 : begin  // auipc
   					         PCSel = 1'b0; ImmSel = 3'b101; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b01;
  				          end

   /********************************************************************* J_Format *********************************************************************/
   
   9'bx_xxx_11011 : begin  // jal
   					         PCSel = 1'b1; ImmSel = 3'b100; BrUn = 1'bx; ASel = 1'b1; BSel = 1'b1; ALUSel = 4'b0000; MemRW = 1'b0; RegWEn = 1'b1; WBSel = 2'b10;
  				          end

   /*********************************************************** Env_Calls Not Implemented Yet **********************************************************/
   	

   default        : begin  // illegal
					           PCSel = 1'bx; ImmSel = 3'bxxx; BrUn = 1'bx; ASel = 1'bx; BSel = 1'bx; ALUSel = 4'bxxxx; MemRW = 1'bx; RegWEn = 1'bx; WBSel = 2'bxx;
				            end
  endcase
 end

endmodule



