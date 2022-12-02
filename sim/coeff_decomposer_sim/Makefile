TOPLEVEL = coeff_decomposer_tb.v

all:
	@echo "iver		Simulate with iVerilog"
	@echo "clean		Cleanup"


iver:
	iverilog -y ../../rtl coeff_decomposer.v -y ../../rtl decomp_map1.v

clean:
	rm -rf a.out *~ trace_coeff.vcd