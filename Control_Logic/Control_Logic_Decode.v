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


// The commented parts have output signals that need correction; only Instruction_Type is correct for them.

module Control_Logic_Decode (
	input	  wire	[31:0]		Instr,
	output	reg		[2:0] 		ImmSel
	);


wire [8:0] Instruction_Type;


// Extracting bits for all instructions types
assign Instruction_Type = {Instr[30], Instr[14:12], Instr[6:2]};

// Note: I could have concatenated BrEq and BrLT with the instruction type instead of using an if-else condition in the B-format. 
// This would have resulted in an 11-bit selection for the case statement, rather than 9 bits. While this approach is valid, it would have added two additional conditions for checking the B-format.

always @(*) 
 begin
  casex (Instruction_Type)

   /********************************************************************* R_Format *********************************************************************/
   
   9'b0_000_01100 : begin  // add
   					         ImmSel = 3'bxxx;
  				          end
   9'b1_000_01100 : begin  // sub
   					         ImmSel = 3'bxxx;
   				          end
	/*
   9'b0_001_01100 : begin  // sll
					           ImmSel = 3'bxxx;
				            end
   9'b0_010_01100 : begin  // slt
					           ImmSel = 3'bxxx;
				            end
   9'b0_011_00000 : begin  // sltu
					           ImmSel = 3'bxxx;
				            end
   9'b0_100_00000 : begin  // xor
					           ImmSel = 3'bxxx;
				            end
   9'b0_101_00000 : begin  // srl
					           ImmSel = 3'bxxx;
				            end
   9'b1_101_00000 : begin  // sra
					           ImmSel = 3'bxxx;
				            end
	*/
   9'b0_110_00000 : begin  // or
					           ImmSel = 3'bxxx;
				            end
   9'b0_111_00000 : begin  // and
					           ImmSel = 3'bxxx;
				            end

   /********************************************************************* I_Format *********************************************************************/
   
   9'bx_000_00100 : begin  // addi
   					         ImmSel = 3'b001;
  				          end
	/*
   9'bx_010_00100 : begin  // slti
   					         ImmSel = 3'b001;
   				          end
   9'bx_011_00100 : begin  // sltiu
					           ImmSel = 3'b001;
				            end
   9'bx_100_00100 : begin  // xori
					           ImmSel = 3'b001;
				            end
	*/
   9'bx_110_00100 : begin  // ori
					           ImmSel = 3'b001;
				            end
   9'bx_111_00100 : begin  // andi
					           ImmSel = 3'b001;
				            end
	/*
   9'b0_001_00100 : begin  // slli
					           ImmSel = 3'b001;
				            end
   9'b0_101_00100 : begin  // srli
					           ImmSel = 3'b001;
				            end
   9'b0_101_00100 : begin  // srai
					           ImmSel = 3'b001;
				            end
	*/
   /*************************************************************** I_Format Contd. Load ***************************************************************/
   	/*
   9'bx_000_00000 : begin  // lb
   					         ImmSel = 3'b001;
  				          end
   9'bx_001_00000 : begin  // lh
   					         ImmSel = 3'b001;
   				          end
   	*/
   9'bx_010_00000 : begin  // lw
					           ImmSel = 3'b001;
				            end
	/*
   9'bx_100_00000 : begin  // lbu
					           ImmSel = 3'b001;
				            end
   9'bx_101_00000 : begin  // lhu
					           ImmSel = 3'b001;
				            end
	*/
   /*************************************************************** I_Format Contd. JLAR ***************************************************************/
   
   9'bx_xxx_11001 : begin  // jalr
   					         ImmSel = 3'b001;
  				          end

   /********************************************************************* S_Format *********************************************************************/
   	/*
   9'bx_000_01000 : begin  // sb
   					         ImmSel = 3'b010;
  				          end
   9'bx_001_01000 : begin  // sh
   					         ImmSel = 3'b010;
   				          end
   	*/
   9'bx_010_01000 : begin  // sw
					           ImmSel = 3'b010;
				            end

   /********************************************************************* B_Format *********************************************************************/
   
   9'bx_000_11000 : begin  // beq
                     ImmSel = 3'b011;
  				          end
   9'bx_001_11000 : begin  // bne
                     ImmSel = 3'b011;
   					         end
	/*
   9'bx_100_11000 : begin  // blt
   					         ImmSel = 3'b011;
				   	        end
   9'bx_101_11000 : begin  // bge
   					         ImmSel = 3'b011;
  				          end
   9'bx_110_11000 : begin  // bltu
   					         ImmSel = 3'b011;
   				          end
   9'bx_111_11000 : begin  // bgeu
					           ImmSel = 3'b011;
				            end
	*/
   /********************************************************************* U_Format *********************************************************************/
	/*
   9'bx_xxx_00101 : begin  // lui
   					         ImmSel = 3'b101;
  				          end
	*/
   9'bx_xxx_00101 : begin  // auipc
   					         ImmSel = 3'b101;
  				          end

   /********************************************************************* J_Format *********************************************************************/
   
   9'bx_xxx_11011 : begin  // jal
   					         ImmSel = 3'b100;
  				          end

   /*********************************************************** Env_Calls Not Implemented Yet **********************************************************/
   	

   default        : begin  // illegal
					           ImmSel = 3'bxxx;
				            end
  endcase
 end

endmodule