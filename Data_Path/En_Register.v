module En_Register #(parameter DATA_WIDTH = 32) (
	input	wire						clk,
	input	wire						rst_n,
	input   wire                        En,
	input 	wire	[DATA_WIDTH-1:0]	In,
	output 	reg 	[DATA_WIDTH-1:0]	Out
	);

always@(posedge clk or negedge rst_n)
 begin
  if (!rst_n)
  	Out <= 'b0;
  else if (En)
  	Out <= In;
 end

endmodule
