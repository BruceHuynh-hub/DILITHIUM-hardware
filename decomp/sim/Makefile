all:
	@echo "iver		Simulate with iVerilog"
	@echo "clean		Cleanup"

iver:
	iverilog -o my_design ../decomp/coeff_decomposer.v ../decomp/decomp_map1.v ../decomp/decomposer_unit.v

clean:
	rm -rf a.out *~ trace.vcd