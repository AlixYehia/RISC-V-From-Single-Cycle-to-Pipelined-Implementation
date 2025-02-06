`timescale 1ps/1fs

module Mux2x1 #(parameter DATA_WIDTH = 32)(
	input	wire						Sel,
	input	wire	[DATA_WIDTH-1:0]	In0,
	input	wire	[DATA_WIDTH-1:0]	In1,
	output	reg		[DATA_WIDTH-1:0]	Out
	);

always@(*)
 begin
  #10; // Simple Logic Delay
  if(Sel)
   Out = In1;
  else
   Out = In0;
 end


endmodule