onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISC_V_tb/clk_tb
add wave -noupdate /RISC_V_tb/rst_n_tb
add wave -noupdate /RISC_V_tb/Mem
add wave -noupdate -radix decimal /RISC_V_tb/Addr_IMEM
add wave -noupdate -radix decimal /RISC_V_tb/Addr_DMEM
add wave -noupdate /RISC_V_tb/Rs2
add wave -noupdate /RISC_V_tb/DUT/U_Data_Path/Pipelined_Instr_1
add wave -noupdate /RISC_V_tb/MemRW
add wave -noupdate -expand -group IMEM /RISC_V_tb/U_IMEM/Addr
add wave -noupdate -expand -group IMEM /RISC_V_tb/DUT/U_Data_Path/Pipelined_Instr_1
add wave -noupdate -expand -group IMEM /RISC_V_tb/U_IMEM/Mem
add wave -noupdate -color Pink -radix decimal /RISC_V_tb/DUT/U_Data_Path/U0_PC/PC_Out
add wave -noupdate -expand -group {PC Mux} /RISC_V_tb/DUT/U_Data_Path/U0_PC_Mux/Sel
add wave -noupdate -expand -group {PC Mux} /RISC_V_tb/DUT/U_Data_Path/U0_PC_Mux/In0
add wave -noupdate -expand -group {PC Mux} /RISC_V_tb/DUT/U_Data_Path/U0_PC_Mux/In1
add wave -noupdate -expand -group {PC Mux} -radix decimal /RISC_V_tb/DUT/U_Data_Path/U0_PC_Mux/Out
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/DataD
add wave -noupdate -expand -group RegisterFile -radix unsigned /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/AddrD
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/AddrA
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/AddrB
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegWEn
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/DataA
add wave -noupdate -expand -group RegisterFile /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/DataB
add wave -noupdate -expand -group RegisterFile -childformat {{{/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[28]} -radix hexadecimal} {{/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[30]} -radix decimal} {{/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[31]} -radix decimal}} -expand -subitemconfig {{/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[28]} {-height 15 -radix hexadecimal} {/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[30]} {-color Violet -height 15 -radix decimal} {/RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile[31]} {-color Blue -height 15 -radix decimal}} /RISC_V_tb/DUT/U_Data_Path/U0_Register_File/RegFile
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/U0_WriteBack_Mux/Sel
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/U0_WriteBack_Mux/In0
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/U0_WriteBack_Mux/In1
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/U0_WriteBack_Mux/In2
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/U0_WriteBack_Mux/Out
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/Pipelined_Mem_Mux
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/Pipelined_ALU_Result_Mux
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/Pipelined_PC_Plus_4_Out_Mux
add wave -noupdate -expand -group Mux3x1 /RISC_V_tb/DUT/U_Data_Path/Write_Back_Mux3x1
add wave -noupdate -expand -group ALU /RISC_V_tb/DUT/U_Data_Path/U0_ALU/ALUSel
add wave -noupdate -expand -group ALU -radix unsigned /RISC_V_tb/DUT/U_Data_Path/Rs1_ALU
add wave -noupdate -expand -group ALU -radix decimal /RISC_V_tb/DUT/U_Data_Path/Rs2_ALU
add wave -noupdate -expand -group ALU -radix unsigned /RISC_V_tb/DUT/U_Data_Path/Pipelined_ALU_Result
add wave -noupdate /RISC_V_tb/clk_tb
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/clk
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/rst_n
add wave -noupdate -expand -group Hazard_Unit -color Magenta /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Instr_1
add wave -noupdate -expand -group Hazard_Unit -color Cyan /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Instr_2
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Instr_3
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Pipelined_ALU_Result
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Write_Back_Mux3x1
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Pipelined_Rs1
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Pipelined_Rs2
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Rs1_Forwarding_Result
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Rs2_Forwarding_Result
add wave -noupdate -expand -group Hazard_Unit -color Orange /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Instr_Hazard
add wave -noupdate -expand -group Hazard_Unit -color Orange /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/PC_Hazard
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Rs1_Mux_Sel
add wave -noupdate -expand -group Hazard_Unit /RISC_V_tb/DUT/U_Data_Path/U0_Hazard_Unit/Rs2_Mux_Sel
add wave -noupdate -expand -group ImmGen /RISC_V_tb/DUT/U_Data_Path/U0_ImmGen/Instr
add wave -noupdate -expand -group ImmGen /RISC_V_tb/DUT/U_Data_Path/U0_ImmGen/ImmSel
add wave -noupdate -expand -group ImmGen /RISC_V_tb/DUT/U_Data_Path/U0_ImmGen/Imm
add wave -noupdate -color Pink -radix decimal /RISC_V_tb/DUT/U_Data_Path/U0_PC/PC_Out
add wave -noupdate -expand -group DMEM -expand -subitemconfig {{/RISC_V_tb/U_DMEM/memory[0]} {-color Cyan -height 15}} /RISC_V_tb/U_DMEM/memory
add wave -noupdate -expand -group DMEM /RISC_V_tb/U_DMEM/MemRW
add wave -noupdate -expand -group ID -color Violet /RISC_V_tb/DUT/U_Control_Logic_Decode/Instr
add wave -noupdate -expand -group ID /RISC_V_tb/DUT/U_Control_Logic_Decode/ImmSel
add wave -noupdate -expand -group ID /RISC_V_tb/DUT/U_Control_Logic_Decode/Instruction_Type
add wave -noupdate -expand -group BranchComp -color Gold /RISC_V_tb/DUT/U_Data_Path/U0_BranchComp/DataA
add wave -noupdate -expand -group BranchComp /RISC_V_tb/DUT/U_Data_Path/U0_BranchComp/DataB
add wave -noupdate -expand -group BranchComp /RISC_V_tb/DUT/U_Data_Path/U0_BranchComp/BrUn
add wave -noupdate -expand -group BranchComp -color Cyan /RISC_V_tb/DUT/U_Data_Path/U0_BranchComp/BrEq
add wave -noupdate -expand -group BranchComp /RISC_V_tb/DUT/U_Data_Path/U0_BranchComp/BrLT
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/Instr
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/BrEq
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/BrLT
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/BrUn
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/BSel
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/ASel
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/ALUSel
add wave -noupdate -expand -group EX /RISC_V_tb/DUT/U_Control_Logic_Execute/Instruction_Type
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/Instr
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/BrEq
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/BrLT
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/PCSel
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/MemRW
add wave -noupdate -expand -group M /RISC_V_tb/DUT/U_Control_Logic_Memory/Instruction_Type
add wave -noupdate -expand -group WB -radix hexadecimal /RISC_V_tb/DUT/U_Control_Logic_Write/Instr
add wave -noupdate -expand -group WB /RISC_V_tb/DUT/U_Control_Logic_Write/RegWEn
add wave -noupdate -expand -group WB /RISC_V_tb/DUT/U_Control_Logic_Write/WBSel
add wave -noupdate -expand -group WB /RISC_V_tb/DUT/U_Control_Logic_Write/Instruction_Type
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {115160415 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 221
configure wave -valuecolwidth 84
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {110970921 fs} {122580478 fs}
