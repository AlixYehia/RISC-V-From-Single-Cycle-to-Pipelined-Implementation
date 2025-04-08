`timescale 1ps/1fs

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

module ImmGen (
    input  wire [31:7] Instr,
    input  wire [2:0]  ImmSel,
    output reg  [31:0] Imm
);

always @(*)
 begin
  #10; // Simple Loigc Delay
  casex (ImmSel)
   3'b001 : Imm = {{21{Instr[31]}}, Instr[30:20]};                                // I-type (includes JALR)
   3'b010 : Imm = {{21{Instr[31]}}, Instr[30:25], Instr[11:7]};                   // S-type
   3'b011 : Imm = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};   // B-type
   3'b100 : Imm = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}; // J-type
   3'b101 : Imm = {{13{Instr[31]}}, Instr[30:12]};                                // U-type
   default: Imm = 32'bx;                                                          // to check in testbench for illegal cases
  endcase
 end

endmodule