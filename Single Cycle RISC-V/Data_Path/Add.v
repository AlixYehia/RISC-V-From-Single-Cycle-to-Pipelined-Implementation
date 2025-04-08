`timescale 1ps/1fs

module Add #(parameter DATA_WIDTH = 32)(
	input	wire	[DATA_WIDTH-1:0]	PC,
	output	reg		[DATA_WIDTH-1:0]	PC_Plus_4
	);

always@(*)
 begin
 	#10 PC_Plus_4 = PC + 3'd4; // Simple Logic Delay
 end

endmodule