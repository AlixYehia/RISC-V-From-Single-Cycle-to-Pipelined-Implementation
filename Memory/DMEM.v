`timescale 1ps/1fs

module DMEM #(parameter DATA_WIDTH = 32, MEM_SIZE = 256) (
    input  wire                  clk,
    input  wire                  MemRW,
    input  wire [7:0] Addr,
    input  wire [DATA_WIDTH-1:0] DataW,           // Data to be written
    output reg  [DATA_WIDTH-1:0] DataR            // Data read from memory
	);


reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];

// Memory Read Operation (Combinational)
always @(*) 
 begin
  #100;
  if (!MemRW) 
   DataR = memory[Addr[7:0]];
  else 
   DataR = 32'bx;
 end

// Memory Write Operation
always @(posedge clk) 
 begin
    #100
    if (MemRW)
   	 memory[Addr[7:0]] <= DataW;
 end


endmodule