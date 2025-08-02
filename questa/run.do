vlib work
vlog reg_mux.v proj1.v DSP_tb.v 
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all
#quit -sim