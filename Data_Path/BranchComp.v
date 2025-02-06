`timescale 1ps/1fs

module BranchComp #(parameter DATA_WIDTH = 32) (
	input	wire	[DATA_WIDTH-1:0]	DataA,
	input	wire	[DATA_WIDTH-1:0]	DataB,
	input	wire						BrUn,
	output	reg							BrEq,
	output	reg							BrLT
	);

always@(*)
 begin
  #50; // Major Stage Delay
  if (BrUn == 1'b1)
   begin
	if ($signed(DataA) < $signed(DataB))
	 BrLT = 1'b1;
	else
	 BrLT = 1'b0;
	if ($signed(DataA) == $signed(DataB))
	 BrEq = 1'b1;
	else
	 BrEq = 1'b0;
   end
  else
   begin
	if ((DataA) < (DataB))
     BrLT = 1'b1;
	else
	 BrLT = 1'b0;
	if ((DataA) == (DataB))
	 BrEq = 1'b1;
	else
	 BrEq = 1'b0;
   end
 end

// assign #10 BrEq = (DataA == DataB);
// assign #10 BrLT = (BrUn) ? (DataA < DataB) : ( $signed(DataA) < $signed(DataB) );

endmodule