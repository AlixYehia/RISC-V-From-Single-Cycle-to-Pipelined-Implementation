`timescale 1ps / 1fs

module IMEM #(parameter DATA_WIDTH = 32, MEM_SIZE = 256) (
    input   wire     [31:0] Addr,
    output  reg      [31:0] Instr
);

reg [DATA_WIDTH-1:0] Mem [0:MEM_SIZE-1];

initial 
begin
    $readmemh("Memory/instructions.txt", Mem);  // Load instructions from a file
end

// Instruction Memory Delay
always @(*) begin
    #100 Instr = Mem[Addr];
end

endmodule