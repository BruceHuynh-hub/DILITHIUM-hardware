all:
	@echo "iver		Simulate with iVerilog"
	@echo "clean		Cleanup"

iver:
	iverilog -o my_design coeff_decomposer.v decomp_map1.v decomposer_unit.v

clean:
	rm -rf a.out *~ trace.vcd