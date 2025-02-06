// The commented parts have output signals that need correction; only Instruction_Type is correct for them.

module Control_Logic_Memory (
	input	  wire	[31:0]     Instr,
	input	  wire				  BrEq,
	input	  wire				  BrLT,
	output  reg					  PCSel,
	output  reg 				  MemRW
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
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b1_000_01100 : begin  // sub
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	/*
   9'b0_001_01100 : begin  // sll
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_010_01100 : begin  // slt
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_011_00000 : begin  // sltu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_100_00000 : begin  // xor
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_101_00000 : begin  // srl
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b1_101_00000 : begin  // sra
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   9'b0_110_00000 : begin  // or
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_111_00000 : begin  // and
                     PCSel = 1'b0; MemRW = 1'b0;
                    end

   /********************************************************************* I_Format *********************************************************************/
   
   9'bx_000_00100 : begin  // addi
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	/*
   9'bx_010_00100 : begin  // slti
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_011_00100 : begin  // sltiu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_100_00100 : begin  // xori
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   9'bx_110_00100 : begin  // ori
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_111_00100 : begin  // andi
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	/*
   9'b0_001_00100 : begin  // slli
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_101_00100 : begin  // srli
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'b0_101_00100 : begin  // srai
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   /*************************************************************** I_Format Contd. Load ***************************************************************/
   	/*
   9'bx_000_00000 : begin  // lb
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_001_00000 : begin  // lh
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   	*/
   9'bx_010_00000 : begin  // lw
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	/*
   9'bx_100_00000 : begin  // lbu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_101_00000 : begin  // lhu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   /*************************************************************** I_Format Contd. JLAR ***************************************************************/
   
   9'bx_xxx_11001 : begin  // jalr
                     PCSel = 1'b1; MemRW = 1'b0;
                    end

   /********************************************************************* S_Format *********************************************************************/
   	/*
   9'bx_000_01000 : begin  // sb
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_001_01000 : begin  // sh
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   	*/
   9'bx_010_01000 : begin  // sw
                     PCSel = 1'b0; MemRW = 1'b1;
                    end

   /********************************************************************* B_Format *********************************************************************/
   
   9'bx_000_11000 : begin  // beq
                     PCSel = (BrEq == 0) ? 1'b0 : 1'b1; MemRW = 1'b0;
                    end
   9'bx_001_11000 : begin  // bne
                     PCSel = (BrEq == 0) ? 1'b1 : 1'b0; MemRW = 1'b0;
                    end
	/*
   9'bx_100_11000 : begin  // blt
                     PCSel = 1'b1; MemRW = 1'b0;
                    end
   9'bx_101_11000 : begin  // bge
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_110_11000 : begin  // bltu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
   9'bx_111_11000 : begin  // bgeu
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   /********************************************************************* U_Format *********************************************************************/
	/*
   9'bx_xxx_00101 : begin  // lui
                     PCSel = 1'b0; MemRW = 1'b0;
                    end
	*/
   9'bx_xxx_00101 : begin  // auipc
                     PCSel = 1'b0; MemRW = 1'b0;
                    end

   /********************************************************************* J_Format *********************************************************************/
   
   9'bx_xxx_11011 : begin  // jal
                     PCSel = 1'b1; MemRW = 1'b0;
                    end

   /*********************************************************** Env_Calls Not Implemented Yet **********************************************************/
   	

   default        : begin  // illegal
                     PCSel = 1'bx; MemRW = 1'bx;
                    end
  endcase
 end

endmodule