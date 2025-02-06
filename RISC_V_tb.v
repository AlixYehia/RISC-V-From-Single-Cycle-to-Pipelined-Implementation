`include "Memory/IMEM.v"
`include "Memory/DMEM.v"

`timescale 1ps/1fs

module RISC_V_tb ();

///////////////////////////////////////////////////////////////
///////////////////////// Parameters //////////////////////////
///////////////////////////////////////////////////////////////

parameter CLK_PERIOD = 1000;  // 1ns
parameter DATA_WIDTH = 32;
parameter MEM_SIZE   = 256;

///////////////////////////////////////////////////////////////
//////////////////////// DUT Signals //////////////////////////
///////////////////////////////////////////////////////////////

reg                 clk_tb;
reg                 rst_n_tb;

wire [31:0]         Mem;       // used to connect risc_v input of wb_mux to output of DMEM DataR

wire [31:0]         Addr_IMEM;
wire [31:0]         Addr_DMEM;
wire [31:0]         Rs2;
wire [31:0]         Instr;
wire                MemRW;

///////////////////////////////////////////////////////////////
//////////////////////// Clock Generation /////////////////////
///////////////////////////////////////////////////////////////

initial 
 begin
    clk_tb = 0;
    forever #(CLK_PERIOD / 2) clk_tb = ~clk_tb;
 end

///////////////////////////////////////////////////////////////
//////////////////////// DUT Instantiations ///////////////////
///////////////////////////////////////////////////////////////

RISC_V #(.DATA_WIDTH(DATA_WIDTH)) DUT (
    .clk(clk_tb),
    .rst_n(rst_n_tb),
    .Instr(Instr),
    .Mem(Mem),
    .Addr_IMEM(Addr_IMEM),
    .Addr_DMEM(Addr_DMEM),
    .Rs2(Rs2),
    .MemRW(MemRW)
);

IMEM #(.DATA_WIDTH(DATA_WIDTH), .MEM_SIZE(MEM_SIZE)) U_IMEM (
    .Addr(Addr_IMEM/4),      // divide by 4 because PC increments by 4 each time so we access one whole word at a time so to overcome this we divide the PC by 4 to make it move by 1 at a time
    .Instr(Instr)        
);

DMEM #(.DATA_WIDTH(DATA_WIDTH), .MEM_SIZE(MEM_SIZE)) U_DMEM (
    .clk(clk_tb),
    .MemRW(MemRW),
    .Addr(Addr_DMEM[9:2]),   // Since the memory is word-addressable, each location holds 4 bytes. The lower 2 bits (1 and 0) of the address are not needed because they represent the byte offset within a word.
    .DataW(Rs2),
    .DataR(Mem)
);

///////////////////////////////////////////////////////////////
//////////////////////// Initial Block ////////////////////////
///////////////////////////////////////////////////////////////

initial 
 begin
    // System functions
    $dumpfile("RISC_V_tb.vcd");
    $dumpvars;

    reset();
    

    #(120*CLK_PERIOD)

    $display("\n****** Piplined RISC-V with Hazard Unit ******\n");

    $display("Value stored in the register (t0): %0d", DUT.U_Data_Path.U0_Register_File.RegFile[5]);

    $display("Value stored in the register (t6): %0d", DUT.U_Data_Path.U0_Register_File.RegFile[31]);
    
    $display("Value stored in the register (t5): %0d", DUT.U_Data_Path.U0_Register_File.RegFile[30]);
    
    $display("Value stored in the register (t1): %0d", DUT.U_Data_Path.U0_Register_File.RegFile[6]);


    $display("Value stored in the Data Memory (Address 0): %0d\n", U_DMEM.memory[0]);


    $stop;
 end




///////////////////////////////////////////////////////////////
/////////////////////////// Tasks /////////////////////////////
///////////////////////////////////////////////////////////////


//////////////////////// Reset ///////////////////////////////

task reset;
 begin
    rst_n_tb = 1'b1;
    #(CLK_PERIOD)
    rst_n_tb = 1'b0;
    #(CLK_PERIOD)
    rst_n_tb = 1'b1;
 end
endtask



endmodule