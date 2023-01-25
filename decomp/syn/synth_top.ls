read_liberty -lib /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog ../rtl/combined_top.v
read_verilog ../rtl/address_resolver.v
read_verilog ../rtl/address_unit.v
read_verilog ../rtl/Barrett_8380417.v
read_verilog ../rtl/butterfly2x2.v
read_verilog ../rtl/butterfly.v
read_verilog ../rtl/cells.v
read_verilog ../rtl/coeff_decomposer.v
read_verilog ../rtl/
read_verilog ../rtl/
read_verilog ../rtl/
read_verilog ../rtl/
read_verilog ../rtl/
read_verilog ../rtl/


synth -top decomposer_unit
flatten
dfflibmap -liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
opt_clean

stat -liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib 
write_verilog combined_top_gl.v
