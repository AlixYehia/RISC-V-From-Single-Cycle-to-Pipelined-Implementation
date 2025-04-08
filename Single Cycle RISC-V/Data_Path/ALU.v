`timescale 1ps/1fs

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

module ALU #(parameter DATA_WIDTH = 32) (
    input  wire [DATA_WIDTH-1:0] Src_A,
    input  wire [DATA_WIDTH-1:0] Src_B,
    input  wire [3:0]            ALUSel,
    output reg  [DATA_WIDTH-1:0] ALU_Result
    );

wire [DATA_WIDTH-1:0] Src_B_inv_or_not;
wire [DATA_WIDTH-1:0] result;
    
assign Src_B_inv_or_not = ALUSel[3] ? ~Src_B : Src_B;
assign result = Src_A + Src_B_inv_or_not + ALUSel[3];


always @(*) 
 begin
    #50; // Major Stage Delay
    casex (ALUSel[2:0])
        3'b000  : ALU_Result = result;  // add & sub 
/*
        modification is needed for ALUSel

        4'b0001: ALU_Result = Src_A << Src_B;                                    // sll
        4'b0010: ALU_Result = ($signed(Src_A) < $signed(Src_B))? 32'b1 : 32'b0;  // slt
        4'b0011: ALU_Result = (Src_A < Src_B)? 32'b1 : 32'b0;                    // sltu
        4'b0100: ALU_Result = Src_A ^ Src_B;                                     // xor
        4'b0101: ALU_Result = Src_A >> Src_B;                                    // srl
        4'b1101: ALU_Result = Src_A >>> Src_B;                                   // sra
*/
        3'b110  : ALU_Result = Src_A | Src_B;
        3'b111  : ALU_Result = Src_A & Src_B;
        default : ALU_Result = 'bx;                                              // to check in testbench for illegal cases if happened
    endcase
 end

endmodule