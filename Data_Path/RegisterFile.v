`timescale 1ps/1fs

module RegisterFile #(parameter DATA_WIDTH = 32) (
    input   wire                  clk,
    input   wire [DATA_WIDTH-1:0] DataD,          // Data to be written to the destination register
    input   wire [4:0]            AddrD,          // Destination register address
    input   wire [4:0]            AddrA,          // Source register 1 address
    input   wire [4:0]            AddrB,          // Source register 2 address
    input   wire                  RegWEn,
    output  wire [DATA_WIDTH-1:0] DataA,          // Data from source register 1
    output  wire [DATA_WIDTH-1:0] DataB           // Data from source register 2
    );


reg [DATA_WIDTH-1:0] RegFile [0:31];


// Read ports and hard wire x0 to '0'
assign DataA = (AddrA == 0) ? {DATA_WIDTH{1'b0}} : RegFile[AddrA];
assign DataB = (AddrB == 0) ? {DATA_WIDTH{1'b0}} : RegFile[AddrB];

// Write port (write on the negedge clock "later needed in pipeline") and prevent writing to x0
always @(negedge clk) 
begin
 #50; // Major Stage Delay
 if (RegWEn && AddrD != 5'b0)
  RegFile[AddrD] <= DataD;
end

endmodule