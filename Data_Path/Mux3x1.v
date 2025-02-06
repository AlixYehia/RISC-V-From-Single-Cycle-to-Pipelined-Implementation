`timescale 1ps/1fs

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

module Mux3x1 #(parameter DATA_WIDTH = 32)(
    input  wire [1:0]            Sel,
    input  wire [DATA_WIDTH-1:0] In0,
    input  wire [DATA_WIDTH-1:0] In1,
    input  wire [DATA_WIDTH-1:0] In2,
    output reg  [DATA_WIDTH-1:0] Out
);

always @(*) 
 begin
  #10; // Simple Logic Delay
  case (Sel)
   2'b00  : Out = In0;
   2'b01  : Out = In1;
   2'b10  : Out = In2;
   default: Out = {DATA_WIDTH{1'b0}};
  endcase
 end

endmodule