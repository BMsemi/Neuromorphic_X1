vlib work
vmap work work

vlog +acc +sv Neuromorphic_X1_Beh.v tb_neuromorphic_x1.v wb_pin_mapping_tb_1.v

vsim work.wb_pin_mapping_tb_1

add wave -position insertpoint sim:/wb_pin_mapping_tb_1/*
add wave -position insertpoint sim:/wb_pin_mapping_tb_1/dut/core_inst/*

run -all