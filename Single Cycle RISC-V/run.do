vlib work

vlog *.*v

vsim -voptargs=+acc work.RISC_V_tb

do wave.do

run -all