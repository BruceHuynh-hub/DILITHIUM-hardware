read_liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog mymult1_gl.v
link_design mymult1
create_clock -name clk -period 10 {clk}
set_input_delay -clock clk 0 {reset a b start clk}
report_checks
report_power
exit
