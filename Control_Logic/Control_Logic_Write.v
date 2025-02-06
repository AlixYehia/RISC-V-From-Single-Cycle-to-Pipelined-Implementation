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

// The commented parts have output signals that need correction; only Instruction_Type is correct for them.

module Control_Logic_Write (
	input	  wire	[31:0]	Instr,
	output	reg					  RegWEn,
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
   					         RegWEn = 1'b1; WBSel = 2'b01;
  				          end
   9'b1_000_01100 : begin  // sub
   					         RegWEn = 1'b1; WBSel = 2'b01;
   				          end
	/*
   9'b0_001_01100 : begin  // sll
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_010_01100 : begin  // slt
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_011_00000 : begin  // sltu
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_100_00000 : begin  // xor
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_101_00000 : begin  // srl
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b1_101_00000 : begin  // sra
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
	*/
   9'b0_110_00000 : begin  // or
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'b0_111_00000 : begin  // and
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end

   /********************************************************************* I_Format *********************************************************************/
   
   9'bx_000_00100 : begin  // addi
   					         RegWEn = 1'b1; WBSel = 2'b01;
  				          end
	/*
   9'bx_010_00100 : begin  // slti
   					         RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   9'bx_011_00100 : begin  // sltiu
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'bx_100_00100 : begin  // xori
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   9'bx_110_00100 : begin  // ori
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
   9'bx_111_00100 : begin  // andi
					           RegWEn = 1'b1; WBSel = 2'b01;
				            end
	/*
   9'b0_001_00100 : begin  // slli
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'b0_101_00100 : begin  // srli
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'b0_101_00100 : begin  // srai
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /*************************************************************** I_Format Contd. Load ***************************************************************/
   	/*
   9'bx_000_00000 : begin  // lb
   					         RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_001_00000 : begin  // lh
   					         RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   	*/
   9'bx_010_00000 : begin  // lw
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
	/*
   9'bx_100_00000 : begin  // lbu
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
   9'bx_101_00000 : begin  // lhu
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /*************************************************************** I_Format Contd. JLAR ***************************************************************/
   
   9'bx_xxx_11001 : begin  // jalr
   					         RegWEn = 1'b1; WBSel = 2'b10;
  				          end

   /********************************************************************* S_Format *********************************************************************/
   	/*
   9'bx_000_01000 : begin  // sb
   					         RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_001_01000 : begin  // sh
   					         RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   	*/
   9'bx_010_01000 : begin  // sw
					           RegWEn = 1'b0; WBSel = 2'bxx;
				            end

   /********************************************************************* B_Format *********************************************************************/
   
   9'bx_000_11000 : begin  // beq
                     RegWEn = 1'b0; WBSel = 2'bxx;
  				          end
   9'bx_001_11000 : begin  // bne
                     RegWEn = 1'b0; WBSel = 2'bxx;
   					        end
	/*
   9'bx_100_11000 : begin  // blt
					           RegWEn = 1'b1; WBSel = 2'b00;
				   	        end
   9'bx_101_11000 : begin  // bge
   					         RegWEn = 1'b1; WBSel = 2'b00;
  				          end
   9'bx_110_11000 : begin  // bltu
   					         RegWEn = 1'b1; WBSel = 2'b00;
   				          end
   9'bx_111_11000 : begin  // bgeu
					           RegWEn = 1'b1; WBSel = 2'b00;
				            end
	*/
   /********************************************************************* U_Format *********************************************************************/
	/*
   9'bx_xxx_00101 : begin  // lui
   					         RegWEn = 1'b1; WBSel = 2'b00;
  				          end
	*/
   9'bx_xxx_00101 : begin  // auipc
   					         RegWEn = 1'b1; WBSel = 2'b01;
  				          end

   /********************************************************************* J_Format *********************************************************************/
   
   9'bx_xxx_11011 : begin  // jal
   					         RegWEn = 1'b1; WBSel = 2'b10;
  				          end

   /*********************************************************** Env_Calls Not Implemented Yet **********************************************************/
   	

   default        : begin  // illegal
					           RegWEn = 1'bx; WBSel = 2'bxx;
				            end
  endcase
 end

endmodule