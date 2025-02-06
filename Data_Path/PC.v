`timescale 1ps/1fs

module PC #(parameter DATA_WIDTH = 32)(
	input	wire						clk,
	input	wire						rst_n,
	input	wire                        En,     // Added for Load Hazard
	input	wire	[DATA_WIDTH-1:0]	PC_In,
	output	reg		[DATA_WIDTH-1:0]	PC_Out
	);

always@(posedge clk or negedge rst_n)
 begin
  //#10; // Simple Logic Delay
  if(!rst_n)
   PC_Out <= 'b0;
  else if (En)        // Modified for Hazard
   PC_Out <= PC_In;
 end


endmodule