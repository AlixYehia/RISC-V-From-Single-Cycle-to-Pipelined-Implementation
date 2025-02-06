module En_Clr_Register #(parameter DATA_WIDTH = 32) (
	input	wire						clk,
	input	wire						rst_n,
	input   wire                        En,
	input   wire                        Clr,
	input 	wire	[DATA_WIDTH-1:0]	In,
	output 	reg 	[DATA_WIDTH-1:0]	Out
	);

always@(posedge clk or negedge rst_n)
 begin
  if (!rst_n)
  	Out <= 32'b0;
  else if (En)
   	if (!Clr)
   	 Out <= In;
   	else
     Out <= 32'b0;
 end

endmodule