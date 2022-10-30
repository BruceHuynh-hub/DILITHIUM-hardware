all:
	@echo "libcmd           Prepare library command file"
	@echo "iver             Simulate with iVerilog"
	@echo "clean            Cleanup"


libcmd:
	ls /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells | awk '{print "+libdir+/mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/" $$0;}' >lib.cmd
	ls /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells | awk '{print "+incdir+/mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/" $$0;}' >>lib.cmd

# FUNCTIONAL
# specifies that functional views must be used for stdcells
# (default - BEHAVIORAL - does not seem to work)

iver:
	iverilog -DFUNCTIONAL -c lib.cmd ../syn/mymult1_gl.v  mymulttb.v

clean:
	rm -rf  *~ *vcd a.out lib.cmd
